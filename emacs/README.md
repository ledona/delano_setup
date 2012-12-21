Keyboard Shortcuts for everything I do in emacs

# General
* Cancel: CTRL-g
Repeat the next operation N times: META-<n> <operation>

# Buffers/Files
* Find/Open a file: CTRL-x,CTRL-f <file_name>
* Close Emacs: CTRL-x,CTRL-c
* Save Current Buffer: CTRL-x,CTRL-s
* Kill Current Buffer (i.e. close a file): CTRL-x,k
* Switch to different file: CTRL-b
* Save Current Buffer to a new filename: CTRL-x,CTRL-w <file_name>

# Navigation (arrow keys work as expected)
* Start of current line: CTRL-a
* End of current line: CTRL-e
* Next Page: CTRL-v
* Prev Page: META-v
* End of file: META->
* Start of file: META-<
* Goto line number: META-g,META-g <line_number>
* Next Para: META-e
* Prev Para: META-a
* Forward word: META-f
* Backward word: META-b
* Forward para: META-e
* Backward para: META-a

# Search/Replace
* Search forward: CTRL-s
* Search backward: CTRL-r
* Find Next and query replace: META-%
* Find Next and query replace regexp: CTRL-META-%

# Keyboard Macros:
* Start Defining: F3
* End Definition: F4
* Execute last macro: F4

# Windowing:
* Split window in 2 horizontally: CTRL-x,2
* Split window in 2 vertically: CTRL-x,3
* Delete current window (not the buffer, just close the window): CTRL-x,0

# Editing
* Delete rest of current like (adds to kill ring): CTRL-k
* Delete rest of current word (adds to kill ring): META-d
* Undo: CTRL-/

# Copy/Cut/Paste
* Mark start of region: CTRL-space
* Cut region: CTRL-w
* Paste from kill ring (kill ring=copy buffer): CTRL-y

# Personal Custom Shortcuts
* Whitespace Cleanup: CTRL-c w