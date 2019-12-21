# Useless Uses of Wc -l

`wc -l` can almost always be replaced with `grep -c`

**Don't**

``` bash
command | grep '..*' | wc -l
```

**Do**

``` bash
command | grep -c .
```

[Go back](./uuos.md)
