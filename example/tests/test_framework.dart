import 'package:nocterm/nocterm.dart';

void main() {
  print('Starting reactive TUI test...');

  try {
    runApp(const TestApp());
  } catch (e, stack) {
    print('Error: $e');
    print('Stack: $stack');
  }
}

class TestApp extends StatelessComponent {
  const TestApp();

  @override
  Component build(BuildContext context) {
    print('Building TestApp...');
    return const Text('Hello World!');
  }
}
