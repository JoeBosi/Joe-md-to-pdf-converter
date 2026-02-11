# Markdown Rules for Agents

> **Scope – this repository**
>
> - This project is a **Markdown → PDF converter**, not a content repository.
> - User content lives in `.md/`, `.pdf/`, `.svg/`, `Backup*`, `old/`, `.cursor/` and must **never** be committed.
> - Only the converter code and documentation (`README.md`, `ARCHITECTURE.md`, `GUIDA_CONVERSIONE_MD_PDF.md`, this file, `PROJECT_STATE.md`, etc.) belong in git.
> - All public docs and comments must be in **English**; interaction with the user remains in Italian.

**Purpose:** Rules agents MUST follow when creating or editing Markdown files in this project. Ensures correct rendering (GitHub, PDF export, CommonMark/GFM viewers) and preserves user privacy.

**References:** [GitHub Flavored Markdown Spec (GFM)](https://github.github.com/gfm/), [Markdown Guide](https://www.markdownguide.org/) (basic + extended syntax).

---

## 0. Repository-specific rules (privacy & structure)

- **Never commit user content**
  - Do **not** track or commit anything under:
    - `.md/`
    - `.pdf/`
    - `.svg/`
    - `Backup/`, `Backup 1/`, `Backup 2/`
    - `old/`
    - `.cursor/`
    - `default.md`
  - These paths are already in `.gitignore`; if you ever see them staged, unstage them before committing.

- **Files that are allowed in git**
  - Converter code: `convert-md-to-pdf.js`, `converti_md_pdf_completo.ps1`, `style.css`, `pdf-options.json`, `package*.json`, `.gitignore`.
  - Documentation: `README.md`, `ARCHITECTURE.md`, `GUIDA_CONVERSIONE_MD_PDF.md`, `PROJECT_STATE.md`, `file md - regole per gli agents.md`.
  - Nothing else unless explicitly requested by the user.

- **Do not modify user `.md` files**
  - The pipeline already guarantees that **pre-processing is non-destructive** (works on temporary copies).
  - Agents must not rewrite files under `.md/` to “help” the user; only update documentation and code.

- **Math syntax in this repo**
  - Users write formulas in the `.md` files with:
    - Inline: `$E = mc^2$`
    - Block:

      ```markdown
      $$
      x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
      $$
      ```

  - The Node pre-processor (`convert-md-to-pdf.js`) converts these to **KaTeX HTML** using `katex.renderToString`.
  - Docs must describe *this* behaviour (KaTeX pre-render), not old MathJax-based behaviour.

---

## 1. Math / LaTeX

- **Inline (for docs/examples):**
  - Use standard Markdown math where possible: `` `$E = mc^2$` `` in examples.
  - When you need raw HTML (e.g. inside already-processed temp files), the pre-processor outputs:
    - `<span class="math-inline katex-inline">…KaTeX HTML…</span>`
- **Block (for docs/examples):**
  - Prefer Markdown fences with `$$ … $$` as shown above.
  - The pre-processor wraps blocks into:

    ```html
    <div class="math-block katex-block">…KaTeX HTML…</div>
    ```

- Avoid documenting the old pattern `<span class="math-inline">\(...\)</span>` / `<div class="math-block">\[...\]</div>` as the *input* syntax; it is now an internal detail of the legacy implementation only.

---

## 2. Headings (GFM / CommonMark)

- **ATX (preferred):** `#` … `######` with a **space** after the `#`. Example: `## Section`.
- One H1 (`#`) for document title; do not skip levels (e.g. no `##` then `####`).
- **Setext (optional):** Underline with `===` (H1) or `---` (H2). Less universal; prefer ATX for compatibility.
- Blank line before and after headings for compatibility ([Markdown Guide](https://www.markdownguide.org/basic-syntax/#heading-best-practices)).

---

## 3. Paragraphs and Line Breaks

- One blank line between paragraphs.
- **Hard line break:** Two trailing spaces at end of line, or `<br>` where HTML is allowed. GFM/CommonMark also allow backslash `\` at end of line (less universal).
- Do not use multiple consecutive blank lines; one is enough.
- Do not indent paragraphs with spaces/tabs unless inside a list item.

---

## 4. Emphasis (Bold / Italic)

- **Bold:** `**text**` or `__text__`. **Italic:** `*text*` or `_text_`.
- For **intraword** emphasis (e.g. `Love**is**bold`), use **asterisks only**; underscores can be interpreted as literal in some processors ([Markdown Guide](https://www.markdownguide.org/basic-syntax/#bold-best-practices)).
- Do not use emphasis syntax for code; use backticks.

---

## 5. Blockquotes

- Prefix with `>` and a space. Use `>` on blank lines between paragraphs inside the quote.
- Nested: `>>` for inner quote. Blank line before and after blockquotes for compatibility.

---

## 6. Lists (GFM)

- **Unordered:** `-`, `*`, or `+` + space. Use **one** delimiter per list; do not mix ([Markdown Guide](https://www.markdownguide.org/basic-syntax/#unordered-list-best-practices)).
- **Ordered:** `1.` + space (number can repeat; list should start with 1). For compatibility use **period** not parenthesis (`1.` not `1)`).
- Indent nested items consistently (e.g. 2 or 4 spaces). Continuation paragraphs and sub-blocks: indent at least 4 spaces (or 1 tab) under the list marker.
- To start an unordered item with a number and period, escape: `\- 1968\. A great year!`

---

## 7. Task Lists (GFM Extension)

- `- [ ]` unchecked, `- [x]` or `- [X]` checked. Space inside brackets is required for unchecked.
- Can be nested like normal lists.

```markdown
- [x] Done
- [ ] Todo
```

---

## 8. Code

- **Inline:** Single backticks `` `code` ``. For a literal backtick inside, use double backticks: ``` `` `code` `` ```.
- **Fenced blocks:** Three or more backticks or tildes (`~~~`). Optional **info string** (language) after opening fence: ` ```js `.
- Closing fence: same character (backtick or tilde), at least as many as opening. No spaces inside the fence markers.
- Backslash escapes do **not** work inside code spans or code blocks.

---

## 9. Links

- **Inline:** `[text](url)` or `[text](url "title")`. Title in double quotes, single quotes, or parentheses. No space between `]` and `(`.
- **Reference:** `[text][ref]` and elsewhere `[ref]: url "title"`. **GFM:** no space between link text and label: `[foo][bar]` not `[foo] [bar]`.
- **Autolinks (GFM):** `<https://example.com>` and `<email@example.com>` are linked automatically.
- URLs with spaces: use `%20` or `<url>`; parentheses in URLs may need encoding (`%28`, `%29`) or angle-bracket form for compatibility.

### Verification of external links (agents)

When creating or editing an `.md` file that contains links to **external resources** (URLs or relative paths to other files), agents MUST:

1. **Verify the link is correct:** The URL or path must be valid (correct syntax, no typos, correct relative path from the `.md` file).
2. **Verify the target exists:**
   - **Local files** (e.g. `./doc.pdf`, `../img/logo.png`): resolve the path relative to the `.md` file and check that the file exists on disk.
   - **HTTP/HTTPS URLs:** Check that the resource is reachable (e.g. HEAD/GET returns success or 200); if the tool cannot perform network requests, report the link for manual verification.

Do not leave broken links: either fix the path/URL, remove the link, or report the issue so it can be corrected.

---

## 10. Images

- **Syntax:** `![alt text](path-or-url)` or `![alt](url "title")`.
- Always provide meaningful **alt text** for accessibility. Rendered alt is the plain string content of the description (no formatting).
- Prefer relative paths (e.g. `./img/diagram.png`). Forward slashes; no spaces in file names when possible.
- **Linking an image:** `[![alt](image-url)](link-url)`.

---

## 11. SVG

- **As file:** `![Diagram](path.svg)` or `<img src="path.svg" alt="Diagram" width="400" />`.
- Prefer file reference over large inline SVG in `.md` unless the pipeline explicitly supports inline SVG.

---

## 12. Tables (GFM Extension)

- **Structure:** Header row → delimiter row → body rows. Use leading and trailing `|` for consistency.
- **Delimiter row (required):** Must be the line **immediately after** the header row. Use at least three hyphens per column, e.g. `| --- | --- | --- |` or `|---|----|----|`. Same number of columns as the header.
- **Alignment:** `:---` left, `:---:` center, `---:` right in the delimiter row.
- **No blank lines inside the table:** In GFM, the first blank line **ends** the table. There must be **no empty lines** between header, delimiter, or body rows. If you insert a blank line between two data rows, the table is broken and the following lines will not render as table cells.
- **Pipe in cell:** Escape as `\|` so it is not interpreted as a column separator.
- Header and delimiter must have the same number of columns; body rows can have fewer (empty cells) or more (excess ignored).

**Correct:**

```markdown
| A    | B    |
| ---- | ---- |
| a    | b    |
| c    | d    |
```

**Wrong (do not do this):**

```markdown
| **Sede** | **IP** |
|-|-|
| Centrale | 10.0.0.0 |

| Filiale | 10.0.16.0 |
```
↑ Blank line between rows breaks the table; "Filiale" row will not be part of the table.

**Wrong (missing delimiter row):**

```markdown
| **Sede** | **IP** |

| Centrale | 10.0.0.0 |
```
↑ Delimiter row must come immediately after the header; a blank line here breaks the table.

---

## 13. Thematic Break (Horizontal Rule)

- Three or more `*`, `-`, or `_` on a line (optional spaces between). Same character for the whole line. Blank line before and after for compatibility (avoids confusion with setext H2).

---

## 14. Strikethrough (GFM Extension)

- `~~text~~` renders as strikethrough. Do not use three or more tildes for this (they stay literal).

---

## 15. Escaping (Backslash)

- Escape: `\` then one of: `\` `` ` `` `*` `_` `{` `}` `[` `]` `(` `)` `#` `+` `-` `.` `!` `|`.
- Escaped characters are literal; backslash before other characters is a literal backslash. Backslash at end of line = hard line break (where supported).
- Escapes do **not** apply inside code spans, code blocks, or autolinks.

---

## 16. Raw HTML

- Block-level HTML is allowed in most processors. For block elements (`<div>`, `<table>`, etc.), use blank lines before and after; avoid indenting with spaces/tabs where it could change interpretation.
- **GFM tagfilter:** These tags are escaped (leading `<` → `&lt;`): `<title>`, `<textarea>`, `<style>`, `<xmp>`, `<iframe>`, `<noembed>`, `<noframes>`, `<script>`, `<plaintext>`.

---

## 17. File and Path Conventions

- UTF-8 for `.md` files. Forward slashes in paths. No spaces in asset names when possible; use `-` or `_`.

---

## 18. PDF and Toolchain Compatibility

- For MD→PDF (e.g. Pandoc, md-to-pdf): prefer standard Markdown and GFM; avoid heavy raw HTML/CSS unless the pipeline supports it. Math may require specific extensions (e.g. Pandoc with `--mathjax` or similar).

---

## Quick Reference: Characters to Escape

| Character | Escape |
| --------- | ------ |
| `\`       | `\\`   |
| `` ` ``   | `` \` `` |
| `*` `_`   | `\*` `\_` |
| `#` `[` `]` `(` `)` | `\#` `\[` `\]` `\(` `\)` |
| In tables: `\|` for literal pipe | |

---

*Author: Giuseppe Bosi. For agents: apply these rules when creating or editing any Markdown file, and respect the repository-specific constraints described in section 0.*
