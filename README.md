# WTFisBASH?

This repository is a place for me to store reference materials, examples, guides, etc.  The purpose of this repository
is to maintain an easily referenced and concise aggregation of bash related knowledge that I would otherwise
certainly forget.

## Useless Uses

A common joke in the Unix comminity is the "Useless Use of Cat" which most people (myself included) are frequently guilty.
Aside from cat there are a few other utilities that are often misused.

* [Useless uses of](./UUO/uuos.md)

## Functions

Here you can find a list of some of the functions I find useful.

* [Functions](./functions.md)

## U&L Common Duplicates

This is a list of canonical questions from the Unix & Linux Stack Exchange that are commonly asked over and over.
Because they are so common it is a good place to look for solutions to issues you may experience.

* [U&L Duplicates](./UL_Duplicates.md)

## Style Guide

I wrote a style guide, mostly based on [Google's style guide](
https://google.github.io/styleguide/shell.xml) however I don't agree with many of the practices that they 
recommend/introduce.  Since code style is strongly opinionated and usually a catalyst for conflict I recommend you skip
this and don't read my guide.  If you must it can be found below:

* [Bash Style Guide](./style-guide.md)

## Recommended Resources

This is just a list of my favorite places to obtain information about bash scripting

* [Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)
  * This is *the* authoritative reference for anything bash related.  They made it after all.  It is also extremely easy
  to ready from start to finish.
* [Bash Pitfalls](http://mywiki.wooledge.org/BashPitfalls)
  * You should read this entire page twice before writing any script that will be run in production.
* [Shell & Utilities](http://pubs.opengroup.org/onlinepubs/9699919799.2016edition/utilities/contents.html)
  * This resource is written specifically for `sh` however it includes many useful lessons still relevant to bash and
  other utilities one would use in a bash script.
* [The GNU Awk User's Guide](https://www.gnu.org/software/gawk/manual/gawk.html)
  * While `awk` is a separate programming language altogether, being proficient with it's use will certainly improve
  the functionality and performance of your bash scripts.
* [U&L Stack Exchange](https://unix.stackexchange.com/)
  * This site has become the default catch-all for bash related questions.  While they can also be posted on
  stack overflow, I believe that U&L is a much better resource for bash/shell scripting.
* [The Unix Shell](https://archive.org/stream/byte-magazine-1983-10/1983_10_BYTE_08-10_UNIX#page/n187/mode/2up)
  * This is an article written by Stephen Bourne about the Bourne Shell but has some good information relevant to Bash
  and is a cool piece of history in general.

## Miscellaneous Reading

This section will contain a list of links to various articles/sites that I think are worth reading but could not find
another spot to put them in.

* [Why does my shell script choke on whitespace or other special characters?](https://unix.stackexchange.com/q/131766/237982)
* [bashrc PS1 generator](http://bashrcgenerator.com/)
* [Handling Positional Parameters](http://wiki.bash-hackers.org/scripting/posparams)
* [bash_profile vs bashrc](http://www.joshstaiger.org/archives/2005/07/bash_profile_vs.html)
