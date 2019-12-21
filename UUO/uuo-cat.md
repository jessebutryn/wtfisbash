# Useless Use of Cat

> The purpose of cat is to concatenate (or "concatenate") files. If it's only one file, concatenating it with nothing at
> all is a waste of time, and costs you a process.
> - Community

## Valid Uses of `cat`

Based on this [list](https://www.in-ulm.de/~mascheck/various/uuoc/)

* Concatenation

``` bash
cat file1 file2 file3 >main_file
```

* Embedded cat

``` bash
( cmd; cat file; cmd ) | cmd
```

* Create text files

``` bash
cat > textfile
```

This will allow you to begin typing text to be entered in the file.  You can send the EOF using ctrl+d.

* Transfer Large Amounts of Data

``` bash
tar cf - . | ssh remotehost 'cat > big.tar'
```

* Here Documents

``` bash
cat<<EOF
This is a here doc that contains
several lines of input
EOF
```

## Useless uses of `cat`

Based on this [article](http://porkmail.org/era/unix/award.html)

* Reading Files

``` bash
cat file
```

This is a security risk at worst and very inefficient at best.

* [CVE-2003-0063](https://nvd.nist.gov/vuln/detail/CVE-2003-0063)
* [CVE-2008-2383](https://nvd.nist.gov/vuln/detail/CVE-2008-2383)
* [CVE-2010-2713](https://nvd.nist.gov/vuln/detail/CVE-2010-2713)
* [CVE-2003-0020](https://nvd.nist.gov/vuln/detail/CVE-2003-0020)
* [CVE-2012-3515](https://bugzilla.redhat.com/show_bug.cgi?id=CVE-2012-3515)
* [More Reading](https://www.securityfocus.com/archive/1/archive/1/508830/100/0/threaded)

You should instead use a tool designed for both identifying and reading text files, such as:
`less`, `more`, `tail`, `head`, `vim`

These tools will error out if you attempt to open a non-text file with them preventing potentially dangerous and
undesirable results.

* Redirecting Variables

``` bash
cat "$VAR" | grep 'string'

cat "$VAR" | sed 's/string1/string2/'

cat "$VAR" | awk '{print $1}'
```

This is just an inefficiency.  The _Here String_ redirector is a more efficient way of handling this.

``` bash
grep 'string' <<<"$VAR"

sed 's/string1/string2/' <<<"$VAR"

awk '{print $1}' <<<"$VAR"
```

* note: here strings are not defined by POSIX and therefore may not be available in non-bash shells.

[Go back](./uuos.md)
