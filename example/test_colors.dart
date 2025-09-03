import 'dart:io';

void main() {
  // Test if terminal supports 24-bit color
  print('Testing 24-bit color support...');
  
  // Red text using 24-bit color
  stdout.write('\x1b[38;2;255;0;0mThis should be RED (24-bit)\x1b[0m\n');
  
  // Green text using 24-bit color  
  stdout.write('\x1b[38;2;0;255;0mThis should be GREEN (24-bit)\x1b[0m\n');
  
  // Blue text using 24-bit color
  stdout.write('\x1b[38;2;0;0;255mThis should be BLUE (24-bit)\x1b[0m\n');
  
  // Test 256-color mode
  print('\nTesting 256-color mode...');
  stdout.write('\x1b[38;5;196mThis should be RED (256-color)\x1b[0m\n');
  stdout.write('\x1b[38;5;46mThis should be GREEN (256-color)\x1b[0m\n');
  stdout.write('\x1b[38;5;21mThis should be BLUE (256-color)\x1b[0m\n');
  
  // Test basic 16-color mode
  print('\nTesting basic 16-color mode...');
  stdout.write('\x1b[31mThis should be RED (16-color)\x1b[0m\n');
  stdout.write('\x1b[32mThis should be GREEN (16-color)\x1b[0m\n');
  stdout.write('\x1b[34mThis should be BLUE (16-color)\x1b[0m\n');
  
  // Test background colors
  print('\nTesting background colors...');
  stdout.write('\x1b[48;2;255;0;0m\x1b[38;2;255;255;255mWhite on RED background (24-bit)\x1b[0m\n');
  stdout.write('\x1b[48;5;196m\x1b[38;5;15mWhite on RED background (256-color)\x1b[0m\n');
  stdout.write('\x1b[41m\x1b[37mWhite on RED background (16-color)\x1b[0m\n');
}