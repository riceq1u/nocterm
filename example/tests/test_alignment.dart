import 'package:nocterm/nocterm.dart';

void main() {
  runApp(const AlignmentTestApp());
}

class AlignmentTestApp extends StatelessComponent {
  const AlignmentTestApp({super.key});

  @override
  Component build(BuildContext context) {
    return Column(
      children: [
        // Test top alignments
        Container(
          height: 5,
          color: Colors.gray,
          child: const Align(
            alignment: Alignment.topLeft,
            child: Text('Top Left', style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          height: 5,
          color: Colors.brightBlack,
          child: const Align(
            alignment: Alignment.topCenter,
            child: Text('Top Center', style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          height: 5,
          color: Colors.gray,
          child: const Align(
            alignment: Alignment.topRight,
            child: Text('Top Right', style: TextStyle(color: Colors.white)),
          ),
        ),
        // Test center alignments
        Container(
          height: 5,
          color: Colors.brightBlack,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Center Left', style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          height: 5,
          color: Colors.gray,
          child: const Align(
            alignment: Alignment.center,
            child: Text('Center', style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          height: 5,
          color: Colors.brightBlack,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Text('Center Right', style: TextStyle(color: Colors.white)),
          ),
        ),
        // Test bottom alignments
        Container(
          height: 5,
          color: Colors.gray,
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Text('Bottom Left', style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          height: 5,
          color: Colors.brightBlack,
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: Text('Bottom Center', style: TextStyle(color: Colors.white)),
          ),
        ),
        Container(
          height: 5,
          color: Colors.gray,
          child: const Align(
            alignment: Alignment.bottomRight,
            child: Text('Bottom Right', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
