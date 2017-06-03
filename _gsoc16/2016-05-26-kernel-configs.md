---
title: "Interesting error while running packetdrill scripts"
layout: single
---

Recently, I came across an error when I ran packetdrill scripts against my TUN device. The error was that there was a conflict in the scripts expected packet and the packet which was actually sniffed during the run. Something like this -
<br>

```
inbound injected packet:  0.100024 S 0:0(0) win 32792 <mss 1460,sackOK,nop,nop,nop,wscale 7>
outbound sniffed packet:  0.100133 S. 389822580:389822580(0) ack 1 win 29200 <mss 1460,nop,nop,sackOK,nop,wscale 7>
tests/linux/close/close-read-data-fin.pkt:11: error handling packet: bad outbound TCP options
script packet:  0.100000 S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK,nop,wscale 6>
actual packet:  0.100133 S. 0:0(0) ack 1 win 29200 <mss 1460,nop,nop,sackOK,nop,wscale 7>
```
<br>
As it can be noticed, the wscale options in the script packet and the actual packet are different.<br>
On doing a little research and visiting mailing lists, I finally found out the source of the error. It turns out that with TCP, the **wscale** and **receive window** behavior depends on the kernel implementation and configurations. The following sysctls are responsible for controlling the behavior in Linux - <br>

```
sysctl net.core.rmem_max
sysctl net.ipv4.tcp_rmem
```
<br>
Hence, either we can change the scripts to match the expected behavior or we can change the kernel configurations to match the script requirements.<br>
It's better that we don't drift off the default configurations.
