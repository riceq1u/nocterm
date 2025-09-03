import 'package:nocterm/nocterm.dart';

void main() async {
  runApp(const BorderTestApp());
}

class BorderTestApp extends StatelessComponent {
  const BorderTestApp();

  @override
  Component build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Border and Background Test', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),

          // Test 1: Simple border with background
          Container(
            width: 30,
            height: 5,
            decoration: BoxDecoration(
              color: Color.fromRGB(50, 50, 100),
              border: BoxBorder.all(
                color: Colors.cyan,
                style: BoxBorderStyle.solid,
              ),
            ),
            child: const Center(
              child: Text('Blue BG', style: TextStyle(color: Colors.white)),
            ),
          ),

          const SizedBox(height: 2),

          // Test 2: No border, just background
          Container(
            width: 30,
            height: 5,
            decoration: const BoxDecoration(
              color: Color.fromRGB(100, 50, 50),
            ),
            child: const Center(
              child: Text('Red BG', style: TextStyle(color: Colors.white)),
            ),
          ),

          const SizedBox(height: 2),

          // Test 3: Larger border to test inset
          Container(
            width: 40,
            height: 8,
            decoration: BoxDecoration(
              color: Color.fromRGB(50, 100, 50),
              border: BoxBorder.all(
                color: Colors.yellow,
                style: BoxBorderStyle.double,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Content should be', style: TextStyle(color: Colors.black)),
                Text('inside the border', style: TextStyle(color: Colors.black)),
              ],
            ),
          ),

          const SizedBox(height: 2),

          // Test 4: Nested containers with borders
          Container(
            width: 50,
            height: 10,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Color.fromRGB(30, 30, 30),
              border: BoxBorder.all(
                color: Colors.magenta,
                style: BoxBorderStyle.rounded,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGB(60, 60, 60),
                border: BoxBorder.all(
                  color: Colors.green,
                  style: BoxBorderStyle.solid,
                ),
              ),
              child: const Center(
                child: Text('Nested', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),

          const SizedBox(height: 2),
          const Text('Press Ctrl+C to exit', style: TextStyle(color: Colors.gray, fontWeight: FontWeight.dim)),
        ],
      ),
    );
  }
}
