import 'package:nocterm/nocterm.dart';

void main() async {
  await runApp(const OverflowDemo());
}

class OverflowDemo extends StatelessComponent {
  const OverflowDemo({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      children: [
        // Horizontal overflow test
        Text('Horizontal Overflow Test:'),
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            border: BoxBorder.all(color: Colors.blue),
          ),
          child: Row(
            children: [
              Text('This text is way too long for the container'),
              Text('More text'),
            ],
          ),
        ),

        // Vertical overflow test
        Text(''),
        Text('Vertical Overflow Test:'),
        Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            border: BoxBorder.all(color: Colors.green),
          ),
          child: Column(
            children: [
              Text('Line 1'),
              Text('Line 2'),
              Text('Line 3'),
              Text('Line 4'),
              Text('Line 5'),
              Text('Line 6 - overflow!'),
              Text('Line 7 - overflow!'),
            ],
          ),
        ),
      ],
    );
  }
}
