# Useless Uses of Grep

There is almost no reason to use `grep` in combination with `awk` or `sed`.  Both of those tools are capable of
pattern matching.

**Don't**
``` bash
ps -l | grep -v '[g]rep' | awk '{print $2}'
```

Why spawn the `grep` process when you can do this:

**Do**
``` bash
ps -l | awk '!/[a]wk/{print $2}'
```
