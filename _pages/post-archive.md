---
layout: archive
title: "<u>All Posts</u>"
permalink: /posts/
author_profile: true
---

{% include base_path %}
<br>
<div class="grid__wrapper">
  {% for post in site.posts %}
  {% include archive-single.html type="list" %}
  {% endfor %}
</div>

<br>

***
