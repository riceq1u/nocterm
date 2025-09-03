import 'dart:async';
import 'package:nocterm/nocterm.dart';
import 'package:nocterm/src/framework/terminal_canvas.dart';

/// A simple render object that acts as a repaint boundary
class RenderRepaintBoundary extends RenderObject with RenderObjectWithChildMixin<RenderObject> {
  @override
  void performLayout() {
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = child!.size;
    } else {
      size = constraints.constrain(Size.zero);
    }
  }

  @override
  void paint(TerminalCanvas canvas, Offset offset) {
    super.paint(canvas, offset);
    print('[RepaintBoundary] Painting at $offset with size $size');
    if (child != null) {
      child!.paint(canvas, offset);
    }
  }
}

/// Component that creates a repaint boundary
class RepaintBoundary extends SingleChildRenderObjectComponent {
  const RepaintBoundary({super.key, required this.child});

  final Component child;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderRepaintBoundary();
  }
}

/// A simple counter that updates frequently
class Counter extends StatefulComponent {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update counter every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _counter++;
        print('[Counter] Incrementing to $_counter - triggering rebuild');
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    print('[Counter] Building with value $_counter');
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Text('Counter: $_counter'),
    );
  }
}

/// Main app to test paint marking
class TestApp extends StatelessComponent {
  const TestApp({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      children: [
        // Static header - shouldn't repaint when counter changes
        const Padding(
          padding: EdgeInsets.all(1),
          child: Text('Paint Marking Test'),
        ),

        const Text(''),

        // Counter wrapped in repaint boundary
        // This should limit paint invalidation to just this subtree
        const RepaintBoundary(
          child: Counter(),
        ),

        const Text(''),

        // Static footer - shouldn't repaint when counter changes
        const Padding(
          padding: EdgeInsets.all(1),
          child: Text('The counter above is in a RepaintBoundary'),
        ),

        const Text('Press Escape to exit'),
      ],
    );
  }
}

void main() async {
  print('[Main] Starting paint marking test');
  print('[Main] The counter will update every second');
  print('[Main] With proper paint marking, only the counter area should repaint');
  print('');

  final terminal = Terminal();
  final binding = TerminalBinding(terminal);

  binding.initialize();
  binding.attachRootComponent(const TestApp());

  // Run for 5 seconds then exit
  Timer(const Duration(seconds: 5), () {
    print('\n[Main] Test complete - shutting down');
    binding.shutdown();
  });

  await binding.runEventLoop();
}
