# ============================================
# PowerShell script: MD to PDF conversion
# Reads .md files from folder ".md", writes PDFs to folder ".pdf"
# Portable: works from any location of the project root (script directory).
# Author: Giuseppe Bosi
# ============================================

Write-Host "Conversione in corso..." -ForegroundColor Cyan
Write-Host ""

# Root = script directory (portable)
$rootDir = $PSScriptRoot
if (-not $rootDir) { $rootDir = Split-Path -Parent $MyInvocation.MyCommand.Path }
$mdDir   = Join-Path $rootDir ".md"
$pdfDir  = Join-Path $rootDir ".pdf"
$stylePath = Join-Path $rootDir "style.css"
$pdfOptionsPath = Join-Path $rootDir "pdf-options.json"
$converterScript = Join-Path $rootDir "convert-md-to-pdf.js"

# Ensure .pdf folder exists
if (-not (Test-Path $pdfDir)) {
    New-Item -ItemType Directory -Path $pdfDir -Force | Out-Null
    Write-Host "Creata cartella: $pdfDir" -ForegroundColor Gray
}

# Check required files
if (-not (Test-Path $stylePath)) {
    Write-Host "ERRORE: style.css non trovato in $stylePath" -ForegroundColor Red
    Read-Host "Premi Enter per uscire"
    exit 1
}
if (-not (Test-Path $pdfOptionsPath)) {
    Write-Host "ERRORE: pdf-options.json non trovato in $pdfOptionsPath" -ForegroundColor Red
    Read-Host "Premi Enter per uscire"
    exit 1
}
if (-not (Test-Path $converterScript)) {
    Write-Host "ERRORE: convert-md-to-pdf.js non trovato in $converterScript" -ForegroundColor Red
    Read-Host "Premi Enter per uscire"
    exit 1
}

# Check .md folder exists and has files
if (-not (Test-Path $mdDir)) {
    Write-Host "ERRORE: Cartella .md non trovata: $mdDir" -ForegroundColor Red
    Write-Host "Crea la cartella '.md' e inserisci i file Markdown." -ForegroundColor Yellow
    Read-Host "Premi Enter per uscire"
    exit 1
}

$mdFiles = Get-ChildItem -Path $mdDir -Filter "*.md" | Where-Object {
    $_.Name -ne "cursor.md" -and $_.Name -notlike "*.__pdf__.md"
}
if ($mdFiles.Count -eq 0) {
    Write-Host "Nessun file .md trovato nella cartella .md" -ForegroundColor Yellow
    Write-Host "Conversione completata (nessun file da convertire)." -ForegroundColor Cyan
    exit 0
}

Write-Host "Root:   $rootDir" -ForegroundColor Gray
Write-Host "Input:  $mdDir" -ForegroundColor Gray
Write-Host "Output: $pdfDir" -ForegroundColor Gray
Write-Host ""

# Relative paths from root (for npx from rootDir)
$mdDirRel = ".md"

Push-Location $rootDir
try {
    foreach ($mdItem in $mdFiles) {
        $mdName = $mdItem.Name
        $baseName = $mdItem.BaseName
        $mdFullPath = $mdItem.FullName

        Write-Host "Convertendo $mdName ..." -ForegroundColor Yellow

        # Pre-process math formulas into a temporary markdown file
        $tempMdName = "$baseName.__pdf__.md"
        $tempMdFullPath = Join-Path $mdDir $tempMdName
        $tempMdRelPath = Join-Path $mdDirRel $tempMdName
        $tempPdfName = "$baseName.__pdf__.pdf"
        $tempPdfFullPath = Join-Path $mdDir $tempPdfName

        Write-Host "  Pre-processing formule matematiche (file temporaneo)..." -ForegroundColor Gray
        & node $converterScript $mdFullPath $tempMdFullPath
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  ERRORE nel pre-processing" -ForegroundColor Red
            continue
        }

        # Build PDF in same dir as MD (.md), then move to .pdf
        # Read JSON content and pass as string (md-to-pdf expects JSON string, not file path)
        # Use cmd.exe to preserve Unicode characters in file paths
        # Use relative path for portability (we're already in $rootDir)
        $jsonContent = Get-Content "pdf-options.json" -Raw -Encoding UTF8
        # Minify JSON and escape for cmd.exe
        $jsonObj = $jsonContent | ConvertFrom-Json
        $jsonMinified = $jsonObj | ConvertTo-Json -Compress -Depth 10
        # Escape quotes for cmd.exe: " becomes \"
        $jsonEscaped = $jsonMinified -replace '"', '\"'

        Write-Host "  Generando PDF..." -ForegroundColor Gray
        try {
            # Use cmd.exe to execute npx to preserve Unicode characters in file paths
            # Pass JSON as string with proper escaping for cmd.exe
            $npxCmd = "npx --yes md-to-pdf `"$tempMdRelPath`" --stylesheet `"style.css`" --pdf-options `"$jsonEscaped`""
            & cmd.exe /c "chcp 65001 >nul && $npxCmd" | Out-Null
            $npxExitCode = $LASTEXITCODE
            
            if ($npxExitCode -ne 0) {
                Write-Host "  ERRORE nella generazione PDF" -ForegroundColor Red
            }
        } catch {
            Write-Host "  ERRORE nella generazione PDF: $_" -ForegroundColor Red
        }

        # md-to-pdf creates the PDF next to the input markdown, with the same base name
        $pdfFromPath = $tempPdfFullPath
        $pdfToPath   = Join-Path $pdfDir "$baseName.pdf"
        if (Test-Path $pdfFromPath) {
            Move-Item -Path $pdfFromPath -Destination $pdfToPath -Force
            Write-Host "OK: $baseName.pdf -> .pdf\" -ForegroundColor Green
        } else {
            Write-Host "ERRORE: PDF non generato per $mdName" -ForegroundColor Red
        }

        # Clean up temporary markdown file
        if (Test-Path $tempMdFullPath) {
            Remove-Item $tempMdFullPath -Force -ErrorAction SilentlyContinue
        }
        Write-Host ""
    }
} finally {
    Pop-Location
}

Write-Host "Conversione completata!" -ForegroundColor Cyan

# Open the output folder in Explorer for quick access to generated PDFs
if (Test-Path $pdfDir) {
    Write-Host "Apro la cartella PDF: $pdfDir" -ForegroundColor Gray
    Start-Process explorer.exe $pdfDir
}
