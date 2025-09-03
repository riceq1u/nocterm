import 'dart:io';
import 'package:dart_tui/tui_reactive.dart';

void main() async {
  await runApp(const TerminalSplitApp());
}

/// Main application using the new component system
class TerminalSplitApp extends StatefulComponent {
  const TerminalSplitApp();

  @override
  State<TerminalSplitApp> createState() => _TerminalSplitAppState();
}

class _TerminalSplitAppState extends State<TerminalSplitApp> {
  int focusedTerminal = 0;

  bool _handleGlobalKeys(KeyboardEvent event) {
    // Handle focus switching with arrow keys when holding Alt/Option
    if (event.alt) {
      if (event.logicalKey == LogicalKey.arrowLeft) {
        setState(() {
          focusedTerminal = 0;
        });
        return true;
      } else if (event.logicalKey == LogicalKey.arrowRight) {
        setState(() {
          focusedTerminal = 1;
        });
        return true;
      }
    }
    
    // Exit on Ctrl+Q
    if (event.ctrl && event.character == 'q') {
      exit(0);
    }
    
    return false;
  }

  @override
  Component build(BuildContext context) {
    return Focusable(
      focused: true,
      onKeyEvent: (event) {
        // Global key handling (always processed)
        return _handleGlobalKeys(event);
      },
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Left terminal
                Expanded(
                  child: TerminalPane(
                    title: focusedTerminal == 0 ? '[ Terminal 1 - FOCUSED ]' : 'Terminal 1',
                    focused: focusedTerminal == 0,
                    command: getShell(),
                    args: [],
                    onKeyEvent: _handleGlobalKeys,
                  ),
                ),
                // Right terminal  
                Expanded(
                  child: TerminalPane(
                    title: focusedTerminal == 1 ? '[ Terminal 2 - FOCUSED ]' : 'Terminal 2',
                    focused: focusedTerminal == 1,
                    command: getShell(),
                    args: [],
                    onKeyEvent: _handleGlobalKeys,
                  ),
                ),
              ],
            ),
          ),
          // Help text at the bottom
          Container(
            height: 1,
            decoration: BoxDecoration(
              color: Color.blue,
            ),
            child: Center(
              child: Text(
                'Use Alt+LEFT/RIGHT to switch focus | Press Ctrl+Q to quit',
                style: Style(fg: Color.yellow, bold: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Terminal pane component using the improved terminal with real PTY
class TerminalPane extends StatelessComponent {
  final String title;
  final bool focused;
  final String command;
  final List<String> args;
  final bool Function(KeyboardEvent)? onKeyEvent;

  const TerminalPane({
    required this.title,
    required this.focused,
    required this.command,
    required this.args,
    this.onKeyEvent,
  });

  @override
  Component build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(
          color: focused ? Color.green : Color.gray,
          width: focused ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title bar
          Container(
            height: 1,
            decoration: BoxDecoration(
              color: focused ? Color.green : Color.gray,
            ),
            child: Text(
              ' $title ',
              style: Style(
                fg: focused ? Color.black : Color.white,
                bold: true,
              ),
            ),
          ),
          // Terminal content using the xterm-based terminal component
          Expanded(
            child: TerminalXterm(
              command: command,
              args: args,
              focused: focused,
              maxLines: 10000,
              onKeyEvent: onKeyEvent,
              onExit: (code) {
                // Terminal exited
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Get the appropriate shell for the current platform
String getShell() {
  if (Platform.isMacOS || Platform.isLinux) {
    return Platform.environment['SHELL'] ?? 'bash';
  }

  if (Platform.isWindows) {
    return 'cmd.exe';
  }

  return 'sh';
}
