import 'package:nocterm/nocterm.dart';

void main() {
  runApp(const EmojiWidthTestApp());
}

class EmojiWidthTestApp extends StatelessComponent {
  const EmojiWidthTestApp();

  @override
  Component build(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: BoxBorder.all(color: Color.fromRGB(255, 255, 255), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Regular text: Hello World'),
            Text('With emoji: Hello 🌍 World'),
            Text('Multiple emojis: 🚀 ✨ 🎉 🔥'),
            Text('Mixed: Code 💻 + Coffee ☕ = 🎯'),
            Text('Flags: 🇺🇸 🇬🇧 🇯🇵'),
            Text('Combined: 👨‍💻 👩‍🔬 🧑‍🚀'),
            Text('Box chars: ┌─┐│└┘'),
          ],
        ),
      ),
    );
  }
}
