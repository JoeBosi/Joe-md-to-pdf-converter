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

$mdFiles = Get-ChildItem -Path $mdDir -Filter "*.md" | Where-Object { $_.Name -ne "cursor.md" }
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
$pdfDirRel = ".pdf"

Push-Location $rootDir
try {
    foreach ($mdItem in $mdFiles) {
        $mdName = $mdItem.Name
        $baseName = $mdItem.BaseName
        $mdFullPath = $mdItem.FullName
        $mdRelPath = Join-Path $mdDirRel $mdName

        Write-Host "Convertendo $mdName ..." -ForegroundColor Yellow

        # Pre-process math formulas (in place)
        Write-Host "  Pre-processing formule matematiche..." -ForegroundColor Gray
        & node $converterScript $mdFullPath
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  ERRORE nel pre-processing" -ForegroundColor Red
            continue
        }

        # Build PDF in same dir as MD (.md), then move to .pdf
        $jsonObj = Get-Content $pdfOptionsPath -Raw -Encoding UTF8 | ConvertFrom-Json
        $jsonContent = $jsonObj | ConvertTo-Json -Compress -Depth 10
        $jsonForBatch = $jsonContent -replace '"', '""'

        $batchFile = Join-Path $env:TEMP "md-to-pdf-$(Get-Random).bat"
        $batchContent = @"
@echo off
cd /d "$rootDir"
npx --yes md-to-pdf "$mdRelPath" --stylesheet "style.css" --pdf-options "$jsonForBatch"
"@
        $batchContent | Out-File -FilePath $batchFile -Encoding ASCII -Force

        Write-Host "  Generando PDF..." -ForegroundColor Gray
        try {
            & $batchFile
        } finally {
            if (Test-Path $batchFile) { Remove-Item $batchFile -Force -ErrorAction SilentlyContinue }
        }

        $pdfFromPath = Join-Path $mdDir "$baseName.pdf"
        $pdfToPath   = Join-Path $pdfDir "$baseName.pdf"
        if (Test-Path $pdfFromPath) {
            Move-Item -Path $pdfFromPath -Destination $pdfToPath -Force
            Write-Host "OK: $baseName.pdf -> .pdf\" -ForegroundColor Green
        } else {
            Write-Host "ERRORE: PDF non generato per $mdName" -ForegroundColor Red
        }
        Write-Host ""
    }
} finally {
    Pop-Location
}

Write-Host "Conversione completata!" -ForegroundColor Cyan
