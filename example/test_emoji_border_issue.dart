import 'package:nocterm/nocterm.dart';

void main() {
  runApp(const EmojiBorderIssueDemo());
}

class EmojiBorderIssueDemo extends StatelessComponent {
  const EmojiBorderIssueDemo();

  @override
  Component build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Test with fixed width to see border alignment
          DecoratedBox(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Color.fromRGB(255, 255, 255), width: 1),
            ),
            child: SizedBox(
              width: 20,
              height: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('12345678901234567890'), // 20 chars exactly
                  Text('Hello World!'), // 12 chars
                  Text('✨ Features:'), // Should be 12 display cols
                  Text('Test ✨ emoji'), // Test emoji in middle
                  Text('End of box'), // Regular text
                ],
              ),
            ),
          ),
          SizedBox(height: 2),
          // Test showing the actual character positions
          DecoratedBox(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Color.fromRGB(255, 255, 255), width: 1),
            ),
            child: SizedBox(
              width: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Position ruler:'),
                  Text('123456789012345678901234567890'),
                  Text('✨Features:'), // No space after emoji
                  Text('✨ Features:'), // One space after emoji
                  Text('✨  Features:'), // Two spaces - what we're seeing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
