# How to fix compdef_error in  mac?

```
complete:13: command not found: compdef
```
- Add this in .zshrc file
```
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit 
```
