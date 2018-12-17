---
title: "Experimenting with the C memory allocator"
layout: single
---

|:---:|
| This post is inspired by the famous (and quite interesting) reddit thread: [How is GNU `yes` so fast?](https://www.reddit.com/r/unix/comments/6gxduc/how_is_gnu_yes_so_fast/). |


I am assuming that at this point you have already read the above mentioned
thread. Now, let's take things a bit further.

I wrote a small program along the lines of the one mentioned in the thread, with
a minor modification to the buffer size.

```c
#define LEN 2
#define BUFSIZE LEN * 8 * 1024  // page-aligned buffer

int main() {
    char yes[LEN] = {'y', '\n'};
    int used = 0;
    char *buf = malloc(BUFSIZE);
    while (used < BUFSIZE) {
        memcpy(buf + used, yes, LEN);
        used += LEN;
    }
    write(1, buf, BUFSIZE);
    while (write(1, buf, BUFSIZE))
        ;
    return 1;  // control flow cannot reach here
}
```

Before we talk stats, a few specs of my machine at the time of testing -

* Page size: 4 KiB
* Kernel version: 4.15.0-30-generic x86_64 GNU/Linux

The following observations were recorded for the write speeds of the above program
based on different values of `BUFSIZE` -

| BUFSIZE (KiB) | Write speed (GiB/s) |
|:-----------:|:-------------------:|
|      4      |         3.68        |
|      8      |         4.18        |
|      16     |         4.92        |
|      32     |         4.86        |

Write speed of `yes(1)` on my machine - 4.17 GiB/s

The speed of the program I have written seems to be **0.75 GiB/s more** than that of
GNU `yes(1)`.  
Wait, what? That doesn't seem right.  
But as it turns out, it is. I've
repeated the experiment multiple times and the same result is obtained.

It should be noted that the parameter which affects the performance of the above
program is `BUFSIZE`.  

|:---:|
| Before moving ahead, a [mini refresher on aligned v/s misaligned memory accesses](https://en.wikipedia.org/wiki/Data_structure_alignment#Problems). |

Let's see what is happening here at a finer granularity.  
It appears that using a buffer size of 16 KiB leads to larger write speed than
using a 4 KiB buffer (a difference of ~ 1.24 GiB/s). This is because there's no
guarantee that `malloc(3)` returns page-aligned address during allocation. Most
versions of malloc grab large chunks from some other allocator (`brk(2)`/`sbrk(2)`),
and satisfy small allocations from that large one--but a single larger allocation
will more or less be passed through to the other allocator. In this case, the
cutoff between the two may easily be 16 KiB. The other allocator probably does
(always) returns page-aligned chunks, so when we exceed that limit, we're
guaranteed a page-aligned chunk. But if we don't, we get whatever address
`malloc(3)` happens to have handy. The write speed saturates to around 4.9 GiB/s
for buffer sizes greater than 16 KiB.

NOTE: using `valloc(3)` should always return a page aligned memory address.

Thanks for reading.
