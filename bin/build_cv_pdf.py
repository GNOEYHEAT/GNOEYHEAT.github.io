#!/usr/bin/env python3
"""Build the downloadable CV PDFs (English and Korean).

Sources (the same ones the website uses):
  _data/cv.yml               CV data (education, experience, projects, awards, ...)
  _bibliography/papers.bib   international papers
  _data/i18n.yml             section titles for each language
Layout:
  cv_pdf/cv.typ              Typst template

Output:
  assets/pdf/cv_taehyeong_kim_en.pdf
  assets/pdf/cv_taehyeong_kim_ko.pdf

Requirements: `pip install typst pyyaml` and a Korean font
(`sudo apt-get install fonts-noto-cjk`). The deploy workflow runs this before the
Jekyll build, so the PDFs always match the data in the repository.

Usage: python3 bin/build_cv_pdf.py
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

import typst

ROOT = Path(__file__).resolve().parent.parent
BIB = ROOT / "_bibliography" / "papers.bib"
TEMPLATE = ROOT / "cv_pdf" / "cv.typ"
OUT_DIR = ROOT / "assets" / "pdf"
FONT_DIRS = ["/usr/share/fonts", str(ROOT / "cv_pdf" / "fonts")]


def _read_braced(text: str, start: int) -> tuple[str, int]:
    """Return the content of the {...} group starting at text[start] == '{'."""
    depth = 0
    for i in range(start, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                return text[start + 1 : i], i + 1
    raise ValueError("unbalanced braces in papers.bib")


def parse_bib(text: str) -> list[dict]:
    """Minimal BibTeX reader for papers.bib (fields written as name = {value})."""
    text = "\n".join(line for line in text.splitlines() if not line.lstrip().startswith("%"))
    entries = []
    for m in re.finditer(r"@(\w+)\s*\{\s*([^,\s]+)\s*,", text):
        body, _ = _read_braced(text, text.index("{", m.start()))
        fields = {"type": m.group(1).lower(), "key": m.group(2)}
        pos = body.index(",") + 1
        for fm in re.finditer(r"(\w+)\s*=\s*\{", body[pos:]):
            value, _ = _read_braced(body, pos + fm.end() - 1)
            fields[fm.group(1).lower()] = re.sub(r"\s+", " ", value.replace("{", "").replace("}", "")).strip()
        entries.append(fields)
    return entries


def format_authors(raw: str) -> list[dict]:
    """'Kim*, Taehyeong and Han, Sung Won' -> [{name: 'Taehyeong Kim', mark: '*'}, ...]"""
    authors = []
    for part in raw.split(" and "):
        last, _, first = (s.strip() for s in part.partition(","))
        mark = "*" if last.endswith("*") else ""
        authors.append({"name": f"{first} {last.rstrip('*')}".strip(), "mark": mark})
    return authors


def papers() -> list[dict]:
    result = []
    for e in parse_bib(BIB.read_text(encoding="utf-8")):
        result.append(
            {
                "status": e.get("status", "published"),
                "title": e.get("title", ""),
                "authors": format_authors(e.get("author", "")),
                "venue": e.get("journal") or e.get("booktitle") or "",
                "year": e.get("year", ""),
                "note": e.get("note", ""),
            }
        )
    return result


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    papers_json = json.dumps(papers(), ensure_ascii=False)
    for lang in ("en", "ko"):
        out = OUT_DIR / f"cv_taehyeong_kim_{lang}.pdf"
        typst.compile(
            str(TEMPLATE),
            output=str(out),
            root=str(ROOT),
            font_paths=[d for d in FONT_DIRS if Path(d).is_dir()],
            sys_inputs={"lang": lang, "papers": papers_json},
        )
        print(f"wrote {out.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
