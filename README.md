# gnoeyheat.github.io

Taehyeong Kim (김태형) 개인 홈페이지 — https://gnoeyheat.github.io
[al-folio](https://github.com/alshedivat/al-folio) v1 기반입니다.

## 어디를 고치면 되나요

| 바꾸고 싶은 것 | 파일 |
| --- | --- |
| 학력·경력·프로젝트·수상·국내 발표·특허 등 CV 내용 (웹 CV + PDF 공통) | `_data/cv.yml` |
| 국제 학술지/학회 논문 | `_bibliography/papers.bib` |
| 소개 글 | `_pages/en/about.md`, `_pages/ko/about.md` |
| 메뉴·섹션 제목 등 화면 문구 (영/한) | `_data/i18n.yml` |
| 소셜 아이콘 (이메일, Scholar, LinkedIn, GitHub) | `_data/socials.yml` |
| 프로필 사진 | `assets/img/prof_pic.jpg` |
| CV PDF 디자인 | `cv_pdf/cv.typ` |

`main`에 push하면 GitHub Actions가 CV PDF(영문·국문)를 새로 만들고 사이트를 빌드해
`gh-pages` 브랜치로 배포합니다. PDF는 저장소에 커밋하지 않습니다.

## 페이지 구성

- 영문: `/`, `/publications/`, `/cv/`, `/repositories/` (`_pages/en/`)
- 국문: `/ko/`, `/ko/publications/`, `/ko/cv/`, `/ko/repositories/` (`_pages/ko/`)
- 같은 내용의 영문/국문 페이지는 front matter의 `ref` 값이 같고, 메뉴의 언어 버튼이 서로를 연결합니다.

## 로컬에서 PDF 만들기

```bash
pip install typst pyyaml        # 한글 글꼴: sudo apt-get install fonts-noto-cjk
python3 bin/build_cv_pdf.py     # assets/pdf/cv_taehyeong_kim_{en,ko}.pdf
```
