import re
import os

log_path = r"C:\Users\ivann\.gemini\antigravity-ide\brain\8ecf8ca6-a4dd-480e-ba50-02dbde0a6ed5\.system_generated\tasks\task-79.log"
# Windows path
workspace_dir = r"c:\project flutter\stokwarung"

with open(log_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

fixed_files = set()

for line in lines:
    if 'invalid_constant' in line:
        match = re.search(r' - (lib\\[^:]+):(\d+):\d+ - ', line)
        if match:
            rel_file_path = match.group(1)
            file_path = os.path.join(workspace_dir, rel_file_path)
            line_num = int(match.group(2)) - 1
            
            try:
                with open(file_path, 'r', encoding='utf-8') as f_in:
                    file_lines = f_in.readlines()
                
                original = file_lines[line_num]
                # Try to remove the first 'const ' we find on that line
                file_lines[line_num] = re.sub(r'\bconst\s+', '', original, count=1)
                
                with open(file_path, 'w', encoding='utf-8') as f_out:
                    f_out.writelines(file_lines)
                print(f"Fixed {file_path}:{line_num+1}")
                fixed_files.add(file_path)
            except Exception as e:
                print(f"Error fixing {file_path}:{line_num+1} - {e}")
