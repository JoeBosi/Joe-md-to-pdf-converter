# Architecture

**Author:** Giuseppe Bosi

This document describes how the Markdown-to-PDF pipeline works and how the pieces fit together.

---

## Pipeline Overview

1. **Input:** Markdown files in the `.md/` folder (one or more `*.md`).  
   These files are considered **user content** and are never committed to the repository.
2. **Pre-processing (Node.js + KaTeX):** For each input file:
   - `convert-md-to-pdf.js` reads the original Markdown.
   - Inline math `$...$` and block math `$$...$$` are converted to static KaTeX HTML using `katex.renderToString`.
   - The processed content is written to a **temporary** file `baseName.__pdf__.md` in `.md/`.
3. **Conversion (md-to-pdf + Puppeteer):** The PowerShell script invokes `npx md-to-pdf` for each temporary `.md`:
   - **md-to-pdf** uses [Marked](https://github.com/markedjs/marked) (GFM) to turn the processed Markdown (already containing KaTeX HTML) into HTML.
   - [Puppeteer](https://pptr.dev/) (headless Chromium) renders the HTML to PDF using `style.css` and `pdf-options.json`.
   - A temporary PDF `baseName.__pdf__.pdf` is created in `.md/`.
4. **Output:** The temporary PDF is moved to `.pdf/baseName.pdf`.  
   Temporary Markdown/PDF files (`*.__pdf__.md` / `*.__pdf__.pdf`) are removed at the end.

---

## Components

| Component | Role |
|----------|------|
| `converti_md_pdf_completo.ps1` | Orchestrator: discovers `.md` files, calls the KaTeX pre-processor and md-to-pdf, moves PDFs to `.pdf/`, cleans up temporary files. |
| `convert-md-to-pdf.js` | KaTeX pre-processor; converts `$` / `$$` LaTeX formulas to static KaTeX HTML (no runtime MathJax required). |
| `md-to-pdf` (npx) | Markdown → HTML (Marked) → PDF (Puppeteer). |
| `style.css` | Injected into the rendered page; defines A4 layout, typography, tables, code, math styling (including KaTeX CSS import). |
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
