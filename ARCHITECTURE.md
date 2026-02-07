# Architecture

**Author:** Giuseppe Bosi

This document describes how the Markdown-to-PDF pipeline works and how the pieces fit together.

---

## Pipeline Overview

1. **Input:** Markdown files in the `.md/` folder (one or more `*.md`).
2. **Pre-processing (Node.js):** `convert-md-to-pdf.js` runs on each file:
   - Replaces block math `$$...$$` with `<div class="math-block">\[...\]</div>`.
   - Replaces inline math `$...$` with `<span class="math-inline">\(...\)</span>`.
   - Writes the result back into the same `.md` file (in place).
3. **Conversion:** PowerShell script invokes `npx md-to-pdf` for each pre-processed file:
   - **md-to-pdf** uses [Marked](https://github.com/markedjs/marked) (GFM) to turn Markdown into HTML.
   - [Puppeteer](https://pptr.dev/) (headless Chromium) renders the HTML to PDF using `style.css` and `pdf-options.json`.
4. **Output:** PDFs are produced next to the source in `.md/`, then moved to `.pdf/` with the same base name.

---

## Components

| Component | Role |
|----------|------|
| `converti_md_pdf_completo.ps1` | Orchestrator: discovers `.md` files, calls pre-processor and md-to-pdf, moves PDFs to `.pdf/`. |
| `convert-md-to-pdf.js` | Math pre-processor; rewrites `$`/`$$` so that downstream HTML can use MathJax. |
| `md-to-pdf` (npx) | Markdown → HTML (Marked) → PDF (Puppeteer). |
| `style.css` | Injected into the rendered page; defines A4, typography, tables, code, blockquotes. |
| `pdf-options.json` | Passed to Puppeteer’s `page.pdf()` (format, margins, header/footer). |

---

## Folder Conventions

- **`.md/`** — Only input Markdown. The script ignores `cursor.md`. User content; not committed in the repo.
- **`.pdf/`** — Only output PDFs. Created if missing; not committed.
- **`.svg/`** — Optional assets (e.g. images referenced from `.md`). Not required for the converter; not committed.

---

## Dependencies

- **Runtime:** Node.js (for `convert-md-to-pdf.js` and `npx`).
- **CLI:** `md-to-pdf` is pulled on demand via `npx --yes md-to-pdf`; no local `package.json` dependency needed for the script to run, but `package.json` documents the project and can be used to add scripts or tooling later.
