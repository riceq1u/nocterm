import 'dart:async';
import 'package:nocterm/nocterm.dart';

void main() async {
  // Auto-exit after 5 seconds for demonstration
  Timer(const Duration(seconds: 5), () {
    print('\n\nDemo completed! The timer updated successfully.');
    try {
      TerminalBinding.instance.shutdown();
    } catch (e) {
      // Instance might not be available yet
    }
  });

  await runApp(const DemoApp());
}

/// Demo app showing the reactive architecture
class DemoApp extends StatelessComponent {
  const DemoApp();

  @override
  Component build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const InteractiveThingy(),
          const Header(),
          const SizedBox(height: 2),
          Expanded(child: const ContentSection()),
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
    return Text('Timer: $_counter seconds');
  }
}

class Header extends StatelessComponent {
  const Header();

  @override
  Component build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('╭──────────────────────────────────────╮'),
        Row(mainAxisSize: MainAxisSize.min, children: [
          Text('│    '),
          Text('Flutter-like TUI Framework'),
          Text('     │'),
        ]),
        Text('╰──────────────────────────────────────╯'),
      ],
    );
  }
}

class ContentSection extends StatelessComponent {
  const ContentSection();

  @override
  Component build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('✨ Features:'),
        Text('  • Component-based architecture'),
        Text('  • Constraint-based layout system'),
        Text('  • Stateful and Stateless components'),
        Text('  • BuildContext for tree traversal'),
        Text('  • RenderObject for painting'),
        SizedBox(height: 1),
        Row(children: [Text('  Built with '), Text('Dart'), Text(' inspired by '), Text('Flutter/Jaspr')]),
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
        Text('Auto-exit in 5 seconds...'),
      ],
    );
  }
}
