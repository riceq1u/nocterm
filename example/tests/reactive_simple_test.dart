import 'package:nocterm/nocterm.dart';

void main() {
  runApp(const SimpleApp());
}

class SimpleApp extends StatelessComponent {
  const SimpleApp({super.key});

  @override
  Component build(BuildContext context) {
    return const Center(
      child: Text('Hello, Reactive TUI!'),
    );
  }
}

class Center extends StatelessComponent {
  const Center({
    super.key,
    required this.child,
  });

  final Component child;

  @override
  Component build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: child,
    );
  }
}
