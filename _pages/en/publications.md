---
layout: page
permalink: /publications/
title: publications
lang: en
ref: publications
description: Journal articles, papers under review, domestic conference presentations, and patents. * denotes equal contribution.
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
