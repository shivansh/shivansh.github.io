---
title: "Branch prediction in the wild"
layout: single
---

You must have previously heard of the [coin change problem](https://en.wikipedia.org/wiki/Change-making_problem) in some form or the
other. I was revisiting this problem today and was reminded of an interesting
answer I read on stackoverflow a long time back -

|:---:|
| [Why is it faster to process a sorted array than an unsorted array?](https://stackoverflow.com/a/11227902/5107319) |


The source code (in C++) of the solution to the coin change problem goes as
follows -

```c++
int coinChange(const vector<int>& coins, int amount) {
    // dp[i] tracks the min. number of coins required to create denomination i.
    vector<int> dp(amount + 1, amount + 1);
    dp[0] = 0;  // no coins are required to create a nil denomination
    for (int i = 1; i <= amount; ++i) {
        for (auto& c : coins) {
            if (c <= i) {
                dp[i] = min(dp[i], 1 + dp[i - c]);
            }
        }
    }
    return (dp[amount] > amount) ? -1 : dp[amount];
}
```

This happens to be the optimal solution (to my knowledge) of the coin change
problem with a time complexity of `O(n * amount)` and a space complexity of
`O(amount)` (`n` being the size of `coins` vector). There are tons of articles
available which explain the above algorithm, however I won't go into those
details here. What I want to explore is whether it is possible to make this
program run faster without making any semantic changes to the algorithm.

All tests were done on my machine which had the following specs at the time of
testing -

* Kernel version: 4.15.0-30-generic x86_64 GNU/Linux
* gcc version: Ubuntu 7.3.0-16ubuntu3

Let's collect some data on the speed of the current program. The following
input was used as test data -

    coins:  {3, 7, 405, 436, 4, 23}
    amount: 88392175

**Note** that in this specific example, `amount` is significantly larger than
`coins.size()`.

The program was compiled with the default optimization flag (`-O0`) using `g++`.
The running time recorded on the above input was -

    14.83s user 0.13s system 99% cpu 14.961 total

As is obvious from the title of this post, we can probably make use of branch
prediction to squeeze out a few milliseconds. The first step in that direction
will be to sort the coins vector. ~~The time complexity of this step
is asymptotically smaller than our current algorithm's time complexity.~~

```diff
     dp[0] = 0;
+    sort(coins.begin(), coins.end());
     for (int i = 1; i <= amount; ++i) {
```

On making the relevant changes and running the tests, the following result is
recorded -

    15.42s user 0.11s system 99% cpu 15.525 total

Well, that didn't work out as we expected! In fact, the program is now slower
than before. (_need to inspect this more_)

One possible reason behind this is that even though the `coins` vector is
sorted, the processor is still switching branches quite frequently. To be more
precise, we make a single pass through the `coins` vector in each iteration of
the outer for-loop, and the distance between consecutive iterations where
branch switch occurs (due to the if-statement) is `coins.size()` on average.
All we need to do now is to make these switches lie farther apart.

One solution is to exchange the inner and outer for-loops. This won't have any
effect on the semantics of the program, but now the branch switches will be
`amount` distance apart on average. `amount` is significantly larger than
`coins.size()` (for this example), and now the processor will be switching
branches a lot less frequently than before.

```diff
     sort(coins.begin(), coins.end());
-    for (int i = 1; i <= amount; ++i) {
-        for (auto& c : coins) {
+    for (auto& c : coins) {
+        for (int i = 1; i <= amount; ++i) {
             if (c <= i) {
```

Let's run the tests again -

    6.66s user 0.11s system 98% cpu 6.853 total

A reduction of `8.672` seconds - the gains are significant indeed!

- - -

## Benchmarks

Below are a few benchmarks generated via `perf(1)`. Note that branch misses are
maximum in the first case and minimum in the last case.

### Without sort and without loop exchange

      15559.449556      task-clock (msec)         #    0.999 CPUs utilized
               229      context-switches          #    0.015 K/sec
                 6      cpu-migrations            #    0.000 K/sec
            86,438      page-faults               #    0.006 M/sec
    40,868,138,499      cycles                    #    2.627 GHz
    90,146,840,053      instructions              #    2.21  insn per cycle
    13,718,299,799      branches                  #  881.670 M/sec
       121,424,551      branch-misses             #    0.89% of all branches

      15.570897771 seconds time elapsed

### With sort and without loop exchange

      15790.581172      task-clock (msec)         #    1.000 CPUs utilized
               192      context-switches          #    0.012 K/sec
                 5      cpu-migrations            #    0.000 K/sec
            86,436      page-faults               #    0.005 M/sec
    41,377,099,491      cycles                    #    2.620 GHz
    90,145,379,523      instructions              #    2.18  insn per cycle
    13,719,167,993      branches                  #  868.820 M/sec
       124,073,050      branch-misses             #    0.90% of all branches

      15.796056471 seconds time elapsed

### Without sort and with loop exchange

       7240.322581      task-clock (msec)         #    0.999 CPUs utilized
               132      context-switches          #    0.018 K/sec
                 2      cpu-migrations            #    0.000 K/sec
            86,437      page-faults               #    0.012 M/sec
    18,930,247,315      cycles                    #    2.615 GHz
    48,527,363,072      instructions              #    2.56  insn per cycle
     6,937,998,117      branches                  #  958.244 M/sec
         7,821,022      branch-misses             #    0.11% of all branches

       7.249432807 seconds time elapsed

### With sort and with loop exchange

       6775.111452      task-clock (msec)         #    0.999 CPUs utilized
               106      context-switches          #    0.016 K/sec
                 4      cpu-migrations            #    0.001 K/sec
            86,439      page-faults               #    0.013 M/sec
    17,840,286,625      cycles                    #    2.633 GHz
    48,648,004,601      instructions              #    2.73  insn per cycle
     7,057,327,634      branches                  # 1041.655 M/sec
           255,889      branch-misses             #    0.00% of all branches

       6.779488807 seconds time elapsed


**NOTE:** there might be other factors at play apart from the one mentioned. Do let
me know in case you find something missing!

Thanks for reading.
