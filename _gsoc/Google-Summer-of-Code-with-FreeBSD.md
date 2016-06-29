---
title: "Google Summer of Code with FreeBSD"
layout: single
---


I am very much excited to say that I've been shortlisted for Google Summer of Code this year under FreeBSD.

This is the abstract for my project -

>Regression testing is one of the most critical elements of the test artifacts and proves to be one of the most preventive measures for testing a software. Currently, within FreeBSD, there is no such tool to perform regression testing of the TCP/IP network stack. The purpose of this project is to develop tests using a regression testing tool which can then be integrated with FreeBSD. The wire level regression test suite will exercise various states in the TCP/IP protocol suite, with both IPv4 and IPv6 support. Once integrated, the tool will also facilitate further development of such tests. The regression testing tool of choice here is Packetdrill. Packetdrill currently supports testing multiple scenarios for TCP/IP protocol suite within Linux. The existing Linux test suite implemented within Packetdrill will provide a basis for understanding, and implementation of the FreeBSD test suite.

Currently, community bonding period is going on in which we are supposed to get comfortable with the community and to make a plan of action for the time when the actual coding starts (23 May). I have already contributed 6 tests (the <a href="https://github.com/hirenp/packetdrill/pulls" target="_blank">pull requests</a> are yet to be merged &#x1F60B;), and currently studying various TCP scenarios upon which further tests will be made.

**Update**: The coding period starts now, let the hacking begin !!

This <a href="http://shivrai.github.io/gsoc/">section</a> of the blog will be updated regularly with the progress of the project, and the intrinsic details regarding the project can be found in the <a href="https://www.gitbook.com/book/shivrai/tcp-ip/details" target="_blank">git-book</a>. Plus you can also have a look at my FreeBSD <a href="https://wiki.freebsd.org/SummerOfCode2016/TCP-IP-RegressionTestSuite" target="_blank">wiki</a> for more details regarding the project.

Until next time...
