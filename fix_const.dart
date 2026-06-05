// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final logFile = File(r"C:\Users\ivann\.gemini\antigravity-ide\brain\8ecf8ca6-a4dd-480e-ba50-02dbde0a6ed5\.system_generated\tasks\task-122.log");
  final workspaceDir = r"c:\project flutter\stokwarung";
  for (var line in logFile.readAsLinesSync()) {
    if (line.contains('invalid_constant')) {
      final parts = line.split(' - ');
      if (parts.length >= 3) {
        final pathAndLine = parts[2].trim();
        final subParts = pathAndLine.split(':');
        if (subParts.length >= 3) {
          final relPath = subParts[0];
          final lineNum = int.parse(subParts[1]) - 1;
          final file = File('$workspaceDir\\$relPath');
          if (file.existsSync()) {
            final lines = file.readAsLinesSync();
            if (lineNum < lines.length) {
              final original = lines[lineNum];
              lines[lineNum] = original.replaceFirst(RegExp(r'\bconst\s+'), '');
              if (original != lines[lineNum]) {
                file.writeAsStringSync(lines.join('\n'));
                print('Fixed $relPath:$lineNum');
              }
            }
          }
        }
      }
    }
  }
}
