---
name: pandoc
description: Use when converting documents between formats (Markdown, DOCX, PDF, HTML, LaTeX, etc.), generating presentations (Beamer, reveal.js), handling citations/bibliographies, or preparing markdown for Google Docs or other word processors.
metadata:
    categories:
        - core
---

# Skill: pandoc

Convert documents between formats using pandoc, the universal document converter.

---

## When to Use

Automatically invoke this skill when the user:

- Mentions "convert to PDF", "generate PDF", "export to Word/DOCX"
- Asks about "pandoc", "markdown to PDF", "document conversion"
- Shows markdown with YAML frontmatter
- Asks about citations, bibliographies, academic papers
- Requests help with presentations (Beamer, reveal.js)
- Mentions LaTeX, XeLaTeX, or PDF engines
- Has errors converting documents

**NOTE**

- For conversion to `.md`, prefer `markitdown` for better structured output.

---

## Usage Guide

The syntax for the `pandoc` CLI is straightforward:

```bash
pandoc <input> [options] -o <output>
```

Where

- `<input>` can be a file path or URL.
- The `-o` flag specifies the output file; pandoc infers the format from its extension (override with `-t`).

### File Conversions Examples

```bash
# Basic conversion
pandoc input.md -o output.docx

# PDF Conversion - use `tectonic` as PDF engine.
pandoc input.md --pdf-engine=tectonic -o output.pdf

# With table of contents
pandoc input.md --toc -o output.docx

# With custom reference doc (for styling)
pandoc input.md --reference-doc=template.docx -o output.docx

# Standalone with metadata
pandoc input.md -s --metadata title="Document Title" -o output.docx

# Convert into Markdown (reverse direction)
pandoc input.docx -o output.md
pandoc input.html -o output.md

# With citations/bibliography
pandoc input.md --citeproc --bibliography=refs.bib -o output.pdf --pdf-engine=tectonic

# Presentation slides
pandoc slides.md -t beamer -o slides.pdf --pdf-engine=tectonic
pandoc slides.md -t revealjs -s -o slides.html
```

### Quick Reference

| Task                      | Command                                                            |
|---------------------------|--------------------------------------------------------------------|
| Markdown → DOCX/PDF/HTML  | `pandoc input.md -o output.<ext>`                                  |
| DOCX/HTML → Markdown      | `pandoc input.<ext> -o output.md`                                  |
| Citations & bibliography  | `pandoc input.md --citeproc --bibliography=refs.bib -o output.pdf` |
| Beamer / reveal.js slides | `pandoc slides.md -t beamer\|revealjs -o slides.<ext>`             |

---

## Common Mistakes

- Forgetting `--pdf-engine=tectonic` on PDF output — pandoc defaults to `pdflatex`, which is not installed, and fails
  with a confusing "pdflatex not found" error.
- Expecting citations to render without `--citeproc` — pandoc leaves citation keys (e.g. `[@key]`) unprocessed unless
  it's passed.

---

## Installation

Install `pandoc` and `tectonic` using Homebrew:

```bash
brew install pandoc
brew install tectonic
```
