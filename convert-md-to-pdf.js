// Simple markdown pre-processor for math formulas
// Pre-renders LaTeX with KaTeX so that $...$, $$...$$, \(...\), \[...\] become static HTML
// Author: Giuseppe Bosi

const fs = require('fs');
const path = require('path');
// Use KaTeX CommonJS build directly to have renderToString available
const katex = require('katex/dist/katex.js');

const KATEX_MARKER = 'katex.min.js';

/**
 * For now this is a no-op: we keep it to preserve structure
 * and potential future header injections, but we do not inject
 * <script> tags because md-to-pdf strips them.
 */
function injectKatexHeader(mdContent) {
  return mdContent;
}

function renderWithKatex(formula, displayMode) {
  try {
    return katex.renderToString(formula, {
      displayMode,
      throwOnError: false,
      strict: 'warn',
    });
  } catch (error) {
    // If rendering fails, keep the original formula to avoid losing content.
    return formula;
  }
}

function processMathFormulas(mdContent) {
  // Keep hook for potential future header usage.
  let processed = injectKatexHeader(mdContent);

  // 1) Block math: $$ ... $$  → display-mode KaTeX HTML
  processed = processed.replace(/\$\$([\s\S]*?)\$\$/g, (match, formula) => {
    const html = renderWithKatex(formula.trim(), true);
    return `\n\n<div class="math-block katex-block">${html}</div>\n\n`;
  });

  // 2) Inline math: $ ... $  → inline KaTeX HTML
  const lines = processed.split('\n');
  const processedLines = lines.map((line) => {
    // Skip if line already contains a rendered KaTeX block
    if (line.includes('katex-block') || line.includes('katex-inline')) {
      return line;
    }

    return line.replace(/\$([^$\n]+?)\$/g, (match, formula) => {
      const html = renderWithKatex(formula.trim(), false);
      return `<span class="math-inline katex-inline">${html}</span>`;
    });
  });

  const finalContent = processedLines.join('\n');
  return finalContent;
}

// Main execution
if (require.main === module) {
  const args = process.argv.slice(2);

  if (args.length < 1) {
    console.error('Usage: node convert-md-to-pdf.js <inputMdFile> [outputMdFile]');
    process.exit(1);
  }

  const inputFile = args[0];
  const outputFile = args[1] || inputFile;

  try {
    // Read markdown file (original, never modified in-place if outputFile differs)
    const mdContent = fs.readFileSync(inputFile, 'utf8');

    // Process math formulas (KaTeX pre-render)
    const processedMd = processMathFormulas(mdContent);

    // Write processed content to the selected output file
    fs.writeFileSync(outputFile, processedMd, 'utf8');

    console.log(
      `✓ Processed math formulas: ${path.basename(inputFile)} -> ${path.basename(outputFile)}`
    );
  } catch (error) {
    console.error(`✗ Error processing ${inputFile}:`, error.message);
    process.exit(1);
  }
}

module.exports = { processMathFormulas };
