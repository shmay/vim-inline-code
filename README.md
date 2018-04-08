## vim-inline-code

Inline some code, which will be copied to your clipboard, then opened in a new buffer, so you can edit it further if so desired.

Simply select the code you'd like to convert to one line and run

`:'<,'>InlineCode`

If you'd like to add a semicolon between the lines, do `:'<,'>InlineCodeWithSeparator`

<img src='inline3.gif' />

### TODO

* Add InlineCodeRubyModule
  * this will convert nested modules into One::Two syntax
* Add InlineCodeWithoutWindow possibly?
  * don't open a new pane, just copy to clipboard
