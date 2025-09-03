import 'package:nocterm/nocterm.dart';

void main() {
  // Create a simple buffer and test if styles are preserved
  final buffer = Buffer(10, 3);

  // Set some cells with styles
  buffer.setCell(0, 0, Cell(char: 'R', style: const TextStyle(color: Colors.red)));
  buffer.setCell(1, 0, Cell(char: 'G', style: const TextStyle(color: Colors.green)));
  buffer.setCell(2, 0, Cell(char: 'B', style: const TextStyle(color: Colors.blue)));

  // Check if styles are preserved
  for (int x = 0; x < 3; x++) {
    final cell = buffer.getCell(x, 0);
    print('Cell at ($x, 0): char="${cell.char}", has fg color: ${cell.style.color != null}');
    if (cell.style.color != null) {
      print('  Color RGB: ${cell.style.color!.red}, ${cell.style.color!.green}, ${cell.style.color!.blue}');
      print('  ANSI code: ${cell.style.toAnsi()}');
    }
  }
}
