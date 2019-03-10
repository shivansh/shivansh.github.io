---
title: "Getting into GSoC '17 in 4 days"
layout: single
---

Yup, you heard that right. This time I got to spend only 4 days to work on the GSoC project proposal, and I got in :tada: !!

Before I go on to describe these 4 days, a bit of a background.  
The list of projects was released on March 1 and I chose the project "Updating dummynet for the 10 Gbps+ era". I contacted the mentors for this project (fortunately my previous year's GSoC mentor was a co-mentor for this project). I also got advice from the original author of dummynet **Luigi Rizzo** on how to proceed, and got a draft of the project proposal ready.
Luigi initially pointed out that doing what the project aims to do will be hard to achieve in the duration of a GSoC project, since it requires high experience in "performant packet processing", quoting himself "which is lacking even among experienced developers". This should have been a cue to what followed next.

_Fast-forward 28 days. This is when hell broke loose!_  

I got a message on IRC from the project's co-mentor that the project will most probably be dropped as the mentors have lot of work in their day jobs and hence won't be able to give enough time to the project.  
I still remember I sat their frozen in front of my laptop staring blankly at the screen for straight 2 minutes (yeah, that's quite long for a decent enough shock).  
The project was finally dropped and removed from the list later that night.

Initially I planned on giving up applying for GSoC this summer, but then thought no harm in giving one last try.  
Now, I had 4 days left. I had to choose a new project. Time was running out (quite fast).  
Ideally a GSoC project should be given **atleast** one month time (according to me) to properly go through all the relevant documentation, source code and work simultaneously on the project proposal. But a duration of 4 days is too short to achieve all of this "perfectly".  
Next 4 days saw little or no sleep, lots of coffee and a too much (seriously, a lot) time spent in front of computer. I chose a project, and went through the relevant documentation and prepared the code. Even though there was too much work, I heartily enjoyed every bit of doing it.  
Things weren't perfect, I am pretty sure I could have done much better had I few more days in hand. But to say the least, the project proposal looked good.

And now here we are !!

This is the abstract for my project -  

>Smoke testing is a set of light tests which are done for checking basic functionalities of a software to ascertain if the crucial functions work correctly.
FreeBSD currently has a set of tests under `src/tests` which are run using the `kyua` framework. These tests need to be first installed individually before they can be used for testing. This proves problematic in cases when direct testing of some newly installed or updated utility/library has to be performed. It makes testing changes to libraries and utilities difficult as one would like to perform tests (e.g. to ensure a proper build environment) before proceeding for installation.  
This project aims to develop a new test infrastructure and automation tool along with basic tests to verify if all the base utilities in FreeBSD are linked properly. The testing framework will ease the process of writing test cases which will be run in a completely automated and developer friendly manner without need for any prior installation. Once integrated, the tool will also facilitate further development of tests.

You can track the progress of the project on [Github](https://github.com/shivrai/smoketestsuite/) and the [FreeBSD wiki](https://wiki.freebsd.org/SummerOfCode2017/SmokeTestingOfBaseUtilities). The project proposal is available [here](/assets/tmp/GSoC17ProjectProposal.pdf).

Since I had no hope that my proposal for GSoC will be accepted, I also applied in [Haskell Summer of Code](https://summer.haskell.org/) and [got in it as well](/images/hsoc17-acceptance.png) :smile:. Had to back out of it since cannot "officially" participate in both HSoC and GSoC simultaneously.

In hindsight, a lesson for those willing to apply in GSoC in the future - it's always better to have a rough idea of 1 more project along with your main project so that if the same situation arises, it can be dealt smoothly.

Thanks for reading!
