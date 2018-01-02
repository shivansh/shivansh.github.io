---
title: "My first FreeBSD bug fix"
layout: single
---

I came across an interesting bug recently while writing tests for utilities in the FreeBSD base system. Here is how it goes -

I was trying to make a kyua based test for the '-F' option of ln(1). This was the command which I ran successfully -

```
mkdir A B
truss -o ln.log ln -sF A B    # '-f' is assumed to be present by default
```

**<u>Actual results -</u>**  
It so happens here that even though the target directory B exists, neither unlink nor rmdir is being called [ideally rmdir should be called as specified in src/bin/ln/ln.c (line 307)].
The output of the above command is that B contains a broken symbolic link A to A.
I used truss(1) to trace the system calls when executing the above command and the `rmdir()` system call was missing from the log.

**<u>Expected results -</u>**  
The expected behavior was that directory B is supposed to be deleted and a new symbolic link B should be made to A. This is now fixed in [r320172](https://svnweb.freebsd.org/base?view=revision&revision=320172).

More details can be found here [[1]](https://svnweb.freebsd.org/base?view=revision&revision=321094)[[2]](https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=219943).
