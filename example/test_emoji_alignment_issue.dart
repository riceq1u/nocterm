import 'package:nocterm/nocterm.dart';

void main() {
  runApp(const EmojiAlignmentIssueDemo());
}

class EmojiAlignmentIssueDemo extends StatelessComponent {
  const EmojiAlignmentIssueDemo();

  @override
  Component build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: BoxBorder.all(color: Color.fromRGB(255, 255, 255), width: 1),
        ),
        child: SizedBox(
          width: 45,
          height: 15,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              // This reproduces the exact issue from the screenshot
              Text('✨ Features:'),
              Text('  • Component-based architecture'),
              Text('  • Constraint-based layout system'),
              Text('  • Stateful and Stateless components'),
              Text('  • BuildContext for tree traversal'),
              Text('  • RenderObject for painting'),
              SizedBox(height: 1),
              Text('Built with Dart inspired by Flutter/Jaspr'),
            ],
          ),
        ),
      ),
    );
  }
}
