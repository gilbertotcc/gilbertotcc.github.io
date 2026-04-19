---
layout: page
title: Thought Leadership
permalink: /thought-leadership
---

<!-- markdownlint-disable MD013 -->
<!-- markdownlint-disable MD032 -->
<!-- markdownlint-disable MD055 -->
<!-- markdownlint-disable MD056 -->

This page showcases my contributions to the technology and fintech sectors,
including public speaking, technical reviews, and academic research.

## Speaking Appearances

| Date | Event | Role | Topic |
| :--- | :---- | :--- | :---- |
{% for talk in site.data.speaking -%}
| {{ talk.date }} | {{ talk.event }} | {{ talk.role }} | {{ talk.topic }} |
{% endfor %}

## Manuscript Reviews

Technical reviews for **Manning Publications** since 2019.

| Year | Title | Author | Status |
| :--- | :---- | :----- | :----- |
{% for review in site.data.reviews -%}
| {{ review.year }} | [{{ review.title }}]({{ review.link }}) | {{ review.author }} | Pub. {{ review.published }} |
{% endfor %}

## Academic Publications

My research focuses on the Internet of Things (IoT), cloud computing, and formal
verification.

| Year | Title | Authors | Publication |
| :--- | :---- | :------ | :---------- |
{% for pub in site.data.publications -%}
| {{ pub.year }} | **{{ pub.title }}** | {{ pub.author }} | *{{ pub.booktitle | default: pub.journal | default: pub.school | default: pub.organization | default: pub.publisher }}* |
{% endfor %}
