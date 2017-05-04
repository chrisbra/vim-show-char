#ShowWhite plugin
> A Vim plugin for displaying whitespace characters

This plugin is inspired by a  [Question on Stackoverflow](http://stackoverflow.com/questions/1675688) and allows to toggle displaying of space characters quickly.

###Installation
Use the plugin manager of your choice. Or download the [stable][] version of the plugin, edit it with Vim (`vim show-white-XXX.vmb`) and simply source it (`:so %`). Restart and take a look at the help (`:h ShowWhitespace.txt`)

[stable]: http://www.vim.org/scripts/script.php?script_id=5043

###Usage
Once installed, take a look at the help at `:h ShowWhitespace`

Here is a short overview of the functionality provided by the plugin:
####Ex commands:
    :ShowWhiteToggle   - Toggle displaying space characters in the current window.
    :ShowCharAs c1 c2  - Display c1 as c2 in the current window
    :ShowCharAs!       - Remove highlighting from previous :ShowCharAs command
####Normal mode commands:
    \ws		 - toggle displaying space characters

###License & Copyright

© 2014-2017 by Christian Brabandt. The Vim License applies. See `:h license`

__NO WARRANTY, EXPRESS OR IMPLIED.  USE AT-YOUR-OWN-RISK__
