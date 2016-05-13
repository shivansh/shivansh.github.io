---
title: "window size, mss, mtu...what's all the fuss about?"
layout: single
---

So it has been some time since I started reading about TCP in detail, and there is one thing which confused me a lot - windows, transmission units and segments. When given a first read, they sound nearly same, well not same but one may be tempted to think "Why was there even a need to define them separately?". So let's go slowly about each of them, and then try to figure out where the difference lies.

## TCP windows
When we think about TCP, there are two entities on which transport depends - the capacity of the network and the capacity of the endpoints (namely the client and the server). **Congestion window** marks the limit of data which can be held by the network, a process known as **Congestion control** and the **Receive window** tries not to exceed the capacity of the receiver to process data, a process known as **Flow control**.

## MSS (Maximum segment size)
Before going on to mss, let's first understand what a TCP segment is. A segment is basically data (obtained from a data stream) along with a TCP header. A typical TCP header looks something like this.<br><br>
<center><img src="http://i.imgur.com/5oPxU0t.png"></center>
<br> Now, **mss** denotes the maximum amount of data that an endpoint can handle in a single TCP segment.

## MTU (Maximum transmission unit)
MTU is the largest size packet or frame, specified in octets (eight-bit bytes), that can be sent in a packet or frame based network such as the Internet.

The confusing part is, on reading the above, one might wonder where actually do **frames**, **packets** and **segments** differ? This diagram pretty much summarises the differences.<br><br>
<center><img src="http://i.stack.imgur.com/oMOGd.png" width="80%"></center>
<br> It suggests that all of them are units of data, but lie in different <a href="https://www.wikiwand.com/en/OSI_model" target="_blank">layers</a>.<br>
Interestingly, the above diagram itself is enough for clearly denoting the difference between **mss** and **mtu**.

## Some specifics
* The default TCP **mss** is 536 bytes. It's value can be optionally set as a TCP option, but cannot be changed once the connection is established.
* The Internet de facto standard **mtu** is 576, but ISPs often suggest using 1500.
* Maximum **window size** is 65,535 bytes.
