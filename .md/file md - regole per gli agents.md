# Markdown Rules for Agents

**Purpose:** Rules agents MUST follow when creating or editing `.md` files. Ensures correct rendering (GitHub, PDF export, CommonMark/GFM viewers).

**References:** [GitHub Flavored Markdown Spec (GFM)](https://github.github.com/gfm/), [Markdown Guide](https://www.markdownguide.org/) (basic + extended syntax).

---

## 1. Math / LaTeX

- **Inline:** `<span class="math-inline">\(...\)</span>` (single dollar). Example: `The value is <span class="math-inline">\(x^2 + y^2 = z^2\)</span>.`
- **Block:** `

<div class="math-block">\[...\]</div>

` on separate lines. No spaces inside delimiters: use `<span class="math-inline">\(x\)</span>` not `<span class="math-inline">\(x\)</span>`.
- Escape literal `<span class="math-inline">\(` when not math: `\\)</span>` or backticks.

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

- Header row, then delimiter row: at least three hyphens per column, pipes `|` between columns. Leading/trailing pipe recommended.
- **Alignment:** `:---` left, `:---:` center, `---:` right.
- **Pipe in cell:** Escape: `\|` so it is not interpreted as column separator.
- Table ends at first blank line or another block. Header and delimiter must have the same number of columns; body rows can have fewer (empty cells) or more (excess ignored).

```markdown
| A    | B    |
| ---- | ---- |
| a    | b    |
```

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

*Author: Giuseppe Bosi. For agents: apply these rules when creating or editing any `.md` file in this project.*
