# Password Handling in Bash

## Passwords Starting with Exclamation Mark (!)

If your password starts with an exclamation mark (`!`), bash history expansion may interfere with password entry. To disable history expansion temporarily, use:

```bash
set +H
```

This disables the history expansion feature in your current shell session, allowing you to safely enter passwords that begin with `!`.

### Example

```bash
set +H
# Now you can safely enter passwords with ! at the beginning
gh auth login
# After you're done, you can re-enable history expansion with:
set -H
```

### Why This Matters

In bash, `!` is a special character used for history expansion (e.g., `!!` runs the last command). When a password starts with `!`, the shell may attempt to expand it as a history reference, causing authentication failures or unexpected behavior.

By using `set +H`, you temporarily disable this feature, ensuring special characters in passwords are treated literally.
