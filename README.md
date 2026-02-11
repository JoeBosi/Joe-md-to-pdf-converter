# Markdown to PDF Converter

A small, script-based toolchain to convert Markdown files into PDF with **LaTeX math support (KaTeX)**, professional styling, and configurable headers/footers. It uses Node.js for pre-processing and **md-to-pdf** (Puppeteer/Chromium) for rendering.

**Author:** Giuseppe Bosi

---

## Features

- **Batch conversion:** All `.md` files inside the `.md` folder are converted; PDFs are written to the `.pdf` folder.
- **LaTeX math (KaTeX):** Inline `$...$` and block `$$...$$` formulas are pre-rendered to static KaTeX HTML, so the resulting PDFs contain fully typeset equations.
- **Non-destructive pre-processing:** Source Markdown files in `.md/` are **never modified**; the pipeline works on temporary copies only.
- **Professional styling:** A4 layout, typography, tables, code blocks, and print-friendly CSS via `style.css` (including KaTeX CSS import).
- **Configurable PDF:** Page format, margins, header/footer (e.g. page numbers, author) via `pdf-options.json`.
- **Portable:** PowerShell script runs from the project root; no global install required beyond Node.js and `npx md-to-pdf`.

---

## Project Structure

```text
.
├── .md/                         # Input: Markdown files (NOT committed, private content)
├── .pdf/                        # Output: generated PDFs (NOT committed)
├── .svg/                        # Optional SVG assets referenced from Markdown (NOT committed)
├── convert-md-to-pdf.js         # Node pre-processor: LaTeX → KaTeX HTML (temp files)
├── converti_md_pdf_completo.ps1 # Main script: orchestration + md-to-pdf
├── style.css                    # PDF styling (A4, tables, code, math)
├── pdf-options.json             # Puppeteer PDF options (format, margins, header/footer)
├── package.json                 # Project metadata and KaTeX dependency
├── package-lock.json
├── README.md                    # This file
├── ARCHITECTURE.md              # Pipeline and design notes
├── GUIDA_CONVERSIONE_MD_PDF.md  # Detailed Italian/English usage guide
├── PROJECT_STATE.md             # High-level status and repository policy
└── file md - regole per gli agents.md  # Markdown rules and project-specific agent rules
```

> **Privacy & repository policy**
>
> - The `.md/`, `.pdf/`, `.svg/`, `Backup*`, `old/`, `.cursor/`, and `default.md` paths are **git-ignored**.
> - This repository only contains the **converter code and documentation**, never your personal Markdown or PDF content.

> **Standalone repository**
>
> This project is **self-contained** and not tied to any other repository. The local copy does not track a remote branch by default. You can use it offline or publish your own copy to GitHub; that copy remains independent (no dependency on or link to third-party repos). To publish or update a remote, add a remote and push when needed (e.g. `git remote add origin <your-repo-url>`, then `git push -u origin master`).

---

## Requirements

- **Node.js** (LTS recommended)
- **npm** (bundled with Node.js)
- **PowerShell** (Windows) or PowerShell Core
- Access to the public npm registry (for `npx md-to-pdf`)

`md-to-pdf` is not installed locally; it is pulled on demand via `npx --yes md-to-pdf`.

---

## Installation

1. Clone or download the repository.
2. Ensure Node.js and npm are installed:

   ```powershell
   node -v
   npm -v
   ```

3. Create the input/output folders if missing:
   - `.md` — place your Markdown files here (they stay on your machine and are not committed).
   - `.pdf` — will be created automatically; generated PDFs are moved here.

---

## Usage

1. Place your `.md` files in the `.md` folder.  
   - Write math as usual, using:
     - Inline: `$E = mc^2$`
     - Block:

       ```markdown
       $$
       x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
       $$
       ```

2. From the project root, run:

   **Windows (PowerShell):**
   ```powershell
   .\converti_md_pdf_completo.ps1
   ```

   **Linux / macOS:**
   ```bash
   chmod +x converti_md_pdf_completo.sh   # once, to make executable
   ./converti_md_pdf_completo.sh
   ```

3. For each `.md` file, the script:
   - Creates a temporary `.md` copy with formulas pre-rendered via KaTeX.
   - Calls `npx md-to-pdf` with `style.css` and `pdf-options.json`.
   - Moves the generated PDF from `.md/` to `.pdf/` (same base name).
   - Cleans up temporary files and opens the `.pdf` folder in Explorer at the end.

<<<<<<< HEAD
If the execution policy blocks the script, you can run:

=======
**Windows:** If execution policy blocks the script:
>>>>>>> a55399b70ba43c81eae56495c5670b427700075f
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\converti_md_pdf_completo.ps1
```

---

## Configuration

- **PDF layout and footer:** Edit `pdf-options.json` (format, margins, `headerTemplate`, `footerTemplate`). See the [Puppeteer PDF options](https://pptr.dev/api/puppeteer.pdfoptions) documentation.
- **Appearance:** Edit `style.css` (page size, fonts, table/code/blockquote styles). The file already imports KaTeX CSS from a CDN and defines `.math-inline`, `.math-block`, and `.katex-block` utilities.
- **Math:** Write formulas in the Markdown using `$...$` or `$$...$$`.  
  The pre-processor (`convert-md-to-pdf.js`) uses `katex.renderToString` to convert them into static HTML before `md-to-pdf` runs, so no JavaScript execution is required inside the PDF renderer.

For a more detailed, Italian-focused guide (with an English quick section), see `GUIDA_CONVERSIONE_MD_PDF.md`.

---

## License

ISC
