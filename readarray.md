# mapfile and readarray

`mapfile` (an alias to `readarray`) is a handy way to make an array separated 
by newlines in bash.  This can be used to read from stdin, from a file 
directly, or from process substitution.  In any case you can use either
`mapfile` or `readarray` interchangeably. 

## Example 1

### Sample input 1 

``` bash
$ cat input
This is a file containing
multiple lines of 	whitespace delimited
text.  Lets see how mapfile deals with
them.
```

(Yes I just used cat inappropriately)

### Create array 1

``` bash
$ mapfile -t my_array < input
```

### The array 1

``` bash
$ declare -p my_array
declare -a my_array=(
	[0]="This is a file containing" 
	[1]=$'multiple lines of \twhitespace delimited' 
	[2]="text.  Lets see how mapfile deals with" 
	[3]="them."
)
```

``` bash
$ for line in "${my_array[@]}"; do echo "$line"; done
This is a file containing
multiple lines of 	whitespace delimited
text.  Lets see how mapfile deals with
them.
```

## Example 2

### Sample input 2

```
$ ls -l
total 0
-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file0
-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file1
-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file2
-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file3
-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file4
```

### Create array 2

``` bash
$ readarray -t my_array < <(ls -l)
```

### The array 2

``` bash
$ declare -p my_array
declare -a my_array=(
	[0]="total 0" 
	[1]="-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file0" 
	[2]="-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file1" 
	[3]="-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file2" 
	[4]="-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file3" 
	[5]="-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file4"
)
```

``` bash
$ for line in "${my_array[@]}"; do echo "$line"; done
total 0
-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file0
-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file1
-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file2
-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file3
-rw-r--r--  1 jessebutryn  staff  0 Apr 11 15:37 file4
```
