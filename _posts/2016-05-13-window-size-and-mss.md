---
title: "window size, mss, mtu...what's all the fuss about?"
layout: single
---

So it has been some time since I started reading about TCP/IP and networks in detail, and there is one thing which confused me a lot initially - window size, transmission unit and segment size. When given a first read, they tend to seem nearly same, well not same but one might be tempted to think "Why was there even a need to define these separately?". <br>
So let's go through each of them, and then try to figure out where the difference lies.

## TCP windows
When we think about TCP, there are two entities on which transport depends - the capacity of the network and the capacity of the endpoints (the client and the server). **Congestion window** marks the limit of data which can be held by the network, a process known as **congestion control** and the **receive window** tries not to exceed the capacity of the receiver to process data, a process known as **flow control**.

## MSS (Maximum TCP segment size)
Before going on to mss, let's first understand what a TCP segment is. A segment is data (obtained from a data stream) along with a TCP header. A typical TCP header looks something like this-<br><br>
<center><img src="/images/tcp-header.gif"></center>
<br> Now, **mss** denotes the maximum amount of data that a communication device is willing to handle in a single (reconstructed) TCP segment (header excluded). Having said that, one is right to derive a conclusion that the congestion window size is effectively a multiple of **mss**. Also, **mss** has no bearing on the receive window.
MSS is normally decided during the three-way handshake.

## MTU (Maximum transmission unit)
MTU is the largest size packet or frame, specified in octets, that can be sent in a packet or frame based network (such as the Internet).

The confusing part is, on reading the above, one might wonder where actually do **frames**, **packets** and **segments** differ? This diagram pretty much summarises the differences.<br><br>
<center><img src="/images/layers.png" width="80%"></center>
:point_right: [Reference](http://stackoverflow.com/a/31464376/5107319){:target="_blank"}

It suggests that all of them are units of data, but are associated with different <a href="https://www.wikiwand.com/en/OSI_model" target="_blank">layers</a>. What this essentially means is that on progressing down the layers, each unit of data is wrapped up with some additional information.<br>

* **Application layer:** For the first part, raw data enters through the application (say you send a message to someone via a messaging client using the socket API).
* **Transport layer:** For the next part, TCP/UDP headers are associated with the data (yes, the same ones we saw previously) :arrow_right: **<u>Segment</u>**.
* **Internet layer:** Next IP headers are associated. IP headers contain information about IP version, source IP, destination IP, time-to-live (**ttl**) , etc :arrow_right: **<u>Packet/Datagram</u>**.
* **Link layer:** Finally, frame headers (source and destination MAC addresses) and footers (frame check sequence, **FCS** which is an extra error-detecting code) are associated (more on the specifics in future) :arrow_right: **<u>Frame</u>**.

Interestingly, the above diagram itself is enough for clearly denoting the difference between **mss** and **mtu** (based on the layers with which they are associated with).

## Some specifics
* The default TCP **mss** is 536 bytes. It's value can be optionally set as a TCP option, but cannot be changed once the connection is established.
* The Internet de facto standard **mtu** is 576 bytes, but ISPs often suggest using 1500 bytes.
* Maximum **window size** is 65,535 bytes.

## What happens when packet sizes exceed the specified limit ?
Packets which are bigger than the MTU are fragmented at the point where lower MTU is found and is then reassembled further down the chain.
However, packets exceeding MSS are **NOT** fragmented, they are simply discarded.

Thanks for reading. Hope it helps.
