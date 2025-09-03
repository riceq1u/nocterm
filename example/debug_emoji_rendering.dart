import 'dart:io';

void main() {
  // Test raw terminal output to understand the issue
  print('Testing emoji rendering in terminal:');
  
  // Test direct output
  stdout.write('Direct: ');
  stdout.write('✨');
  stdout.write('Features:');
  stdout.write('\n');
  
  // Test with explicit space
  stdout.write('Space:  ');
  stdout.write('✨ Features:');
  stdout.write('\n');
  
  // Test character codes
  final text = '✨ Features:';
  print('\nAnalyzing "$text":');
  final runes = text.runes.toList();
  for (int i = 0; i < runes.length; i++) {
    final rune = runes[i];
    final char = String.fromCharCode(rune);
    print('  Index $i: U+${rune.toRadixString(16).padLeft(4, '0')} "$char"');
  }
  
  // Test if the emoji is actually a single code point or multiple
  print('\nEmoji details:');
  final emoji = '✨';
  print('  String length: ${emoji.length}');
  print('  Rune count: ${emoji.runes.length}');
  print('  Code units: ${emoji.codeUnits}');
  print('  Runes: ${emoji.runes.toList()}');
  
  // Check if it's a surrogate pair
  if (emoji.length > 1) {
    print('  This emoji uses surrogate pairs!');
  }
}