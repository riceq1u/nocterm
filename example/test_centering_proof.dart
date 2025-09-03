import 'package:nocterm/nocterm.dart';

void main() {
  runApp(const CenteringProofDemo());
}

class CenteringProofDemo extends StatelessComponent {
  const CenteringProofDemo();

  @override
  Component build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Prove centering is mathematically correct
          DecoratedBox(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Color.fromRGB(255, 255, 255), width: 1),
            ),
            child: SizedBox(
              width: 45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  // Ruler to show positions
                  Text('123456789012345678901234567890123456789012345'),
                  Text('         1         2         3         4    '),
                  Text('─────────────────────────────────────────────'),

                  // Regular text - 12 chars
                  Text('Hello World!'), // 12 chars, centers at (45-12)/2 = 16

                  // Emoji text - also 12 display columns
                  Text('✨ Features:'), // 12 cols, centers at (45-12)/2 = 16

                  // Show they align at the same position
                  Text('^^^^^^^^^^^^'), // Markers showing both are 12 cols wide

                  SizedBox(height: 1),
                  Text('Both texts are 12 columns wide'),
                  Text('Both start at column 17 (0-indexed: 16)'),
                  Text('The emoji just looks off-center'),
                  Text('because it has more visual weight'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
