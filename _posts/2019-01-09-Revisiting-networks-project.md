---
title: "Revisiting the concurrency design of Networks' course project"
layout: single
---

Recently during a conversation about a concurrency problem which I faced while
working on an internal project at [@hackcave](https://github.com/hackcave/), I
came to realize that the course
[project](https://github.com/shivansh/videoStream) for Computer Networks that I
made during the fall semester of 2017 was [concurrent but not
parallel](https://stackoverflow.com/a/1050257/5107319).

I was initially of the thought that the thread-based design which I had come up
with was parallel. However, there was one thing which I didn't take into
account - [**GIL**](https://wiki.python.org/moin/GlobalInterpreterLock). I find
it weird that I didn't pay attention to this while I was thinking about the
design back then, as I'm pretty sure I was aware of the GIL at the time. Maybe
the pressure of multiple deadlines during that particularly heavy semester made
me skip this one fine detail (petty excuses).

## A brief background
During the first week of Jan '19, I was working on a specific task (cannot
share details here) where DB writes were causing latency in the main thread and
had to be separated. The solution to this was fairly simple - create a separate
process for performing the writes, and use a shared message queue for
communicating the relevant parameters. It is a single-writer single-reader
problem, and Python's
[multiprocessing](https://docs.python.org/2/library/multiprocessing.html)
seemed like an appropriate choice.

My course project for Computer Networks was a streaming protocol inspired by
RTP. Our group mainly focussed on the broadcast part, where a single-writer
retrieves the frames from a webcam and sends it to all the active readers. It
was based on a multi-threaded model, and one of the primary challenges was to
design a lock-free payload queue (where each payload is a collection of
frames). The details of the design are available in the [project
report](https://github.com/shivansh/videoStream/blob/master/report/cs425-mini-project.pdf).

In retrospect, the project was a great learning experience. However, there are
a couple of downsides with the approach used -

- The model isn't parallel due to GIL
- Manually introducing thread switches (via sleep) to enforce proper ordering
  of reader/writer seems to be a wasteful approach

There are two alternative approaches I can think of at the time, outlined
below.

## Multiplexing
Multiplexing is something which I have been willing to try for a long time, and
this seems like a perfect use case. I'll be updating this segment of the blog
once I get a chance to experiment with multiplexing in this project.

## Message passing
A relatively simplified approach to this problem is a multi-process message
passing model. It is simple to implement and also circumvents the issues in the
previous model.

I did a complete rewrite of the project using rabbitmq's [fanout
exchange](https://www.rabbitmq.com/tutorials/tutorial-three-python.html).
Interestingly, there is a 66% reduction in the SLOC, and the logic is much more
straightforward. The implementation is available
[here](https://github.com/shivansh/parallel-video-streaming).

## Benchmarks
I am yet to workout a proper setup required to benchmark both the models
outlined above (generating metrics for a multi-process model _might_ not be
straightforward). This segment of the blog will be updated as soon as I find
some time.
