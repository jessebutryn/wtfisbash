# Useless Uses of Ls

`ls` should not be used in any script.  Seriously, if you find yourself writing `ls` in a file and then are
tempted to save it, don't.  Especially don't execute that file if you do save it.

If you are tempted to [Parse ls](http://mywiki.wooledge.org/ParsingLs), try the following instead:

``` bash
for f in /full/pathto/dir/*; do
        [[ -f "$f" ]] || continue
        do something with "$f"
done

find /full/pathto/dir -type f -name "*" -exec command {} \;
```

[Go back](./uuos.md)
