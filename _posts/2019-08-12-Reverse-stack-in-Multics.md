---
title: "Reverse stack in Multics"
layout: single
tags:
  - archeology
  - history
---

I came across an interesting article around the direction of stack growth and did some digging around for the same, summarised below.

Quoting from [Thirty Years Later: Lessons from the Multics Security Evaluation, Section 2.3.2](https://www.acsac.org/2002/papers/classic-multics.pdf)

> Third, stacks on the Multics processors grew in the positive direction,
> rather than the negative direction.  This meant that if you actually
> accomplished a buffer overflow, you would be overwriting unused stack frames,
> rather than your own return pointer, making exploitation much more difficult. 


[Intel Microprocessors: 8008 to 8086](http://tcm.computerhistory.org/ComputerTimeline/Chap37_intel_CS2.pdf)
> The stack pointer was chosen to run "downhill" (with the stack advancing
> toward lower memory) to simplify indexing into the stack from the user's
> program (positive indexing) and to simplify displaying the contents of the
> stack from a front panel.

Some more links on the topic, which also contain many external links -
* [https://stackoverflow.com/a/2035592/5107319](https://stackoverflow.com/a/2035592/5107319)
* [Stack directions in various archs](https://stackoverflow.com/a/664779/5107319)
