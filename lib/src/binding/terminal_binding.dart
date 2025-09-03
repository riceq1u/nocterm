import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:nocterm/nocterm.dart';
import 'package:nocterm/src/framework/terminal_canvas.dart';
import 'package:nocterm/src/rectangle.dart';

import '../backend/terminal.dart' as term;
import '../buffer.dart' as buf;
import '../keyboard/keyboard_parser.dart';
import 'hot_reload_mixin.dart';

/// Terminal UI binding that handles terminal input/output and event loop
class TerminalBinding extends NoctermBinding with HotReloadBinding {
  TerminalBinding(this.terminal) {
    _instance = this;
    _initializePipelineOwner();
  }

  static TerminalBinding? _instance;
  static TerminalBinding get instance => _instance!;

  final term.Terminal terminal;
  PipelineOwner? _pipelineOwner;
  PipelineOwner get pipelineOwner => _pipelineOwner!;

  Timer? _frameTimer;
  bool _shouldExit = false;
  final _inputController = StreamController<String>.broadcast();
  final _keyboardEventController = StreamController<KeyboardEvent>.broadcast();
  final _keyboardParser = KeyboardParser();
  StreamSubscription? _inputSubscription;
  StreamSubscription? _sigwinchSubscription;
  Size? _lastKnownSize;

  void _initializePipelineOwner() {
    _pipelineOwner = PipelineOwner();
    _pipelineOwner!.onNeedsVisualUpdate = scheduleFrame;
  }

  /// Stream of keyboard input events (raw strings)
  Stream<String> get input => _inputController.stream;

  /// Stream of parsed keyboard events
  Stream<KeyboardEvent> get keyboardEvents => _keyboardEventController.stream;

  /// Initialize the terminal and start the event loop
  void initialize() {
    // Setup terminal
    terminal.enterAlternateScreen();
    terminal.hideCursor();
    terminal.clear();

    // Store initial size
    _lastKnownSize = terminal.size;

    // Start listening for keyboard input
    _startInputHandling();

    // Start listening for terminal resize events
    _startResizeHandling();
  }

  void _startInputHandling() {
    // Only set stdin mode if we have a terminal
    try {
      if (stdin.hasTerminal) {
        stdin.echoMode = false;
        stdin.lineMode = false;
      }
    } catch (e) {
      // Ignore errors when running without a proper terminal
      // This happens in CI/CD environments or when piping output
    }

    // Listen for keyboard input at the byte level for proper escape sequence handling
    _inputSubscription = stdin.listen((bytes) {
      // Parse the bytes into a keyboard event
      final event = _keyboardParser.parseBytes(bytes);

      if (event != null) {
        // Add to keyboard event stream
        _keyboardEventController.add(event);

        // Route the event through the component tree
        _routeKeyboardEvent(event);
      } else {}

      // Exit on Ctrl+C or Escape (check when event is not null)
      if (event != null) {
        if (event.logicalKey == LogicalKey.escape || (event.matches(LogicalKey.keyC, ctrl: true))) {
          shutdown();
        }
      }

      // Also add raw string for backwards compatibility
      try {
        final str = utf8.decode(bytes);
        _inputController.add(str);
      } catch (e) {
        // Ignore decode errors for escape sequences
      }
    });
  }

