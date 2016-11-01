---
title: "RFCs for fun"
---
<br>
Most of my time spent in front of computer nowadays (which itself comprises of most of the time I am awake &#x1F60B; ) is going through RFCs and wikipedia. But when something funny hits you when it's expectations are the least, its worth a gem. So today I came across a funny article about a successful implementation of an RFC which was supposed to be an April Fool's joke by David Waitzman (<u>RFC 1149</u> to be specific). This protocol is entirely based on the fact that IP is dumb (pun intended) and makes very few assumptions about the link layer below it. In fact it is so dumb that one can use pigeons as a substitute for wifi/ethernet (again, pun intended). This protocol was actually taken seriously by a group of Norwegian Linux geeks and they actually demonstrated it. Here is there experiment.

```
Script started on Sat Apr 28 11:24:09 2001
vegard@gyversalen:~$ /sbin/ifconfig tun0
tun0      Link encap:Point-to-Point Protocol
          inet addr:10.0.3.2  P-t-P:10.0.3.1  Mask:255.255.255.255
          UP POINTOPOINT RUNNING NOARP MULTICAST  MTU:150  Metric:1
          RX packets:1 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0
          RX bytes:88 (88.0 b)  TX bytes:168 (168.0 b)

vegard@gyversalen:~$ ping -c 9 -i 900 10.0.3.1
PING 10.0.3.1 (10.0.3.1): 56 data bytes
64 bytes from 10.0.3.1: icmp_seq=0 ttl=255 time=6165731.1 ms
64 bytes from 10.0.3.1: icmp_seq=4 ttl=255 time=3211900.8 ms
64 bytes from 10.0.3.1: icmp_seq=2 ttl=255 time=5124922.8 ms
64 bytes from 10.0.3.1: icmp_seq=1 ttl=255 time=6388671.9 ms

--- 10.0.3.1 ping statistics ---
9 packets transmitted, 4 packets received, 55% packet loss
round-trip min/avg/max = 3211900.8/5222806.6/6388671.9 ms
vegard@gyversalen:~$ exit

Script done on Sat Apr 28 14:14:28 2001
```

Linux geeks are also cool, eh ?

PS: Turns out that there is a whole list of such <u>April Fool's RFCs</u>... since you have already spent some time coming down till here, head over to [here](https://www.wikiwand.com/en/April_Fools%27_Day_Request_for_Comments) for some more good time.
