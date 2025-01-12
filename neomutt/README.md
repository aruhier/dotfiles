# Neomutt

## Account setting

1. Copy the template for the account to use (example, `mailbox.template`) in a tmpfs (example, as `/tmp/mailbox`).
2. Set the values (commonly, just replace the user and password).
3. Encrypt it and store it in `~/.config/neomutt`.

   Example: `gpg --output ~/.config/neomutt/mailbox.gpg --encrypt --recipient foo@bar.org /tmp/mailbox`
