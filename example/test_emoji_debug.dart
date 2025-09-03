import 'package:nocterm/nocterm.dart';
import 'package:nocterm/src/utils/unicode_width.dart';

void main() {
  // Let's debug the width calculations
  final texts = [
    '✨ Features:',
    '  • Component-based architecture',
    '  • Constraint-based layout system',
    '  • Stateful and Stateless components',
    '  • BuildContext for tree traversal',
    '  • RenderObject for painting',
  ];

  print('Text width analysis:');
  for (final text in texts) {
    final displayWidth = UnicodeWidth.stringWidth(text);
    final stringLength = text.length;
    print('Text: "$text"');
    print('  String length: $stringLength');
    print('  Display width: $displayWidth');
    print('  Difference: ${displayWidth - stringLength}');
    print('');
  }

  runApp(const EmojiDebugDemo());
}

class EmojiDebugDemo extends StatelessComponent {
  const EmojiDebugDemo();

  @override
  Component build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Show the width difference visually
          DecoratedBox(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Color.fromRGB(255, 255, 255), width: 1),
            ),
            child: SizedBox(
              width: 45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('✨ Features:'),
                  Text('  • Component-based architecture'),
                ],
              ),
            ),
          ),
          SizedBox(height: 2),
          // Show with ruler
          DecoratedBox(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Color.fromRGB(100, 100, 100), width: 1),
            ),
            child: SizedBox(
              width: 45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('12345678901234567890123456789012345678901234'),
                  Text('✨ Features:'),
                  Text('  • Component-based architecture'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
