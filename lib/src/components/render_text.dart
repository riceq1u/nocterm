import 'package:nocterm/nocterm.dart';
import 'package:nocterm/src/framework/terminal_canvas.dart';

import '../utils/unicode_width.dart';

/// Render object for displaying text
class RenderText extends RenderObject {
  RenderText({required String text, TextStyle? style})
      : _text = text,
        _style = style;

  String _text;
  String get text => _text;
  set text(String value) {
    if (_text == value) return;
    _text = value;
    markNeedsLayout();
  }

  TextStyle? _style;
  TextStyle? get style => _style;
  set style(TextStyle? value) {
    if (_style == value) return;
    _style = value;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    final lines = _text.split('\n');
    // Use Unicode width calculation instead of string length
    final maxLineWidth = lines.fold(0, (max, line) {
      final width = UnicodeWidth.stringWidth(line);
      return width > max ? width : max;
    });
    size = constraints.constrain(Size(
      maxLineWidth.toDouble(),
      lines.length.toDouble(),
    ));
  }

  @override
  void paint(TerminalCanvas canvas, Offset offset) {
    super.paint(canvas, offset);
    final lines = _text.split('\n');
    for (int i = 0; i < lines.length; i++) {
      canvas.drawText(
        Offset(offset.dx, offset.dy + i),
        lines[i],
        style: _style,
      );
    }
  }
}
