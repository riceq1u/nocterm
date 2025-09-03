import 'package:nocterm/src/third_party/xterm_pure.dart/xterm.dart' as xterm;

void main() {
  final terminal = xterm.Terminal();

  // Send some colored text to the terminal
  terminal.write('\x1b[31mRed\x1b[32m Green\x1b[33m Yellow\x1b[34m Blue\x1b[0m Normal');

  // Check the buffer
  for (int y = 0; y < 1; y++) {
    final line = terminal.buffer.lines[y];
    for (int x = 0; x < 25 && x < line.length; x++) {
      final cellData = xterm.CellData.empty();
      line.getCellData(x, cellData);

      final codePoint = cellData.content & xterm.CellContent.codepointMask;
      if (codePoint != 0) {
        final char = String.fromCharCode(codePoint);
        print(
            'Char: "$char" FG: 0x${cellData.foreground.toRadixString(16).padLeft(8, '0')} BG: 0x${cellData.background.toRadixString(16).padLeft(8, '0')}');
      }
    }
  }
}
