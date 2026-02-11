## Project State – Markdown to PDF Converter

**Author:** Giuseppe Bosi  
**Last update:** 2026-02-11

---

### 1. Overview

- Small Node.js + PowerShell toolchain to convert Markdown files in `.md/` into PDFs in `.pdf/`.
- Uses **KaTeX** to pre-render LaTeX math (`$...$`, `$$...$$`) into static HTML before `md-to-pdf` (Marked + Puppeteer) runs.
- The repository is intentionally minimal and **does not contain any user Markdown/PDF content**.

---

### 2. Repository structure (tracked vs ignored)

- **Tracked (code & docs)**
  - `convert-md-to-pdf.js` – KaTeX pre-processor, non-destructive (works on temp files).
  - `converti_md_pdf_completo.ps1` – main orchestration script.
  - `style.css` – A4 layout, tables, code, math styling (imports KaTeX CSS from CDN).
  - `pdf-options.json` – Puppeteer PDF options (margins, header/footer templates, etc.).
  - `package.json`, `package-lock.json` – project metadata and KaTeX dependency.
  - `README.md` – English, professional overview and usage.
  - `ARCHITECTURE.md` – detailed description of the pipeline with KaTeX and temp files.
  - `GUIDA_CONVERSIONE_MD_PDF.md` – detailed Italian guide with an English quick section.
  - `file md - regole per gli agents.md` – Markdown and project-specific rules for agents.
  - `PROJECT_STATE.md` – this file.

- **Ignored (user content / environment-specific)**
  - `.md/` – input Markdown (private content, never committed).
  - `.pdf/` – output PDFs (generated).
  - `.svg/` – optional SVG assets referenced from Markdown.
  - `Backup/`, `Backup 1/`, `Backup 2/` – historical backups.
  - `old/` – older configs/scripts/styles (kept locally, not in remote).
  - `.cursor/` – Cursor IDE metadata.
  - `default.md` – local sample Markdown file.

This matches the current `.gitignore`. If any of these paths appear staged, they should be unstaged before committing.

---

### 3. Current technical state

- **Math rendering**
  - LaTeX syntax in user Markdown: `$...$` (inline) and `$$...$$` (block).
  - Pre-rendered with `katex.renderToString` in `convert-md-to-pdf.js`.
  - Output HTML uses `.math-inline`, `.math-block`, `.katex-block` and is styled by `style.css` (KaTeX CSS is imported via CDN).

- **Pre-processing behaviour**
  - Original `.md` files are **never modified**.
  - For each input `name.md` in `.md/`:
    - Temp markdown: `.md/name.__pdf__.md` (KaTeX HTML).
    - `npx md-to-pdf` runs on the temp file.
    - Temp PDF: `.md/name.__pdf__.pdf` → moved to `.pdf/name.pdf`.
    - Temp files are deleted at the end of the run.

- **Scripts**
  - `converti_md_pdf_completo.ps1`:
    - Validates required files.
    - Processes all `*.md` in `.md/` (excluding `cursor.md` and any `*.__pdf__.md`).
    - Opens `.pdf` in Explorer at the end for quick access.

---

### 4. Open work / TODO

- Currently no open technical TODOs in this repository.
- Any future changes should:
  - Keep the **non-destructive** behaviour of the pre-processor.
  - Preserve the privacy model (no user `.md` / `.pdf` / `.svg` in git).
  - Keep README/ARCHITECTURE/PROJECT_STATE/GUIDA in sync with any pipeline changes.

---

### 5. Repository policy (standalone)

- The project is **autonomous**: the local branch does not track any remote (no `origin/master` tracking). You can work offline; to publish or update a remote, add the remote and push when needed.
- The codebase is self-contained and not tied to any third-party repository; a copy on GitHub remains independent.

### 6. Status summary

- KaTeX-based math rendering, non-destructive pipeline (temp files), documentation and ignore rules are in place.

