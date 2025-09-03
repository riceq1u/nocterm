import 'dart:io';

import 'package:nocterm/nocterm.dart';
import 'package:nocterm/src/framework/terminal_canvas.dart';
import 'package:nocterm/src/rectangle.dart';

/// Test the improved flex implementation with Expanded and proper alignment
void main() {
  final terminal = Terminal();

  // Setup terminal
  terminal.enterAlternateScreen();
  terminal.hideCursor();
  terminal.clear();

  // Create a test app with flex components
  final app = TestFlexApp();

  // Create binding and render
  final binding = TestBinding(terminal);
  binding.attachRootComponent(app);
  binding.drawFrame();

  // Wait for user input
  stdin.readLineSync();

  // Cleanup
  terminal.showCursor();
  terminal.leaveAlternateScreen();
  terminal.clear();
}

class TestFlexApp extends StatelessComponent {
  const TestFlexApp();

  @override
  Component build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('╔══════════════════════════════════════╗'),
        const Text('║     Flex Layout Test with Expanded   ║'),
        const Text('╚══════════════════════════════════════╝'),
        const SizedBox(height: 1),

        // Test Row with different alignments
        const Text('Row with MainAxisAlignment.start:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text('[Start]'),
            Text('[Middle]'),
            Text('[End]'),
          ],
        ),

        const SizedBox(height: 1),
        const Text('Row with MainAxisAlignment.center:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('[Start]'),
            Text('[Middle]'),
            Text('[End]'),
          ],
        ),

        const SizedBox(height: 1),
        const Text('Row with MainAxisAlignment.end:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text('[Start]'),
            Text('[Middle]'),
            Text('[End]'),
          ],
        ),

        const SizedBox(height: 1),
        const Text('Row with MainAxisAlignment.spaceBetween:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('[Start]'),
            Text('[Middle]'),
            Text('[End]'),
          ],
        ),

        const SizedBox(height: 1),
        const Text('Row with MainAxisAlignment.spaceEvenly:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Text('[Start]'),
            Text('[Middle]'),
            Text('[End]'),
          ],
        ),

        const SizedBox(height: 1),
        const Text('Row with Expanded children:'),
        Row(
          children: [
            const Text('[Fixed]'),
            Expanded(
              child: Container(
                child: const Text('[===Expanded===]'),
              ),
            ),
            const Text('[Fixed]'),
            Expanded(
              flex: 2,
              child: Container(
                child: const Text('[=====Expanded Flex:2=====]'),
              ),
            ),
            const Text('[Fixed]'),
          ],
        ),

        const SizedBox(height: 1),
        const Text('Column with CrossAxisAlignment.center:'),
        Container(
          height: 5,
          width: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text('[Top]'),
              Text('[Middle Item]'),
              Text('[Bottom]'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Test binding for flex rendering
class TestBinding extends NoctermBinding {
  TestBinding(this.terminal);

  final Terminal terminal;

  @override
  void drawFrame() {
    if (rootElement == null) return;

    // Build phase
    super.drawFrame();

    // Get size
    final size = terminal.size;
    final buffer = Buffer(size.width.toInt(), size.height.toInt());

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
      // Layout phase
      renderObject.layout(BoxConstraints(
        minWidth: 0,
        maxWidth: size.width.toDouble(),
        minHeight: 0,
        maxHeight: size.height.toDouble(),
      ));

      // Paint phase
      final canvas = TerminalCanvas(buffer, Rect.fromLTWH(0, 0, size.width.toDouble(), size.height.toDouble()));
      renderObject.paint(canvas, Offset.zero);
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
  }
}
