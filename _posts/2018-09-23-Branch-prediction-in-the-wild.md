---
title: "Branch prediction in the wild"
layout: single
---

You must have previously heard of the [coin change problem](https://en.wikipedia.org/wiki/Change-making_problem) in some form or the
other. I was revisiting this problem today and was reminded of an interesting
answer I read on stackoverflow a long time back -

|:---:|
| [Why is it faster to process a sorted array than an unsorted array?](https://stackoverflow.com/a/11227902/5107319) |


The source code (in C++) of the solution goes as follows -

```c++
int coinChange(vector<int>& coins, int amount) {
    // dp[i] tracks the min. number of coins required to create denomination i.
    vector<int> dp(amount + 1, amount + 1);
    dp[0] = 0;  // no coins are required to create a nil denomination
    for (int i = 1; i <= amount; ++i) {
        for (const auto& c : coins) {
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

Let's collect some data on the speed of the current program. The following
input was used as test data on my machine ([specs](/assets/tmp/machine-specs.txt)) -

```
coins:  {3, 7, 405, 436, 4, 23}
amount: 88392175
```

The program was compiled with the default optimization flag (`-O0`) using `g++`.
The running time recorded on the above input was -

```
14.83s user 0.13s system 99% cpu 14.961 total
```

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

```
15.42s user 0.11s system 99% cpu 15.525 total
```

Well, that didn't work out as we expected! In fact, the program is now slower
than before. (_need to inspect this more_)

One possible reason behind this is that even though the `coins` vector is sorted,
the processor is still switching branches quite frequently. To be more precise,
we make a single pass through the `coins` vector in each iteration of the outer
for-loop, and the distance between consecutive inflection points is `coins.size()`
on average. All we need to do now is to make these inflection points lie farther apart.

One solution is to switch the inner and outer for-loops. This won't have any
effect on the semantics of the program, but now the inflection points will be
`amount` distance apart on average. `amount` is significantly larger than
`coins.size()`, and now the processor will be switching branches a lot less
frequently than before.

```diff
     sort(coins.begin(), coins.end());
-    for (int i = 1; i <= amount; ++i) {
-        for (const auto& c : coins) {
+    for (const auto& c : coins) {
+        for (int i = 1; i <= amount; ++i) {
             if (c <= i) {
```

Let's run the tests again -

```
6.66s user 0.11s system 98% cpu 6.853 total
```

A reduction of `8.672` seconds - the gains are significant indeed!

NOTE: there might be other factors at play apart from the one mentioned. Do let
me know in case you find something missing!

Thanks for reading.
