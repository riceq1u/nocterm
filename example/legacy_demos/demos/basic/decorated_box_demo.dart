import 'package:dart_tui/tui_reactive.dart';

void main() async {
  runApp(const DecoratedBoxDemo());
}

class DecoratedBoxDemo extends StatelessComponent {
  const DecoratedBoxDemo();

  @override
  Component build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 2),
        Text(
          'DecoratedBox Widget Demo',
          style: Style(fg: Color.cyan, bold: true),
        ),
        const SizedBox(height: 2),

        // Simple box with solid border
        Container(
          width: 30,
          height: 5,
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Color.rgb(20, 20, 40),
            border: BoxBorder.all(
              color: Color.cyan,
              style: BoxBorderStyle.solid,
            ),
          ),
          child: const Text('Solid Border', style: Style(fg: Color.white)),
        ),

        // Box with double border
        Container(
          width: 30,
          height: 5,
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Color.rgb(40, 20, 20),
            border: BoxBorder.all(
              color: Color.red,
              style: BoxBorderStyle.double,
            ),
          ),
          child: const Text('Double Border', style: Style(fg: Color.white)),
        ),

        // Box with rounded border
        Container(
          width: 30,
          height: 5,
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Color.rgb(20, 40, 20),
            border: BoxBorder.all(
              color: Color.green,
              style: BoxBorderStyle.rounded,
            ),
          ),
          child: const Text('Rounded Border', style: Style(fg: Color.white)),
        ),

        // Box with dashed border
        Container(
          width: 30,
          height: 5,
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Color.rgb(40, 40, 20),
            border: BoxBorder.all(
              color: Color.yellow,
              style: BoxBorderStyle.dashed,
            ),
          ),
          child: const Text('Dashed Border', style: Style(fg: Color.white)),
        ),

        // Box with dotted border
        Container(
          width: 30,
          height: 5,
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Color.rgb(40, 20, 40),
            border: BoxBorder.all(
              color: Color.magenta,
              style: BoxBorderStyle.dotted,
            ),
          ),
          child: const Text('Dotted Border', style: Style(fg: Color.white)),
        ),

        // Nested boxes with different decorations
        Container(
          width: 50,
          height: 10,
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Color.rgb(10, 10, 30),
            border: BoxBorder.all(
              color: Color.brightCyan,
              style: BoxBorderStyle.double,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Color.rgb(30, 10, 10),
              border: BoxBorder.all(
                color: Color.brightRed,
                style: BoxBorderStyle.rounded,
              ),
            ),
            child: const Center(
              child: Text(
                'Nested Boxes',
                style: Style(fg: Color.white, bold: true),
              ),
            ),
          ),
        ),

        // Box with custom border sides
        Container(
          width: 40,
          height: 7,
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
            color: Color.rgb(20, 20, 20),
            border: BoxBorder(
              top: BorderSide(color: Color.red, style: BoxBorderStyle.solid),
              right: BorderSide(color: Color.green, style: BoxBorderStyle.solid),
              bottom: BorderSide(color: Color.blue, style: BoxBorderStyle.solid),
              left: BorderSide(color: Color.yellow, style: BoxBorderStyle.solid),
            ),
          ),
          child: const Center(
            child: Text(
              'Multi-color Border',
              style: Style(fg: Color.white),
            ),
          ),
        ),

        const Spacer(),
        const Center(
          child: Text(
            'Press Ctrl+C to exit',
            style: Style(fg: Color.gray, dim: true),
          ),
        ),
        const SizedBox(height: 2),
      ],
    );
  }
}
