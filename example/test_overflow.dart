import 'package:nocterm/nocterm.dart';

void main() async {
  await runApp(const OverflowDemo());
}

class OverflowDemo extends StatelessComponent {
  const OverflowDemo({super.key});

  @override
  Component build(BuildContext context) {
    return Center(
      child: Container(
        width: 20,
        height: 10,
        decoration: BoxDecoration(
          border: BoxBorder.all(color: Colors.blue),
        ),
        child: Column(
          children: [
            Text('This is a very long text that will overflow'),
            Text('Second line'),
            Text('Third line'),
            Text('Fourth line'),
            Text('Fifth line'),
            Text('Sixth line - this should overflow'),
          ],
        ),
      ),
    );
  }
}
