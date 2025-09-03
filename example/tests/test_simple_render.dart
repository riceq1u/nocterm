import 'dart:io';

import 'package:nocterm/nocterm.dart';
import 'package:nocterm/src/framework/terminal_canvas.dart';
import 'package:nocterm/src/rectangle.dart';

void main() {
  print('Testing simple render...');

  // Create components
  final app = const Column(
    children: [
      Text('Hello, Reactive TUI!'),
      Text(''),
      Row(
        children: [
          Text('This '),
          Text('is '),
          Text('horizontal'),
        ],
      ),
      Text(''),
      Text('Press Ctrl+C to exit'),
    ],
  );

  // Setup terminal
  final terminal = Terminal();
  terminal.enterAlternateScreen();
  terminal.hideCursor();
  terminal.clear();

  // Create binding and render
  final binding = SimpleBinding(terminal);
  binding.attachRootComponent(app);
  binding.drawFrame();

  // Wait a bit then exit
  sleep(Duration(seconds: 3));

  // Cleanup
  try {
    terminal.reset();
  } catch (e) {
    // Ignore cleanup errors
  }
  print('\nTest complete!');
}

class SimpleBinding extends NoctermBinding {
  SimpleBinding(this.terminal);

  final Terminal terminal;

  @override
  void drawFrame() {
    print('Drawing frame...');
    if (rootElement == null) {
      print('No root element!');
      return;
    }

    // Build phase
    super.drawFrame();
    print('Build phase complete');

    // Get size
    final size = terminal.size;
    final buffer = Buffer(size.width.toInt(), size.height.toInt());

    // Layout phase - look for RenderObject in tree
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
      print('Found render object, performing layout...');
      renderObject.layout(BoxConstraints.tight(
        Size(size.width.toDouble(), size.height.toDouble()),
      ));

      // Paint phase
      print('Painting...');
      final canvas = TerminalCanvas(
        buffer,
        Rect.fromLTWH(0, 0, size.width.toDouble(), size.height.toDouble()),
      );
      renderObject.paint(canvas, Offset.zero);
    } else {
      print('No render object found!');
    }

    // Render to terminal
    terminal.moveTo(0, 0);
    for (int y = 0; y < buffer.height; y++) {
      for (int x = 0; x < buffer.width; x++) {
        final cell = buffer.getCell(x, y);
        terminal.write(cell.char);
      }
      if (y < buffer.height - 1) {
        terminal.write('\n');
      }
    }
    terminal.flush();

    print('Frame rendered!');
  }
}
