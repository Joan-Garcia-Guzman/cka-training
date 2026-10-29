# NANO tips
## Syntax highlight 
permanent syntax highlighting and Tab functionality
```shell
nano ~/.nanorc
```
```text
# Enable YAML syntax color highlighting
include "/usr/share/nano/yaml.nanorc"

# Apply specific settings when editing YAML files
extendsyntax yaml tabsize 2
extendsyntax yaml tabstospaces
```

On te fly config
```shell
nano -T 2 -E <my_file>.yaml
```
- -T 2 sets the tab size to 2 spaces.
- -E converts tabs to spaces automatically.

## Commands
saving files
```
Ctrl+0, Enter, Ctrl+X
```

pasting content
```text
Shift+V
```
