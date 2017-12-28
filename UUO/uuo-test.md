# Useless Uses of Test

There is rarely a good reason to use `$?` in your scripts.  Instead of executing a command and then testing it's
return code, you can simply test the return of the command itself all in one action.

**Don't**

``` bash
ping -c1 8.8.8.8 &>/dev/null
if [[ $? -eq 0 ]]; then
        echo "Alive"
else
        echo "Dead"
fi
```

**Do**

``` bash
if ping -c1 8.8.8.8 &>/dev/null; then
        echo "Alive"
else
        echo "Dead"
fi

# Alternatively, a subshell can be used for cleanliness
if ( ping -c1 8.8.8.8 &>/dev/null ); then
        echo "Alive"
else
        echo "Dead
fi
```