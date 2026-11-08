# gnoeyheat.github.io

Personal academic homepage of **Taehyeong Kim (김태형)**, built with the [al-folio](https://github.com/alshedivat/al-folio) Jekyll theme (MIT License).

## Where to edit

| What | File |
| --- | --- |
| Site name, URL, author name highlighting | `_config.yml` |
| Biography, profile photo | `_pages/about.md`, `assets/img/prof_pic.jpg` |
| Papers (journal, under review) | `_bibliography/papers.bib` |
| Domestic presentations, patents | `_pages/publications.md` |
| CV page | `_data/cv.yml` |
| Email / GitHub / LinkedIn / Scholar icons | `_data/socials.yml` |
| News items on the front page | `_news/` (then set `announcements.enabled: true` in `_pages/about.md`) |

## Deploy

Pushing to `main` runs `.github/workflows/deploy.yml`, which builds the site and pushes it to the `gh-pages` branch.
In the repository settings, set **Pages → Source** to the `gh-pages` branch and **Actions → Workflow permissions** to *Read and write*.

## Privacy note

This repository and its full git history are public. Do not commit the lecture list or a CV PDF that contains it.
