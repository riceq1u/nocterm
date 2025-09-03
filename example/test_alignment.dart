import 'package:nocterm/nocterm.dart';

void main() {
  runApp(const AlignmentTestApp());
}

class AlignmentTestApp extends StatelessComponent {
  const AlignmentTestApp();

  @override
  Component build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Box to show boundaries
          DecoratedBox(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Color.fromRGB(255, 255, 255), width: 1),
            ),
            child: SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text('No emoji text here'),
                  Text('✨ With emoji here'),
                  Text('Regular text again'),
                  Text('🚀 Another emoji'),
                  Text('Mixed 💻 text'),
                ],
              ),
            ),
          ),
          SizedBox(height: 2),
          // Test left alignment
          DecoratedBox(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Color.fromRGB(255, 255, 255), width: 1),
            ),
            child: SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Left aligned'),
                  Text('✨ With emoji'),
                  Text('Regular text'),
                ],
              ),
            ),
          ),
          SizedBox(height: 2),
          // Test right alignment
          DecoratedBox(
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Color.fromRGB(255, 255, 255), width: 1),
            ),
            child: SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text('Right aligned'),
                  Text('✨ With emoji'),
                  Text('Regular text'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
