# ============================================
# Script PowerShell per conversione MD to PDF
# Con supporto completo per CSS, PDF Options e MathJax
# Author: Giuseppe Bosi
# ============================================

Write-Host "Conversione in corso..." -ForegroundColor Cyan
Write-Host ""

# Imposta il percorso corrente
$currentDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$stylePath = Join-Path $currentDir "style.css"
$pdfOptionsPath = Join-Path $currentDir "pdf-options.json"
$converterScript = Join-Path $currentDir "convert-md-to-pdf.js"

# Verifica esistenza file necessari
if (-not (Test-Path $stylePath)) {
    Write-Host "ERRORE: File style.css non trovato in $stylePath" -ForegroundColor Red
    Read-Host "Premi Enter per uscire"
    exit 1
}

if (-not (Test-Path $pdfOptionsPath)) {
    Write-Host "ERRORE: File pdf-options.json non trovato in $pdfOptionsPath" -ForegroundColor Red
    Read-Host "Premi Enter per uscire"
    exit 1
}

if (-not (Test-Path $converterScript)) {
    Write-Host "ERRORE: File convert-md-to-pdf.js non trovato in $converterScript" -ForegroundColor Red
    Read-Host "Premi Enter per uscire"
    exit 1
}

Write-Host "Percorso cartella: $currentDir" -ForegroundColor Gray
Write-Host "CSS: $stylePath" -ForegroundColor Gray
Write-Host "PDF Options: $pdfOptionsPath" -ForegroundColor Gray
Write-Host "Converter Script: $converterScript" -ForegroundColor Gray
Write-Host ""

# Processa tutti i file .md (escludi cursor.md)
Get-ChildItem -Path $currentDir -Filter "*.md" | Where-Object { $_.Name -ne "cursor.md" } | ForEach-Object {
    Write-Host "Convertendo $($_.Name) ..." -ForegroundColor Yellow
    
    Push-Location $currentDir
    
    $mdFile = $_.FullName
    $cssFile = $stylePath
    $pdfOptionsFile = $pdfOptionsPath
    
    # Pre-processa le formule matematiche
    Write-Host "  Pre-processing formule matematiche..." -ForegroundColor Gray
    & node $converterScript $mdFile
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ERRORE nel pre-processing" -ForegroundColor Red
        Pop-Location
        continue
    }
    
    # Leggi e comprimi il JSON (rimuovi BOM se presente)
    $jsonObj = Get-Content $pdfOptionsFile -Raw -Encoding UTF8 | ConvertFrom-Json
    $jsonContent = $jsonObj | ConvertTo-Json -Compress -Depth 10
    
    # Crea file batch temporaneo per eseguire il comando
    $batchFile = Join-Path $env:TEMP "md-to-pdf-$(Get-Random).bat"
    $relativeMd = $_.Name
    $relativeCss = "style.css"
    
    # Escape JSON per batch: raddoppia le virgolette doppie
    $jsonForBatch = $jsonContent -replace '"', '""'
    
    # Crea contenuto batch
    $batchContent = @"
@echo off
cd /d "$currentDir"
npx --yes md-to-pdf "$relativeMd" --stylesheet "$relativeCss" --pdf-options "$jsonForBatch"
"@
    
    $batchContent | Out-File -FilePath $batchFile -Encoding ASCII -Force
    
    Write-Host "  Generando PDF..." -ForegroundColor Gray
    
    try {
        # Esegui il file batch
        & $batchFile
    } finally {
        # Rimuovi file batch temporaneo
        if (Test-Path $batchFile) {
            Remove-Item $batchFile -Force -ErrorAction SilentlyContinue
        }
    }
    
    Pop-Location
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "OK: $($_.Name) convertito in $($_.BaseName).pdf" -ForegroundColor Green
    } else {
        Write-Host "ERRORE durante la conversione di $($_.Name)" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "Conversione completata!" -ForegroundColor Cyan
