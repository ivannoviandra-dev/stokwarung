import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (final file in files) {
    if (file.path.contains('app_colors.dart') || file.path.contains('app_theme.dart')) {
      continue;
    }
    String content = file.readAsStringSync();
    bool changed = false;
    
    if (content.contains('AppColors.')) {
      content = content.replaceAll('AppColors.', 'context.appColors.');
      changed = true;
    }
    
    if (content.contains('AppTheme.cardShadow')) {
      // Only replace if it doesn't already have ()
      content = content.replaceAll('AppTheme.cardShadow,', 'AppTheme.cardShadow(context.appColors),');
      content = content.replaceAll('AppTheme.cardShadow]', 'AppTheme.cardShadow(context.appColors)]');
      changed = true;
    }
    
    if (content.contains('AppTheme.elevatedShadow')) {
      content = content.replaceAll('AppTheme.elevatedShadow,', 'AppTheme.elevatedShadow(context.appColors),');
      content = content.replaceAll('AppTheme.elevatedShadow]', 'AppTheme.elevatedShadow(context.appColors)]');
      changed = true;
    }
    
    if (changed) {
      file.writeAsStringSync(content);
      print('Updated ${file.path}');
    }
  }
}
