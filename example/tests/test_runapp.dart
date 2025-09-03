import 'dart:async';

import 'package:nocterm/nocterm.dart';

void main() async {
  // Run app with automatic shutdown after 2 seconds for testing
  Timer(const Duration(milliseconds: 500), () {
    print('\n\nApp ran successfully! Shutting down...');
    try {
      TerminalBinding.instance.shutdown();
    } catch (e) {
      // Instance might not be available yet
    }
  });

  await runApp(const TestApp());
}

class TestApp extends StatelessComponent {
  const TestApp();

  @override
  Component build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('✨ TUI App is running!'),
          Text('Will auto-exit in 2 seconds...'),
        ],
      ),
    );
  }
}
