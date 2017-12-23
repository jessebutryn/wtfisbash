# Useless Uses of Echo

There is almost no situation in which `echo` _should_ be used within command substitution.

* **Expand Variable**

**Don't**
``` bash
mv "$(echo "$file1")" "$(echo "$file2")"
```

This is an inefficiency as it creates uneccessary processes and the shell is more than capable of expanding variables.

**Do**
``` bash
mv "$file1" "$file2"
```

* **Redirecting Variables**

**Don't**
``` bash
echo "$VAR" | grep 'string'

echo "$VAR" | sed 's/string1/string2/'

echo "$VAR" | awk '{print $1}'
```

Similar to a common useless use of `cat`, this is an inefficiency and is better handled using _Here String_ redirection.

**Do**
``` bash
grep 'string' <<<"$VAR"

sed 's/string1/string2/' <<<"$VAR"

awk '{print $1}' <<<"$VAR"
```

* **Adding Newlines**

**Don't**
``` bash
echo "I have some text that should be followed by an empty line"
echo
echo "So I have added a useless echo after it"
```

Using `echo` in this way can sometimes be valid, however it is unecessary after any previous `echo` command.  This is
because `echo` when used with the `-e` switch, is capable of interpreting the following escapes:
  - \a	alert (bell)
  - \b	backspace
  - \c	suppress further output
  - \e	escape character
  - \f	form feed
  - \n	new line
  - \r	carriage return
  - \t	horizontal tab
  - \v	vertical tab
  - \\	backslash
  - \0nnn	the character whose ASCII code is NNN (octal).  NNN can be 0 to 3 octal digits
  - \xHH	the eight-bit character whose value is HH (hexadecimal).  HH can be one or two hex digits

**Do**
``` bash
echo -e "I have some text that should be followed by an empty line\n\nBut I no longer need the useless echo"
```
