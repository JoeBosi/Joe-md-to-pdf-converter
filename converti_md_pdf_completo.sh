#!/usr/bin/env bash
# ============================================
# Bash script: MD to PDF conversion (Linux/macOS)
# Reads .md files from folder ".md", writes PDFs to folder ".pdf"
# Portable: works from any location (script directory = project root).
# Author: Giuseppe Bosi
# ============================================

set -e

echo -e "\033[36mConversione in corso...\033[0m"
echo ""

# Root = script directory (portable)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR"
MD_DIR="$ROOT_DIR/.md"
PDF_DIR="$ROOT_DIR/.pdf"
STYLE_PATH="$ROOT_DIR/style.css"
PDF_OPTIONS_PATH="$ROOT_DIR/pdf-options.json"
CONVERTER_SCRIPT="$ROOT_DIR/convert-md-to-pdf.js"

# Ensure .pdf folder exists
if [[ ! -d "$PDF_DIR" ]]; then
    mkdir -p "$PDF_DIR"
    echo -e "\033[90mCreata cartella: $PDF_DIR\033[0m"
fi

# Check required files
if [[ ! -f "$STYLE_PATH" ]]; then
    echo -e "\033[31mERRORE: style.css non trovato in $STYLE_PATH\033[0m"
    exit 1
fi
if [[ ! -f "$PDF_OPTIONS_PATH" ]]; then
    echo -e "\033[31mERRORE: pdf-options.json non trovato in $PDF_OPTIONS_PATH\033[0m"
    exit 1
fi
if [[ ! -f "$CONVERTER_SCRIPT" ]]; then
    echo -e "\033[31mERRORE: convert-md-to-pdf.js non trovato in $CONVERTER_SCRIPT\033[0m"
    exit 1
fi

# Check .md folder exists and has files
if [[ ! -d "$MD_DIR" ]]; then
    echo -e "\033[31mERRORE: Cartella .md non trovata: $MD_DIR\033[0m"
    echo -e "\033[33mCrea la cartella '.md' e inserisci i file Markdown.\033[0m"
    exit 1
fi

# Find .md files (excluding cursor.md)
shopt -s nullglob
MD_FILES=("$MD_DIR"/*.md)
shopt -u nullglob

# Filter out cursor.md
MD_FILES_FILTERED=()
for f in "${MD_FILES[@]}"; do
    [[ "$(basename "$f")" == "cursor.md" ]] && continue
    MD_FILES_FILTERED+=("$f")
done

if [[ ${#MD_FILES_FILTERED[@]} -eq 0 ]]; then
    echo -e "\033[33mNessun file .md trovato nella cartella .md\033[0m"
    echo -e "\033[36mConversione completata (nessun file da convertire).\033[0m"
    exit 0
fi

echo -e "\033[90mRoot:   $ROOT_DIR\033[0m"
echo -e "\033[90mInput:  $MD_DIR\033[0m"
echo -e "\033[90mOutput: $PDF_DIR\033[0m"
echo ""

cd "$ROOT_DIR"

for md_full in "${MD_FILES_FILTERED[@]}"; do
    md_name="$(basename "$md_full")"
    base_name="${md_name%.md}"
    md_rel=".md/$md_name"

    echo -e "\033[33mConvertendo $md_name ...\033[0m"

    # Pre-process math formulas (in place)
    echo -e "  \033[90mPre-processing formule matematiche...\033[0m"
    if ! node "$CONVERTER_SCRIPT" "$md_full"; then
        echo -e "  \033[31mERRORE nel pre-processing\033[0m"
        continue
    fi

    # Generate PDF (md-to-pdf writes in same dir as .md by default)
    echo -e "  \033[90mGenerando PDF...\033[0m"
    if npx --yes md-to-pdf "$md_rel" --stylesheet "style.css" --pdf-options "pdf-options.json"; then
        pdf_from="$MD_DIR/$base_name.pdf"
        pdf_to="$PDF_DIR/$base_name.pdf"
        if [[ -f "$pdf_from" ]]; then
            mv -f "$pdf_from" "$pdf_to"
            echo -e "\033[32mOK: $base_name.pdf -> .pdf/\033[0m"
        else
            echo -e "\033[31mERRORE: PDF non generato per $md_name\033[0m"
        fi
    else
        echo -e "\033[31mERRORE: md-to-pdf fallito per $md_name\033[0m"
    fi
    echo ""
done

echo -e "\033[36mConversione completata!\033[0m"
