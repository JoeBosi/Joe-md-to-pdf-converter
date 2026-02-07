// Simple markdown pre-processor for math formulas
// Converts $...$ to HTML spans for MathJax
// Author: Giuseppe Bosi

const fs = require('fs');
const path = require('path');

function processMathFormulas(mdContent) {
  // First, process block math ($$...$$) to avoid conflicts
  let processed = mdContent.replace(/\$\$([\s\S]*?)\$\$/g, (match, formula) => {
    return `\n\n<div class="math-block">\\[${formula.trim()}\\]</div>\n\n`;
  });
  
  // Then process inline math ($...$) - split by lines for better handling
  const lines = processed.split('\n');
  const processedLines = lines.map(line => {
    // Skip lines that are already block math divs
    if (line.includes('math-block')) {
      return line;
    }
    // Process inline math: $...$ (not $$...$$)
    return line.replace(/\$([^$\n]+?)\$/g, (match, formula) => {
      // Safety check
      if (match.startsWith('$$') || match.endsWith('$$')) {
        return match;
      }
      return `<span class="math-inline">\\(${formula.trim()}\\)</span>`;
    });
  });
  
  return processedLines.join('\n');
}

// Main execution
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.length < 1) {
    console.error('Usage: node convert-md-to-pdf.js <mdFile>');
    process.exit(1);
  }
  
  const mdFile = args[0];
  
  try {
    // Read markdown file
    const mdContent = fs.readFileSync(mdFile, 'utf8');
    
    // Process math formulas
    const processedMd = processMathFormulas(mdContent);
    
    // Write processed content back (overwrite original)
    fs.writeFileSync(mdFile, processedMd, 'utf8');
    
    console.log(`✓ Processed math formulas in: ${path.basename(mdFile)}`);
  } catch (error) {
    console.error(`✗ Error processing ${mdFile}:`, error.message);
    process.exit(1);
  }
}

module.exports = { processMathFormulas };
