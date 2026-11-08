---
layout: page
permalink: /ko/publications/
title: 논문
lang: ko
ref: publications
description: 학술지 논문, 심사 중인 논문, 국내 학술대회 발표, 특허 목록입니다. * 표시는 공동 제1저자입니다.
nav: true
nav_order: 1
---

{% assign t = site.data.i18n[page.lang] %}

{% include bib_search.liquid %}

<div class="publications">

<h2 class="bibliography">{{ t.under_review }}</h2>

{% bibliography --group_by none --query @*[status=review]* %}

<h2 class="bibliography">{{ t.journal_and_proceedings }}</h2>

{% bibliography --query @*[status=published]* %}

</div>

{% include cv_extra_publications.liquid lang=page.lang %}
