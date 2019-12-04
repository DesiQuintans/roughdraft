# roughdraft

_No deleting or replacing; you can only write new things._

This is an Autohotkey script that disables your ability to delete or overwrite text, similar to [emacs' draft-mode](https://github.com/emacsmirror/draft-mode) but it can be used in any writing program. 

When you lose the ability to delete or replace text, you are unable to go back and edit what you've done. All you can do is keep charging forward and writing new things. Editing comes after drafting.

## TODO

[x] Disable Backspace and Delete
[x] Disable Insert/Overwrite
[ ] Disable going backwards/forwards in the text?
    - It may interfere with UI controls, so I'm unsure.
    - Perhaps if the user presses a letter/number or Shift+letter/number, then send an End keystroke before allowing input so they're at least always at the end of the line?
    - Autohotkey's tilde modifier doesn't work super well here because it allows the key to pass through, AND THEN fires the script that is bound to the key.
[ ] Disable replacement of highlighted text
    - Perhaps by copying highlighted text, pasting it, and then positioning the cursor after the pasted block?
[ ] Should only be applicable inside MS Word (to start with).
[ ] Ability to quickly disable it.
    - By keystroke?
    - By typing a particular key sequence?