  void _startResizeHandling() {
    // Listen for SIGWINCH signal on Unix systems
    if (Platform.isLinux || Platform.isMacOS) {
      _sigwinchSubscription = ProcessSignal.sigwinch.watch().listen((_) {
        _handleTerminalResize();
      });
    }

    // Also poll for size changes as a fallback
    // This helps on systems where SIGWINCH might not work properly
    Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_shouldExit) {
        _checkForSizeChange();
      }
    });
  }

  void _handleTerminalResize() {
    // Update terminal size and trigger a redraw
    if (stdout.hasTerminal) {
      final newSize = Size(stdout.terminalColumns.toDouble(), stdout.terminalLines.toDouble());
      if (_lastKnownSize == null ||
          _lastKnownSize!.width != newSize.width ||
          _lastKnownSize!.height != newSize.height) {
        _lastKnownSize = newSize;
        // Update the terminal's cached size
        terminal.updateSize(newSize);
        // Schedule a frame redraw
        scheduleFrame();
      }
    }
  }

  void _checkForSizeChange() {
    // Periodic check for size changes (fallback for systems without SIGWINCH)
    if (stdout.hasTerminal) {
      final currentSize = Size(stdout.terminalColumns.toDouble(), stdout.terminalLines.toDouble());
      if (_lastKnownSize == null ||
          _lastKnownSize!.width != currentSize.width ||
          _lastKnownSize!.height != currentSize.height) {
        _handleTerminalResize();
      }
    }
  }

  /// Route a keyboard event through the component tree
  void _routeKeyboardEvent(KeyboardEvent event) {
    if (rootElement == null) return;

    // Try to dispatch the event to the root element
    // The event will bubble through focused components
    _dispatchKeyToElement(rootElement!, event);
  }

  /// Dispatch a keyboard event to an element and its children
  bool _dispatchKeyToElement(Element element, KeyboardEvent event) {
    // First, try to dispatch to children (depth-first)
    bool handled = false;
    element.visitChildren((child) {
      if (!handled) {
        handled = _dispatchKeyToElement(child, event);
      }
    });

    // If no child handled it, and this element can handle keys, try it
    if (!handled && element is FocusableElement) {
      handled = element.handleKeyEvent(event);
    }

    return handled;
  }

  /// Run the main event loop
  Future<void> runEventLoop() async {
    // Initial frame
    drawFrame();

    // Keep the app running until shutdown is called
    while (!_shouldExit) {
      await Future.delayed(const Duration(milliseconds: 16)); // ~60 FPS max
    }
  }

  /// Shutdown the terminal and cleanup
  void shutdown() {
    _shouldExit = true;
    _frameTimer?.cancel();
    _inputSubscription?.cancel();
    _sigwinchSubscription?.cancel();
    _inputController.close();
    _keyboardEventController.close();

    // Stop hot reload if it was initialized
    shutdownWithHotReload();

    // Restore stdin if we have a terminal
    try {
      if (stdin.hasTerminal) {
        stdin.echoMode = true;
        stdin.lineMode = true;
      }
    } catch (e) {
      // Ignore errors when running without a proper terminal
    }

    // Restore terminal
    terminal.showCursor();
    terminal.leaveAlternateScreen();
    terminal.clear();
  }

  @override
  void scheduleFrame() {
    // Cancel any existing timer
    _frameTimer?.cancel();

    // Schedule frame to be drawn on next microtask
    // This batches updates that happen in the same event loop iteration
    _frameTimer = Timer(Duration.zero, () {
      drawFrame();
      _frameTimer = null;
    });
  }

  @override
  void drawFrame() {
    if (rootElement == null) return;

    // Build phase
    super.drawFrame();

    // Get current terminal size (may have been updated by resize event)
    final size = terminal.size;
    final buffer = buf.Buffer(size.width.toInt(), size.height.toInt());

    // Find render object in tree
    RenderObject? findRenderObject(Element element) {
      if (element is RenderObjectElement) {
        return element.renderObject;
      }
      RenderObject? result;
      element.visitChildren((child) {
        result ??= findRenderObject(child);
      });
      return result;
    }

    final renderObject = findRenderObject(rootElement!);
    if (renderObject != null) {
      // Attach render object to pipeline owner if needed
      if (renderObject.owner != pipelineOwner) {
        renderObject.attach(pipelineOwner);
      }

      // Layout phase
      renderObject.layout(BoxConstraints.tight(Size(size.width.toDouble(), size.height.toDouble())));

      // Flush layout pipeline
      pipelineOwner.flushLayout();

      // Flush paint pipeline
      pipelineOwner.flushPaint();

      // Paint phase - actually render to canvas
      final canvas = TerminalCanvas(
        buffer,
        Rect.fromLTWH(0, 0, size.width.toDouble(), size.height.toDouble()),
      );
      renderObject.paint(canvas, Offset.zero);
    }

    // Render to terminal
    terminal.moveTo(0, 0);
    for (int y = 0; y < buffer.height; y++) {
      for (int x = 0; x < buffer.width; x++) {
        final cell = buffer.getCell(x, y);

        // Skip zero-width space markers (used for emoji second column)
        if (cell.char == '\u200B') {
          continue;
        }

        // Apply style if present
        if (cell.style.color != null ||
            cell.style.backgroundColor != null ||
            cell.style.fontWeight == FontWeight.bold ||
            cell.style.fontWeight == FontWeight.dim ||
            cell.style.fontStyle == FontStyle.italic ||
            cell.style.decoration?.hasUnderline == true ||
            cell.style.reverse) {
          terminal.write(cell.style.toAnsi());
          terminal.write(cell.char);
          terminal.write(TextStyle.reset);
        } else {
          terminal.write(cell.char);
        }
      }
      if (y < buffer.height - 1) {
        terminal.write('\n');
      }
    }
    terminal.flush();
  }
}

/// Run a TUI application
Future<void> runApp(Component app, {bool enableHotReload = true}) async {
  // Open log file for capturing print statements
  final logFile = File('log.txt');
  final logSink = logFile.openWrite(mode: FileMode.writeOnly);

  try {
    await runZoned(() async {
      final terminal = term.Terminal();
      final binding = TerminalBinding(terminal);

      binding.initialize();
      binding.attachRootComponent(app);

      // Initialize hot reload in development mode
      if (enableHotReload && !bool.fromEnvironment('dart.vm.product')) {
        await binding.initializeHotReload();
      }

      await binding.runEventLoop();
    },
        zoneSpecification: ZoneSpecification(
          print: (Zone self, ZoneDelegate parent, Zone zone, String message) {
            // Write to log file instead of stdout
            logSink.writeln('[${DateTime.now().toIso8601String()}] $message');
          },
          handleUncaughtError: (Zone self, ZoneDelegate parent, Zone zone, Object error, StackTrace stackTrace) {
            logSink.writeln('[${DateTime.now().toIso8601String()}] $error ${stackTrace.toString()}');
          },
        ));
  } finally {
    await logSink.flush();
    await logSink.close();
  }
}
