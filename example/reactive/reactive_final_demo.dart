import 'dart:math';

import 'package:nocterm/nocterm.dart';

/// Final demonstration of the reactive TUI framework
void main() async {
  // Simply run the app - the binding handles everything
  runApp(const DemoApp());
}

/// Demo app showing the reactive architecture
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

class ContentSection extends StatefulComponent {
  const ContentSection();

  @override
  State<StatefulComponent> createState() => _ContentSectionState();
}

class _ContentSectionState extends State<ContentSection> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        selectedIndex = Random().nextInt(10);
      });
    });
  }

  @override
  Component build(BuildContext context) {
    print('Rebuilding ContentSection');
    return Focusable(
      focused: true,
      onKeyEvent: (event) {
        setState(() {
          selectedIndex = Random().nextInt(10);
        });
        if (event.logicalKey == LogicalKey.arrowUp) {
          setState(() {
            selectedIndex--;
          });
          return true;
        }
        if (event.logicalKey == LogicalKey.arrowDown) {
          print('event.logicalKey: $event.logicalKey down');
          setState(() {
            selectedIndex++;
          });
          return true;
        }
        return false;
      },
      child: TestComponent(text: '✨ Features: ${selectedIndex + 1}'),
    );
  }
}

class TestComponent extends StatelessComponent {
  const TestComponent({required this.text});

  final String text;

  @override
  Component build(BuildContext context) {
    return Text(text);
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
