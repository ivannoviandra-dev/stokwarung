import 'dart:io';

void main() {
  const text = '''
  error - Invalid constant value - lib\\screens\\auth\\login_screen.dart:83:32 - invalid_constant
  error - Invalid constant value - lib\\screens\\auth\\login_screen.dart:138:36 - invalid_constant
  error - Invalid constant value - lib\\screens\\auth\\login_screen.dart:151:36 - invalid_constant
  error - Invalid constant value - lib\\screens\\dashboard\\dashboard_screen.dart:193:61 - invalid_constant
  error - Invalid constant value - lib\\screens\\kasir\\checkout_screen.dart:331:20 - invalid_constant
  error - Invalid constant value - lib\\screens\\main\\main_screen.dart:59:60 - invalid_constant
  error - Invalid constant value - lib\\screens\\main\\main_screen.dart:75:60 - invalid_constant
  error - Invalid constant value - lib\\screens\\main\\main_screen.dart:80:57 - invalid_constant
  error - Invalid constant value - lib\\screens\\main\\main_screen.dart:118:30 - invalid_constant
  error - Invalid constant value - lib\\screens\\products\\product_detail_screen.dart:88:24 - invalid_constant
  error - Invalid constant value - lib\\screens\\profile\\profile_screen.dart:40:30 - invalid_constant
  error - Invalid constant value - lib\\screens\\reminder\\reminder_screen.dart:94:63 - invalid_constant
  error - Invalid constant value - lib\\screens\\reminder\\reminder_screen.dart:167:63 - invalid_constant
  error - Invalid constant value - lib\\screens\\reminder\\reminder_screen.dart:240:63 - invalid_constant
  error - Invalid constant value - lib\\screens\\reminder\\reminder_screen.dart:261:24 - invalid_constant
  error - Invalid constant value - lib\\screens\\settings\\store_settings_screen.dart:99:34 - invalid_constant
  error - Invalid constant value - lib\\screens\\settings\\store_settings_screen.dart:108:36 - invalid_constant
  error - Invalid constant value - lib\\widgets\\app_button.dart:65:22 - invalid_constant
  error - Invalid constant value - lib\\widgets\\cart_item_tile.dart:28:37 - invalid_constant
  error - Invalid constant value - lib\\widgets\\loading_overlay.dart:38:69 - invalid_constant
  error - Invalid constant value - lib\\widgets\\product_card.dart:125:14 - invalid_constant
  error - Invalid constant value - lib\\widgets\\search_bar_widget.dart:41:20 - invalid_constant
  error - Invalid constant value - lib\\widgets\\search_bar_widget.dart:48:28 - invalid_constant
  ''';

  final workspaceDir = r"c:\project flutter\stokwarung";
  final lines = text.split('\n');
  
  for (var line in lines) {
    if (line.contains('invalid_constant')) {
      final parts = line.split(' - ');
      if (parts.length >= 3) {
        final pathAndLine = parts[2].trim();
        final subParts = pathAndLine.split(':');
        if (subParts.length >= 3) {
          final relPath = subParts[0];
          final lineNumStr = subParts[1];
          final lineNum = int.parse(lineNumStr) - 1;
          final file = File('$workspaceDir\\$relPath');
          if (file.existsSync()) {
            final fileLines = file.readAsLinesSync();
            if (lineNum < fileLines.length) {
              final original = fileLines[lineNum];
              fileLines[lineNum] = original.replaceFirst(RegExp(r'\bconst\s+'), '');
              if (original != fileLines[lineNum]) {
                file.writeAsStringSync(fileLines.join('\n'));
                print('Fixed $relPath:$lineNum');
              }
            }
          }
        }
      }
    }
  }
}
