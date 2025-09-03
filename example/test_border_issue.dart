import 'package:nocterm/nocterm.dart';

void main() async {
  runApp(const BorderIssueTest());
}

class BorderIssueTest extends StatelessComponent {
  const BorderIssueTest();

  @override
  Component build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Testing border with width=1'),
          const SizedBox(height: 2),

          // This should show the issue - width of 1
          Container(
            width: 1,
            height: 3,
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.cyan),
            ),
          ),

          const SizedBox(height: 2),

          // Width of 2 should work
          Container(
            width: 2,
            height: 3,
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.green),
            ),
          ),

          const SizedBox(height: 2),

          // Width of 3 should work
          Container(
            width: 3,
            height: 3,
            decoration: BoxDecoration(
              border: BoxBorder.all(color: Colors.yellow),
            ),
          ),
        ],
      ),
    );
  }
}
