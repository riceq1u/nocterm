import 'package:nocterm/nocterm.dart';

/// Fixed demonstration showing proper emoji alignment
void main() async {
  runApp(const DemoApp());
}

class DemoApp extends StatelessComponent {
  const DemoApp();

  @override
  Component build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          InteractiveThingy(),
          const Header(),
          const SizedBox(height: 2),
          Expanded(
              child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color.fromRGB(0, 255, 255),
              border: BoxBorder.all(color: Color.fromRGB(200, 0, 0), width: 1),
            ),
            child: ContentSection(),
          )),
          const SizedBox(height: 2),
          const Footer(),
        ],
      ),
    );
  }
}

class InteractiveThingy extends StatefulComponent {
  const InteractiveThingy();

  @override
  State<StatefulComponent> createState() {
    return InteractiveThingyState();
  }
}

class InteractiveThingyState extends State<InteractiveThingy> {
  int _counter = 0;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _startCounting();
  }

  void _startCounting() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_disposed) return;
      setState(() {
        _counter++;
      });
      _startCounting();
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return Text('Timer: $_counter');
  }
}

class Header extends StatelessComponent {
  const Header();

  @override
  Component build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Color.fromRGB(200, 0, 0), width: 2),
      ),
      child: Text('Flutter-like TUI Framework:'),
    );
  }
}

class ContentSection extends StatelessComponent {
  const ContentSection();

  @override
  Component build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('✨ Features:'),
        const SizedBox(height: 1),
        // Use a left-aligned column for the bullet points
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('• Component-based architecture'),
            Text('• Constraint-based layout system'),
            Text('• Stateful and Stateless components'),
            Text('• BuildContext for tree traversal'),
            Text('• RenderObject for painting'),
          ],
        ),
        const SizedBox(height: 2),
        const Text('Built with Dart'),
        const Text('Inspired by Flutter/Jaspr'),
      ],
    );
  }
}

class Footer extends StatelessComponent {
  const Footer();

  @override
  Component build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('────────────────────────────────────────'),
        Text('Ready for reactive terminal UIs! 🚀'),
        Text(''),
        Text('Press ESC or Ctrl+C to exit'),
      ],
    );
  }
}
