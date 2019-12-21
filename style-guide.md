# Jesse_b's Bash Style Guide

This style guide is strictly the wildly unjustified opinions of Jesse_b.  You
are strongly encouraged to disregard everything found herein.  This guide is
intended to provide a set of rules and best practices related to the styling
and formatting of your bash scripts.  As it is a style guide, one can be almost
certain it will not accomplish this task.  Instead it will contain a list of
vastly arbitrary opinions that will serve as nothing more than an argument
catalyst.  Enjoy the read :)

This guide is based on Google's [Shell Style Guide](https://google.github.io/styleguide/shell.xml)

## Table of Contents

- [Jesse_b's Bash Style Guide](#jesse_bs-bash-style-guide)
  * [Table of Contents](#table-of-contents)
  * [Intro](#intro)
    + [Why bash?](#why-bash)
  * [Files](#files)
    + [Naming](#naming)
    + [Extensions](#extensions)
  * [Environment](#environment)
    + [Hash Bang](#hash-bang)
    + [Errors](#errors)
  * [Comments](#comments)
    + [File Header](#file-header)
    + [Functions](#functions)
    + [Implementation](#implementation)
  * [Formatting](#formatting)
    + [Indentation](#indentation)
    + [Column Width](#column-width)
    + [Pipelines](#pipelines)
    + [Loops and Constructs](#loops-and-constructs)
    + [Case](#case)
      - [Short](#short)
      - [Long](#long)
    + [Variable Expansion](#variable-expansion)
    + [Quoting](#quoting)
  * [Features and Bugs](#features-and-bugs)
    + [Listing Files](#listing-files)
    + [Command Substitution](#command-substitution)
    + [Tests](#tests)
      - [Strings](#strings)
    + [Globbing](#globbing)
    + [Eval](#eval)
  * [Naming Conventions](#naming-conventions)
    + [Functions](#functions-1)
    + [Variables](#variables)

## Intro

### Why bash?

The GNU project (GNU's Not UNIX) provides tools for UNIX-like system
administration which are free software and comply to UNIX standards.

Bash is an sh-compatible shell that incorporates useful features from the Korn
shell (ksh) and C shell (csh). It is intended to conform to the IEEE POSIX
P1003.2/ISO 9945.2 Shell and Tools standard. It offers functional improvements
over sh for both programming and interactive use; these include command line
editing, unlimited size command history, job control, shell functions and
aliases, indexed arrays of unlimited size, and integer arithmetic in any base
from two to sixty-four. Bash can run most sh scripts without modification.

Like the other GNU projects, the bash initiative was started to preserve,
protect and promote the freedom to use, study, copy, modify and redistribute
software. It is generally known that such conditions stimulate creativity. This
was also the case with the bash program, which has a lot of extra features that
other shells can't offer.

[Additional Reading](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_01_02.html)

## Files

### Naming

While ultimately impossible to know for sure, extreme caution should be used to
prevent using the same name as **ANY** external command and/or *especially* any
builtin command.

### Extensions

* Executable scripts should have no extension.
* Libraries and config files must have a `.sh` extension and should not be executable.

## Environment

### Hash Bang

Your hash bang (shebang) should be written as follows:

`#!/usr/bin/env bash`

Whenever possible (always?) you should use env rather than point to a specific
bash.  `/bin/bash` does not exist on all systems.  There is no need to guess
where someone's bash will be when `env` can find it for you.

### Errors

All error messages should be directed to `STDERR`.

The following function is recommended for handling error messages:

``` bash
echo.error () {
  red="$(tput setaf 1)"
  rst="$(tput sgr0)"
  if [[ "$1" == '-e' ]]; then
    shift
    echo -e "${red}[$(date +'%Y%m%dT%H%M%S%Z')]: $@ ${rst}" >&2
  else
    echo "${red}[$(date +'%Y%m%dT%H%M%S%Z')]: $@ ${rst}" >&2
  fi
}
```

## Comments

Make meaningful comments!  It's safe to assume that the next
person to look at your code will not be thinking the same thoughts you are.
For this reason you should attempt to make as many detailed comments as needed
to ensure that every aspect of your script is explained in full.

### File Header

Each file should start with a standardized header containing at least the
following information:

* Hashbang
* Copyright Notice 
  * Yes -- your work is [copywritten](http://www.copyrightkids.org/copyrightbasics.html), as soon as you write it.
* Description of intent
  * What does this file do? ...or at least what *should* it do?

Example:

``` bash
#!/usr/bin/env bash
# set -x
#
# Copyright (c) 2017 Joyent Inc.
#
# This script will save the world from an invasion of evil howler monkeys.
# 
```

### Functions

You should add comments to your functions that explain what the intent of the
function is.  Additionally if the function is complex, the comment should
include at least some basic usage information.

Example:

``` bash
some_func () { # If your comment is short it can be added here
  ...
}

some_func () {
  # In the event that your comment will take multiple lines, it is
  # preferred to add them to the start of your function like this.
  ...
}
```

### Implementation

Some commands/pipeline of commands can be hard to understand, especially for
someone other than the author.  For this reason it is preferred that you add
comments to any parts of your code that have any level of complexity to them.

## Formatting

If you are modifying someone elses file, **use their formatting**!

This is, of course, unless their formatting will lead to security and/or
functionality issues.

For all new files, you should adhere to the below guidelines:
(Or not...I mean it probably doesn't really matter right?)

### Indentation

Regardless of what you call it, you will use tabs.  If you want to change the
definition of tabs to something like "2 spaces" you are still using "tabs", you
have simply redefined what a tab is.  A tab is just a marker to identify and
separate information.  It also doesn't matter what key you are pressing to
accomplish this goal.  The word tab, referring to tabulate, existed long before
any tab key ever existed.  So when you press space twice to indent your data,
you are tabulating it.  :)

That being said, you should use **TABS** and they should be defined as 4 spaces.

### Column Width

You know what?  It's no longer 1928...if you want your columns to be more than 80 characters, go for it!
If you come across someone still using IBM punch cards...please let me know because that's amazing.

I say go ahead, get crazy, and limit your columns to 120 characters...we can live like kings!

### Pipelines

If the entirety of a pipeline fits on a single line it should be expressed on
a single line.
However, if a pipeline will not fit on a single line, then every pipe within
the statement should be split onto it's own line and indented below the start
of the command.

Example:

``` bash
# Fits on one line
command1 | command2

# Needs multiple lines
command1 \
  | command2 \
  | command3 \
  | command4
```

### Loops and Constructs

When building a loop or if/then construct one should include `; then` & `; do`
on the same line as `if`/`for`/`while`/`until`.

Although functionally there is no difference, this method is shorter.

Example:

``` bash
if [[ condition ]]; then
  ...
fi
```

An exception would be if your condition is too long to fit in a single line, such as:

``` bash
if [[ some_long_thing == some_other_long_thing || -z more_conditions ]]
do
  ...
fi
```

### Case

* Expressions should be indented one tab from the case/esac
* One-line commands can be placed on the same line as the expression
* Multi-line commands should start one line after and indented one tab from their expression.
* All case statements should include the `*)` expression as a catch all for unexpected expressions
* It is not required to quote the parameter in case since it does not undergo word splitting

#### Short

``` bash
case $word in
  a) command ;;
  b) command ;;
  f) command ;;
  v) command ;;
  *) echo.error "Unexpected input: $word" ;;
esac
```

#### Long

``` bash
case $word in
  match1)
    command1
    command2
  ;;
  match2)
    command1
    command2
  ;;
  *)
    echo.error "Unexpected input: $word"
  ;;
esac
```

### Variable Expansion

Quote your variables.

The only time variables should be unquoted is when you **KNOW** they **CANNOT**
be quoted.  If you run into this situation, chances are you should use an array
and *quote it*.

Need to pass arguments through a variable?  Use an array:

``` bash
# Incorrect
MY_ARGS="
-e "s|\*\*jobname\*\*|$jobname|g"
-e "s|\*\*hostname\*\*|$hostname|g"
-e "s|\*\*hostport\*\*|$hostport|g"
-e "s|\*\*rmttrailname\*\*|$rmttrailname|g"
"
sed $MY_ARGS $file

# Correct
declare -a MY_ARGS
MY_ARGS+=(
	-e "s|\*\*jobname\*\*|$jobname|g"
	-e "s|\*\*hostname\*\*|$hostname|g"
	-e "s|\*\*hostport\*\*|$hostport|g"
	-e "s|\*\*rmttrailname\*\*|$rmttrailname|g"
)
sed "${MY_ARGS[@]}" "$file"
```

### Quoting

* Always quote strings containing variables, command substitutions, spaces or shell meta characters, unless careful unquoted expansion is required.
* Single quote any string that does not require expansion.
* You can quote literal integers. (What's your [problem](https://google.github.io/styleguide/shell.xml?showone=Quoting#Quoting) Google?)
* Unsure if it should be quoted?  **It should**

## Features and Bugs

### Listing Files

* You should never [parse ls](http://mywiki.wooledge.org/ParsingLs).
* You should use shell globbing instead and when possible you should point to an absolute or relative path
rather than simply globbing.
* Additionally you should add some logic where possible to verify the file(s) you are performing actions on are
correct.

``` bash
# Incorrect -- and unsafe
for f in $(ls); do
	...
done

# Correct but not ideal
for f in *; do
	...
done

# Correct
for f in ./*; do
	if [[ -f "$f" ]]; then
		...
	else
		echo.error "Error message"
	fi
done
```

### Command Substitution

Backticks `` `...` `` have been completely and entirely superceded by subshell
substitution `$( ... )`.

Example:

``` bash
# Don't
var=`...`

# Do
var=$(...)
```

### Tests

Bash tests are done using `[[ ... ]]`.

`[` is a shell command and is subject to word splitting and pathname expansion
`[[` is a keyword and not a command.  Therefore it receives special treatment
from the shell, and is not subject to word splitting or pathname expansion.

Additionally the `[[` test construct supports limited regex pattern matching.

#### Strings

Since we are using the bash test `[[` and not that old shell test `[`,
we can take advantage of bash's ability to deal with empty strings.  Because of
this you _should not_ use filler characters, but instead use bash string
comparison operators:  _==_, _!=_, _-z_, _-n_

Example:

``` bash
# Not Correct
if [[ "${my_var}x" == "a stringx" ]]; then
    ...
fi

# Correct
if [[ "$my_var" == "a string" ]]; then
    ...
fi

# Not Correct
if [[ "$my_var" == "" ]]; then
    ...
fi

# Correct
if [[ -z "$my_var" ]]; then
    ...
fi

# Not Correct
if [[ "$my_var" ]]; then
    ...
fi

# Correct
if [[ -n "$my_var" ]]; then
    ...
fi
```

### Globbing

Always use a path when globbing.  A full path is preferred, but at the very
least you should use a relative path.  Additionally, if possible, you should
add as many patterns to match as you can to narrow the potential results.

As filenames could start with `-` or even more malicious patterns, whenever you
are using glkobbing to iterate over filenames you should terminate
your command arguments with `--` to ensure nothing that follows will be
interpreted as an option.

``` bash
# Pretend your directory contains:
$ ls -l
total 0
-rw-r--r--  1 jessebutryn  staff   0 Dec 22 14:05 -f
-rw-r--r--  1 jessebutryn  staff   0 Dec 22 14:05 -r
drwxr-xr-x  2 jessebutryn  staff  64 Dec 22 14:05 somedir
-rw-r--r--  1 jessebutryn  staff   0 Dec 22 14:05 somefile

# Now you execute:
$ rm -v *
somedir
somefile
# You have executed:
# rm -v -f -r somedir
# rm -v -f -r somefile

# What you should do instead:
$ rm -v -- ./*
./-f
./-r
rm: ./somedir: is a directory
./somefile
```

### Eval

Why would it exist if it didn't have a use right?

_Meh_

Avoid it at all costs.

## Naming Conventions

### Functions

Function names should be all lowercase characters as they emulate commands,
which are traditionally represented in lowercase letters.

### Variables

* Environmental variables should be represented in uppercase characters only.
* Shell and Global variables should be in lowerchase characters only.
* Local variables should begin with an underscore `_` and be in lowercase characters only.
* Multiple word variables should be delimited by an underscore `_`.

If possible you should prefix all variables with a string representing the
script/function in order to avoid conflicts with existing variables.

Example:

``` bash
# environmental variables
MSHARE_LOG='/path/to/log'

# local variables
my.func () {
  local _myfunc_var="$1"
}
```

[Go back](./README.md)
