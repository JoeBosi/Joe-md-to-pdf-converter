# Guida alla Conversione Markdown → PDF

**Author:** Giuseppe Bosi

Questa guida spiega come utilizzare lo script PowerShell `converti_md_pdf_completo.ps1` per convertire file Markdown in PDF professionali, e come personalizzare l'output modificando i file CSS e JSON.

---

## 📋 Indice

1. [Panoramica](#panoramica)
2. [Utilizzo dello Script PowerShell](#utilizzo-dello-script-powershell)
3. [Personalizzazione CSS](#personalizzazione-css)
4. [Personalizzazione PDF Options (JSON)](#personalizzazione-pdf-options-json)
5. [Esempi Pratici](#esempi-pratici)

---

## Panoramica

Lo script `converti_md_pdf_completo.ps1` converte automaticamente tutti i file `.md` presenti nella directory corrente in file PDF, utilizzando:

- **CSS** (`style.css`): per lo styling del contenuto
- **PDF Options** (`pdf-options.json`): per le impostazioni di layout e formattazione del PDF

### Requisiti

- PowerShell 5.1 o superiore
- Node.js installato
- Pacchetto `md-to-pdf` installato (via npm)

---

## Utilizzo dello Script PowerShell

### Esecuzione Base

```powershell
.\converti_md_pdf_completo.ps1
```

### Cosa Fa lo Script

1. **Verifica file necessari**: controlla l'esistenza di `style.css`, `pdf-options.json` e `convert-md-to-pdf.js`
2. **Pre-processing formule matematiche**: per ogni `.md` esegue `convert-md-to-pdf.js`, che converte `<span class="math-inline">\(...\)</span>` e `

<div class="math-block">\[...\]</div>

` negli span/div con classi `math-inline` e `math-block` usate da MathJax
3. **Processa tutti i file `.md`**: converte ogni file Markdown (escluso `cursor.md`) con `npx md-to-pdf`
4. **Genera PDF**: crea file PDF con lo stesso nome del file `.md` originale

### Struttura dello Script

Lo script:
- Legge i percorsi assoluti dei file CSS e JSON
- Carica le opzioni PDF dal file JSON
- Per ogni file `.md`:
  - Esegue `npx md-to-pdf` con CSS e opzioni PDF
  - Genera il file PDF corrispondente
- Mostra messaggi di stato colorati per ogni operazione

### Esclusione File

Lo script esclude automaticamente `cursor.md` dalla conversione.

---

## Personalizzazione CSS

Il file `style.css` controlla l'aspetto visivo del contenuto nel PDF. Ecco le sezioni principali e come modificarle.

### 📄 Impostazioni Pagina (@page)

```css
@page {
  size: A4;                    /* Formato: A4, Letter, Legal, ecc. */
  margin-top: 2cm;             /* Margine superiore */
  margin-bottom: 2cm;          /* Margine inferiore */
  margin-left: 1.5cm;          /* Margine sinistro */
  margin-right: 1.5cm;         /* Margine destro */
}
```

**Opzioni disponibili per `size`:**
- `A4`, `A3`, `A5`, `Letter`, `Legal`, `Tabloid`
- Dimensioni personalizzate: `width height` (es. `21cm 29.7cm`)

**Esempio - Pagina più piccola con margini ridotti:**
```css
@page {
  size: A5;
  margin: 1cm;
}
```

### 📝 Tipografia Base (body)

```css
body {
  font-family: "Georgia", "Times New Roman", serif;
  font-size: 11pt;              /* Dimensione carattere */
  line-height: 1.6;             /* Interlinea */
  color: #2c3e50;               /* Colore testo */
  background: #ffffff;          /* Colore sfondo */
}
```

**Font disponibili:**
- Serif: `Georgia`, `Times New Roman`, `Palatino`
- Sans-serif: `Arial`, `Helvetica`, `Verdana`, `Calibri`
- Monospace: `Consolas`, `Monaco`, `Courier New`

**Esempio - Font moderno:**
```css
body {
  font-family: "Calibri", "Arial", sans-serif;
  font-size: 12pt;
  line-height: 1.8;
  color: #1a1a1a;
}
```

### 📑 Titoli (h1, h2, h3, h4)

#### H1 - Titolo Principale

```css
h1 {
  font-family: "Arial", "Helvetica", sans-serif;
  font-size: 24pt;              /* Dimensione */
  font-weight: 700;             /* Grassetto: 400, 600, 700 */
  color: #1a1a1a;               /* Colore */
  margin-top: 24pt;             /* Spazio sopra */
  margin-bottom: 12pt;           /* Spazio sotto */
  padding-bottom: 8pt;          /* Padding inferiore */
  border-bottom: 1.5pt solid #3498db;  /* Bordo inferiore */
  page-break-after: avoid;      /* Evita interruzioni pagina */
}
```

**Esempio - H1 senza bordo:**
```css
h1 {
  font-size: 28pt;
  color: #2c3e50;
  border-bottom: none;
  margin-bottom: 16pt;
}
```

#### H2, H3, H4

Stessa struttura di H1, con dimensioni e stili progressivamente più piccoli.

**Esempio - H2 con sfondo colorato:**
```css
h2 {
  font-size: 18pt;
  background-color: #e8f4f8;
  padding: 8pt 12pt;
  border-left: 4pt solid #3498db;
  border-bottom: none;
}
```

### 📄 Paragrafi (p)

```css
p {
  margin: 8pt 0;                /* Margini verticali */
  text-align: justify;          /* Allineamento: left, right, center, justify */
  orphans: 3;                   /* Linee orfane minime */
  widows: 3;                    /* Linee vedove minime */
}
```

**Esempio - Paragrafi allineati a sinistra:**
```css
p {
  text-align: left;
  margin: 10pt 0;
  line-height: 1.7;
}
```

### 📋 Liste (ul, ol, li)

```css
ul, ol {
  margin: 10pt 0;
  padding-left: 24pt;           /* Indentazione */
}

li {
  margin: 4pt 0;
  line-height: 1.5;
}

ul li {
  list-style-type: disc;        /* Tipo: disc, circle, square, none */
}

ol li {
  list-style-type: decimal;     /* Tipo: decimal, lower-roman, upper-roman, ecc. */
}
```

**Esempio - Liste compatte:**
```css
ul, ol {
  margin: 6pt 0;
  padding-left: 20pt;
}

li {
  margin: 2pt 0;
}
```

### 🔗 Link (a)

```css
a {
  color: #3498db;               /* Colore link */
  text-decoration: none;         /* Sottolineatura: none, underline */
}

a:hover {
  text-decoration: underline;   /* Stile al passaggio mouse (solo preview) */
}
```

**Esempio - Link evidenziati:**
```css
a {
  color: #e74c3c;
  text-decoration: underline;
  font-weight: 600;
}
```

### 📊 Tabelle (table, th, td)

```css
table {
  width: 100%;                   /* Larghezza tabella */
  border-collapse: collapse;    /* Bordi uniti */
  margin: 12pt 0;
  border: 0.5pt solid #e0e0e0;
}

th {
  background-color: #34495e;     /* Sfondo header */
  color: #ffffff;                /* Colore testo header */
  font-weight: 600;
  padding: 8pt;
  text-align: left;              /* Allineamento: left, center, right */
}

td {
  padding: 6pt 8pt;
  border: 0.5pt solid #e8e8e8;
  background-color: #ffffff;
}

tr:nth-child(even) td {
  background-color: #f8f9fa;     /* Righe alternate */
}
```

**Esempio - Tabelle minimaliste:**
```css
table {
  border: none;
}

th {
  background-color: #f0f0f0;
  color: #1a1a1a;
  border-bottom: 2pt solid #3498db;
}

td {
  border: none;
  border-bottom: 0.5pt solid #e0e0e0;
}
```

### 💻 Blocchi Codice (pre, code)

```css
pre {
  background-color: #f8f9fa;     /* Sfondo blocco codice */
  border: 0.5pt solid #e0e0e0;
  border-left: 3pt solid #3498db;  /* Bordo sinistro evidenziato */
  border-radius: 3pt;            /* Angoli arrotondati */
  padding: 12pt;
  margin: 12pt 0;
  font-family: "Consolas", "Monaco", monospace;
  font-size: 10pt;
  line-height: 1.4;
}

code {
  background-color: #f8f9fa;
  border: 0.5pt solid #e0e0e0;
  border-radius: 2pt;
  padding: 2pt 4pt;
  font-family: "Consolas", "Monaco", monospace;
  font-size: 10pt;
  color: #e74c3c;                /* Colore codice inline */
}
```

**Esempio - Codice con sfondo scuro:**
```css
pre {
  background-color: #2c3e50;
  color: #ecf0f1;
  border-left: 4pt solid #3498db;
}

pre code {
  color: #ecf0f1;
}
```

### 💬 Citazioni (blockquote)

```css
blockquote {
  border-left: 3pt solid #3498db;
  margin: 12pt 0;
  padding: 8pt 16pt;
  background-color: #f8f9fa;
  font-style: italic;
  color: #555;
}
```

**Esempio - Citazioni minimaliste:**
```css
blockquote {
  border-left: 4pt solid #e74c3c;
  background-color: transparent;
  padding-left: 16pt;
  margin-left: 0;
}
```

### 🖼️ Immagini (img)

```css
img {
  max-width: 100%;              /* Larghezza massima */
  height: auto;                 /* Altezza automatica */
  display: block;               /* Display: block, inline */
  margin: 12pt auto;             /* Centratura */
  page-break-inside: avoid;     /* Evita interruzioni */
}
```

**Esempio - Immagini più piccole:**
```css
img {
  max-width: 80%;
  border: 1pt solid #e0e0e0;
  padding: 4pt;
}
```

### ⚡ Enfasi (strong, em)

```css
strong, b {
  font-weight: 700;
  color: #1a1a1a;
}

em, i {
  font-style: italic;
}
```

### 📄 Interruzioni di pagina

**Nota:** Non esiste una sintassi Markdown standard per l’interruzione di pagina; si usa HTML (supportato da md-to-pdf).

#### Interruzione manuale nel file .md

Inserisci nel punto desiderato:

```html
<div class="page-break"></div>
```

Nel CSS è già definita la classe (in `style.css`):

```css
.page-break {
  page-break-before: always;    /* Forza nuova pagina prima dell’elemento */
}

.no-break {
  page-break-inside: avoid;     /* Evita che il blocco venga spezzato tra due pagine */
}
```

**Esempio nel Markdown:**
```markdown
Fine della sezione uno.

<div class="page-break"></div>

## Nuova sezione
```

#### Nuova pagina prima di ogni H2 (solo CSS)

Per far iniziare ogni titolo di livello 2 su una nuova pagina, in `style.css` aggiungi:

```css
h2 {
  page-break-before: always;
}
```

Per evitare una pagina bianca all’inizio (il primo H2 non deve forzare una nuova pagina), aggiungi:

```css
h2:first-of-type {
  page-break-before: avoid;
}
```

Così solo dal secondo H2 in poi si avrà un’interruzione di pagina prima del titolo.

### 📐 Formule matematiche (MathJax)

Lo script pre-processa le formule con `convert-md-to-pdf.js` (sintassi `<span class="math-inline">\(...\)</span>` inline e `

<div class="math-block">\[...\]</div>

` in blocco) e produce HTML con classi gestite da `style.css`:

- **Inline:** `<span class="math-inline">\(...\)</span>`
- **Blocco:** `<div class="math-block">\[...\]</div>`

Nel CSS sono definiti `.math-inline` e `.math-block` (margini, centratura, `page-break-inside: avoid` per i blocchi). **Sintassi da usare nei file .md:** formule inline con `$...$`, formule in blocco con `

<div class="math-block">\[...\]</div>

` su righe separate; lo script le converte automaticamente prima della generazione del PDF.

---

## Personalizzazione PDF Options (JSON)

Il file `pdf-options.json` controlla le impostazioni di layout e formattazione del PDF generato da Puppeteer.

### Struttura Base

```json
{
  "format": "A4",
  "displayHeaderFooter": true,
  "headerTemplate": "...",
  "footerTemplate": "...",
  "margin": {
    "top": "2cm",
    "bottom": "2cm",
    "left": "1.5cm",
    "right": "1.5cm"
  },
  "printBackground": true
}
```

### Opzioni Disponibili

#### 📐 format

**Descrizione:** Formato della pagina PDF.

**Valori possibili:**
- `"A4"` (default)
- `"A3"`, `"A5"`, `"Letter"`, `"Legal"`, `"Tabloid"`
- Dimensioni personalizzate: `"21cm 29.7cm"`

**Esempio:**
```json
{
  "format": "Letter"
}
```

#### 📄 displayHeaderFooter

**Descrizione:** Mostra o nasconde header e footer.

**Valori:** `true` o `false`

**Esempio:**
```json
{
  "displayHeaderFooter": false
}
```

#### 📑 headerTemplate

**Descrizione:** Template HTML per l'header di ogni pagina. L'header viene posizionato all'interno del margine superiore (`margin.top`).

**⚠️ IMPORTANTE - Problema con padding-right/padding-left:**
Puppeteer (usato da md-to-pdf) potrebbe non rispettare correttamente `padding-right` e `padding-left` quando applicati direttamente a un `<div>` negli header/footer. **Soluzione consigliata**: Usa `position:absolute` con `right`/`left` per posizionare il contenuto, oppure usa tabelle (nelle celle `<td>` il padding funziona correttamente).

**Importante - Margini di Testata:**
- L'header viene renderizzato all'interno dello spazio definito da `margin.top`
- Il contenuto del documento inizia dopo l'header, sempre rispettando il margine superiore
- Usa `padding-top` e `padding-bottom` nell'header per controllare lo spazio verticale
- **ATTENZIONE**: `padding-left` e `padding-right` potrebbero non essere rispettati correttamente da Puppeteer negli header/footer
- **Soluzione consigliata**: Usa `position:absolute` con `right` o `left` per posizionare il contenuto, oppure usa tabelle con `padding-left`/`padding-right` nelle celle (queste funzionano meglio)

**Variabili disponibili:**
- `<span class='date'></span>` - Data corrente
- `<span class='title'></span>` - Titolo del documento
- `<span class='url'></span>` - URL del documento
- `<span class='pageNumber'></span>` - Numero pagina corrente
- `<span class='totalPages'></span>` - Totale pagine

**Esempio base (con position:absolute - consigliato):**
```json
{
  "headerTemplate": "<div style='font-size:9pt; width:100%; padding-top:0.5cm; color: #555; position:relative;'><div style='text-align:right; position:absolute; right:1.5cm;'>prof. Giuseppe Bosi</div></div>"
}
```

**Esempio base alternativo (con padding - potrebbe non funzionare correttamente):**
```json
{
  "headerTemplate": "<div style='font-size:9pt; text-align:right; width:100%; padding-right:1.5cm; padding-top:0.5cm; color: #555;'>prof. Giuseppe Bosi</div>"
}
```

**Esempio con numero pagina:**
```json
{
  "headerTemplate": "<div style='font-size:9pt; text-align:center; width:100%; padding-top:0.5cm; color: #666;'>Pagina <span class='pageNumber'></span> di <span class='totalPages'></span></div>"
}
```

**Esempio con data e titolo (con position:absolute - consigliato):**
```json
{
  "headerTemplate": "<div style='font-size:9pt; width:100%; padding-top:0.5cm; padding-bottom:0.5cm; color: #555; position:relative;'><div style='position:absolute; left:1.5cm;'><span class='title'></span></div><div style='position:absolute; right:1.5cm;'><span class='date'></span></div></div>"
}
```

**Esempio con data e titolo alternativo (con padding - potrebbe non funzionare correttamente):**
```json
{
  "headerTemplate": "<div style='font-size:9pt; width:100%; padding:0.5cm 1.5cm; color: #555; display:flex; justify-content:space-between;'><span><span class='title'></span></span><span><span class='date'></span></span></div>"
}
```

**Esempio - Header con bordo inferiore (con position:absolute - consigliato):**
```json
{
  "headerTemplate": "<div style='font-size:9pt; width:100%; padding-top:0.5cm; padding-bottom:0.3cm; color: #555; border-bottom:1pt solid #e0e0e0; position:relative;'><div style='text-align:right; position:absolute; right:1.5cm;'>Documento | <span class='date'></span></div></div>"
}
```

#### 📑 footerTemplate

**Descrizione:** Template HTML per il footer di ogni pagina. Il footer viene posizionato all'interno del margine inferiore (`margin.bottom`).

**⚠️ IMPORTANTE - Problema con padding-right/padding-left:**
Puppeteer (usato da md-to-pdf) potrebbe non rispettare correttamente `padding-right` e `padding-left` quando applicati direttamente a un `<div>` negli header/footer. **Soluzione consigliata**: Usa `position:absolute` con `right`/`left` per posizionare il contenuto, oppure usa tabelle (nelle celle `<td>` il padding funziona correttamente).

**Importante - Margini di Piè di Pagina:**
- Il footer viene renderizzato all'interno dello spazio definito da `margin.bottom`
- Il contenuto del documento termina prima del footer, sempre rispettando il margine inferiore
- Usa `padding-top` e `padding-bottom` nel footer per controllare lo spazio verticale
- **ATTENZIONE**: `padding-left` e `padding-right` potrebbero non essere rispettati correttamente da Puppeteer negli header/footer
- **Soluzione consigliata**: Usa `position:absolute` con `right` o `left` per posizionare il contenuto, oppure usa tabelle con `padding-left`/`padding-right` nelle celle (queste funzionano meglio)

**Stessa struttura di `headerTemplate`.**

**Esempio base:**
```json
{
  "footerTemplate": "<div style='font-size:8pt; width:100%; text-align:center; padding-bottom:0.5cm; color: #888; border-top:1pt solid #e0e0e0; padding-top:0.3cm; margin-top:0.5cm;'>© 2025 - Giuseppe Bosi | Pagina <span class='pageNumber'></span></div>"
}
```

#### 🔢 Numeri di Pagina

**Descrizione:** Per inserire i numeri di pagina, usa le variabili `<span class='pageNumber'></span>` e `<span class='totalPages'></span>`.

**Variabili disponibili:**
- `<span class='pageNumber'></span>` - Numero della pagina corrente (es. 1, 2, 3...)
- `<span class='totalPages'></span>` - Numero totale di pagine del documento

**Esempio - Numero pagina semplice:**
```json
{
  "footerTemplate": "<div style='font-size:9pt; text-align:center; width:100%; padding-bottom:0.5cm; color: #666;'>Pagina <span class='pageNumber'></span></div>"
}
```

**Esempio - Numero pagina con totale:**
```json
{
  "footerTemplate": "<div style='font-size:9pt; text-align:center; width:100%; padding-bottom:0.5cm; color: #666;'>Pagina <span class='pageNumber'></span> di <span class='totalPages'></span></div>"
}
```

**Esempio - Numero pagina allineato a destra (con position:absolute - consigliato):**
```json
{
  "footerTemplate": "<div style='font-size:9pt; width:100%; padding-bottom:0.5cm; color: #666; position:relative;'><div style='text-align:right; position:absolute; right:1.5cm;'>Pagina <span class='pageNumber'></span></div></div>"
}
```

**Esempio - Numero pagina a sinistra e autore a destra (con position:absolute - consigliato):**
```json
{
  "footerTemplate": "<div style='font-size:8pt; width:100%; padding-bottom:0.5cm; color: #555; position:relative;'><div style='position:absolute; left:1.5cm;'>Pagina <span class='pageNumber'></span> / <span class='totalPages'></span></div><div style='text-align:right; position:absolute; right:1.5cm;'>Prof. Giuseppe Bosi</div></div>"
}
```

**Spiegazione:**
- Usa `position:relative` sul contenitore esterno
- Usa `position:absolute; left:1.5cm;` per posizionare il numero di pagina a sinistra (allineato al margine sinistro)
- Usa `position:absolute; right:1.5cm;` per posizionare l'autore a destra (allineato al margine destro)
- I valori `left` e `right` devono corrispondere ai margini `left` e `right` definiti in `margin`

#### 📊 Header e Footer con Tabelle

**Descrizione:** Puoi usare tabelle HTML per creare layout complessi in header e footer, con colonne equamente distribuite.

**Struttura base tabella:**
```html
<table style='width:100%; border-collapse:collapse;'>
  <tr>
    <td style='width:33.33%; text-align:left;'>Colonna 1</td>
    <td style='width:33.33%; text-align:center;'>Colonna 2</td>
    <td style='width:33.33%; text-align:right;'>Colonna 3</td>
  </tr>
</table>
```

**Esempio - Footer con tabella a 3 colonne (Num. Pagina | Titolo | Autore):**
```json
{
  "footerTemplate": "<table style='width:100%; border-collapse:collapse; border-top:1pt solid #e0e0e0; padding-top:0.3cm;'><tr><td style='width:33.33%; text-align:left; padding-left:1.5cm; font-size:8pt; color: #666;'>Pagina <span class='pageNumber'></span></td><td style='width:33.33%; text-align:center; font-size:8pt; color: #666;'><span class='title'></span></td><td style='width:33.33%; text-align:right; padding-right:1.5cm; font-size:8pt; color: #666;'>Giuseppe Bosi</td></tr></table>"
}
```

**Esempio formattato per leggibilità:**
```json
{
  "footerTemplate": "<table style='width:100%; border-collapse:collapse; border-top:1pt solid #e0e0e0; padding-top:0.3cm;'><tr><td style='width:33.33%; text-align:left; padding-left:1.5cm; font-size:8pt; color: #666; padding-bottom:0.5cm;'>Pagina <span class='pageNumber'></span></td><td style='width:33.33%; text-align:center; font-size:8pt; color: #666; padding-bottom:0.5cm;'><span class='title'></span></td><td style='width:33.33%; text-align:right; padding-right:1.5cm; font-size:8pt; color: #666; padding-bottom:0.5cm;'>Giuseppe Bosi</td></tr></table>"
}
```

**Esempio - Header con tabella a 3 colonne (Data | Titolo | Autore):**
```json
{
  "headerTemplate": "<table style='width:100%; border-collapse:collapse; border-bottom:1pt solid #e0e0e0; padding-bottom:0.3cm;'><tr><td style='width:33.33%; text-align:left; padding-left:1.5cm; font-size:9pt; color: #555; padding-top:0.5cm;'><span class='date'></span></td><td style='width:33.33%; text-align:center; font-size:9pt; color: #555; padding-top:0.5cm; font-weight:600;'><span class='title'></span></td><td style='width:33.33%; text-align:right; padding-right:1.5cm; font-size:9pt; color: #555; padding-top:0.5cm;'>Giuseppe Bosi</td></tr></table>"
}
```

**Esempio - Footer con tabella a 2 colonne (Num. Pagina | Autore):**
```json
{
  "footerTemplate": "<table style='width:100%; border-collapse:collapse; border-top:1pt solid #e0e0e0; padding-top:0.3cm;'><tr><td style='width:50%; text-align:left; padding-left:1.5cm; font-size:8pt; color: #666; padding-bottom:0.5cm;'>Pagina <span class='pageNumber'></span> di <span class='totalPages'></span></td><td style='width:50%; text-align:right; padding-right:1.5cm; font-size:8pt; color: #666; padding-bottom:0.5cm;'>Giuseppe Bosi</td></tr></table>"
}
```

**Suggerimenti per tabelle in header/footer:**
- Usa `width:100%` sulla tabella per occupare tutta la larghezza
- Per colonne equamente distribuite, usa `width:33.33%` per 3 colonne, `width:50%` per 2 colonne, `width:25%` per 4 colonne
- Usa `border-collapse:collapse` per bordi puliti
- **NOTA**: Nelle tabelle, `padding-left` e `padding-right` funzionano correttamente nelle celle `<td>`, quindi puoi usarli per allineare con i margini del documento
- Usa `text-align:left`, `text-align:center`, `text-align:right` per allineare il contenuto nelle colonne

#### 📏 margin

**Descrizione:** Margini della pagina. I margini `top` e `bottom` includono lo spazio per header e footer.

**Unità supportate:** `cm`, `mm`, `in`, `px`

**Struttura:**
```json
{
  "margin": {
    "top": "2cm",      /* Margine superiore (include spazio per header) */
    "bottom": "2cm",    /* Margine inferiore (include spazio per footer) */
    "left": "1.5cm",    /* Margine sinistro */
    "right": "1.5cm"    /* Margine destro */
  }
}
```

**Importante:** 
- Il margine `top` definisce lo spazio tra il bordo superiore della pagina e l'inizio del contenuto. Se usi un header, questo spazio include l'area dell'header.
- Il margine `bottom` definisce lo spazio tra il bordo inferiore della pagina e la fine del contenuto. Se usi un footer, questo spazio include l'area del footer.
- Header e footer vengono posizionati all'interno dei margini `top` e `bottom` rispettivamente.

**Esempio - Margini ridotti:**
```json
{
  "margin": {
    "top": "1cm",
    "bottom": "1cm",
    "left": "1cm",
    "right": "1cm"
  }
}
```

**Esempio - Margini asimmetrici:**
```json
{
  "margin": {
    "top": "2.5cm",
    "bottom": "2cm",
    "left": "2cm",
    "right": "1.5cm"
  }
}
```

**Esempio - Margini ottimizzati per header/footer:**
```json
{
  "margin": {
    "top": "2.5cm",     /* Spazio per header (circa 1cm) + margine contenuto */
    "bottom": "2.5cm",  /* Spazio per footer (circa 1cm) + margine contenuto */
    "left": "2cm",
    "right": "1.5cm"
  }
}
```

#### 🎨 printBackground

**Descrizione:** Stampa gli sfondi e i colori di background.

**Valori:** `true` o `false`

**Esempio:**
```json
{
  "printBackground": true
}
```

**Nota:** Se `false`, gli sfondi colorati non verranno stampati (utile per risparmiare inchiostro).

#### 📄 landscape

**Descrizione:** Orientamento orizzontale della pagina.

**Valori:** `true` o `false`

**Esempio:**
```json
{
  "format": "A4",
  "landscape": true
}
```

#### 📏 scale

**Descrizione:** Scala di rendering (0.1 - 2.0).

**Valori:** Numero decimale (es. `1.0`, `0.8`, `1.2`)

**Esempio:**
```json
{
  "scale": 0.9
}
```

#### 📄 preferCSSPageSize

**Descrizione:** Usa le dimensioni definite nel CSS invece che in `format`.

**Valori:** `true` o `false`

**Esempio:**
```json
{
  "preferCSSPageSize": true
}
```

### Configurazione Completa Esempio

**Esempio 1 - Footer con numero pagina a sinistra e autore a destra:**
```json
{
  "format": "A4",
  "displayHeaderFooter": true,
  "headerTemplate": "<div></div>",
  "footerTemplate": "<div style='font-size:8pt; width:100%; padding-bottom:0.5cm; color: #555; position:relative;'><div style='position:absolute; left:1.5cm;'>Pagina <span class='pageNumber'></span> / <span class='totalPages'></span></div><div style='text-align:right; position:absolute; right:1.5cm;'>Prof. Giuseppe Bosi</div></div>",
  "margin": {
    "top": "1.5cm",
    "bottom": "1cm",
    "left": "1.5cm",
    "right": "1.5cm"
  },
  "printBackground": true
}
```

**Esempio 2 - Header e footer completi:**
```json
{
  "format": "A4",
  "displayHeaderFooter": true,
  "headerTemplate": "<div style='font-size:9pt; width:100%; padding-top:0.5cm; padding-bottom:0.3cm; color: #555; border-bottom:1pt solid #e0e0e0; position:relative;'><div style='text-align:right; position:absolute; right:1.5cm;'>Documento | <span class='date'></span></div></div>",
  "footerTemplate": "<div style='font-size:8pt; width:100%; text-align:center; padding-bottom:0.5cm; color: #888;'>Pagina <span class='pageNumber'></span> di <span class='totalPages'></span></div>",
  "margin": {
    "top": "2.5cm",      /* Spazio totale superiore: include header (circa 1cm) + margine contenuto */
    "bottom": "2cm",      /* Spazio totale inferiore: include footer (circa 1cm) + margine contenuto */
    "left": "2cm",        /* Margine sinistro */
    "right": "1.5cm"      /* Margine destro */
  },
  "printBackground": true,
  "landscape": false,
  "scale": 1.0
}
```

**Nota sui Margini:**
- `margin.top`: Definisce lo spazio totale tra il bordo superiore della pagina e l'inizio del contenuto. Se usi un header, questo spazio include l'area dell'header (circa 0.8-1.2cm) più il margine effettivo del contenuto.
- `margin.bottom`: Definisce lo spazio totale tra il bordo inferiore della pagina e la fine del contenuto. Se usi un footer, questo spazio include l'area del footer (circa 0.8-1.2cm) più il margine effettivo del contenuto.
- `margin.left` e `margin.right`: Definiscono i margini laterali del contenuto. 
- **IMPORTANTE**: Per allineare il contenuto di header/footer con i margini, usa `position:absolute` con `right`/`left` invece di `padding-right`/`padding-left` (che potrebbero non funzionare). Nelle tabelle, invece, `padding-left`/`padding-right` nelle celle funzionano correttamente.

---

## Esempi Pratici

### Esempio 1: Documento Accademico

**CSS - Stile formale:**
```css
body {
  font-family: "Times New Roman", serif;
  font-size: 12pt;
  line-height: 2.0;
}

h1 {
  font-size: 16pt;
  text-align: center;
  margin-top: 24pt;
}

h2 {
  font-size: 14pt;
  margin-top: 18pt;
}
```

**JSON - Header con titolo:**
```json
{
  "format": "A4",
  "displayHeaderFooter": true,
  "headerTemplate": "<div style='font-size:10pt; text-align:center; width:100%; padding-top:0.5cm;'><span class='title'></span></div>",
  "footerTemplate": "<div style='font-size:9pt; text-align:center; width:100%; padding-bottom:0.5cm;'>Pagina <span class='pageNumber'></span></div>",
  "margin": {
    "top": "2.5cm",
    "bottom": "2cm",
    "left": "2.5cm",
    "right": "2cm"
  },
  "printBackground": true
}
```

### Esempio 2: Documento Moderno Minimalista

**CSS - Stile pulito:**
```css
body {
  font-family: "Arial", sans-serif;
  font-size: 11pt;
  line-height: 1.6;
  color: #333;
}

h1 {
  font-size: 28pt;
  color: #2c3e50;
  border-bottom: none;
  margin-bottom: 20pt;
}

h2 {
  font-size: 20pt;
  color: #34495e;
  margin-top: 24pt;
  border-bottom: 2pt solid #3498db;
  padding-bottom: 6pt;
}
```

**JSON - Senza header/footer:**
```json
{
  "format": "A4",
  "displayHeaderFooter": false,
  "margin": {
    "top": "2cm",
    "bottom": "2cm",
    "left": "2cm",
    "right": "2cm"
  },
  "printBackground": true
}
```

### Esempio 3: Presentazione Orizzontale

**JSON - Landscape:**
```json
{
  "format": "A4",
  "landscape": true,
  "displayHeaderFooter": true,
  "headerTemplate": "<div style='font-size:10pt; text-align:center; width:100%; padding-top:0.5cm;'><span class='title'></span></div>",
  "footerTemplate": "<div style='font-size:9pt; text-align:center; width:100%; padding-bottom:0.5cm;'>Pagina <span class='pageNumber'></span></div>",
  "margin": {
    "top": "1.5cm",
    "bottom": "1.5cm",
    "left": "2cm",
    "right": "2cm"
  },
  "printBackground": true
}
```

### Esempio 4: Documento con Codice Evidenziato

**CSS - Codice con tema scuro:**
```css
pre {
  background-color: #1e1e1e;
  color: #d4d4d4;
  border-left: 4pt solid #007acc;
  padding: 16pt;
  border-radius: 4pt;
}

code {
  background-color: #f4f4f4;
  color: #c7254e;
  padding: 2pt 6pt;
  border-radius: 3pt;
  font-weight: 600;
}
```

### Esempio 5: Footer con Tabella a 3 Colonne

**Descrizione:** Footer professionale con tabella che divide lo spazio in 3 colonne equamente distribuite: Numero Pagina | Titolo Documento | Nome Autore.

**JSON - Footer con tabella:**
```json
{
  "format": "A4",
  "displayHeaderFooter": true,
  "headerTemplate": "<div style='font-size:9pt; width:100%; padding-top:0.5cm; padding-bottom:0.3cm; color: #555; border-bottom:1pt solid #e0e0e0; position:relative;'><div style='text-align:right; position:absolute; right:1.5cm;'>Documento</div></div>",
  "footerTemplate": "<table style='width:100%; border-collapse:collapse; border-top:1pt solid #e0e0e0; padding-top:0.3cm;'><tr><td style='width:33.33%; text-align:left; padding-left:1.5cm; font-size:8pt; color: #666; padding-bottom:0.5cm;'>Pagina <span class='pageNumber'></span></td><td style='width:33.33%; text-align:center; font-size:8pt; color: #666; padding-bottom:0.5cm;'><span class='title'></span></td><td style='width:33.33%; text-align:right; padding-right:1.5cm; font-size:8pt; color: #666; padding-bottom:0.5cm;'>Giuseppe Bosi</td></tr></table>",
  "margin": {
    "top": "2.5cm",
    "bottom": "2.5cm",
    "left": "1.5cm",
    "right": "1.5cm"
  },
  "printBackground": true
}
```

**Spiegazione:**
- **Colonna 1 (sinistra)**: Numero pagina allineato a sinistra con padding che corrisponde al margine sinistro
- **Colonna 2 (centro)**: Titolo del documento centrato (usando `<span class='title'></span>`)
- **Colonna 3 (destra)**: Nome autore allineato a destra con padding che corrisponde al margine destro
- Ogni colonna occupa esattamente `33.33%` della larghezza totale
- Bordo superiore della tabella per separare visivamente il footer dal contenuto

**Variante con "Pagina X di Y":**
```json
{
  "footerTemplate": "<table style='width:100%; border-collapse:collapse; border-top:1pt solid #e0e0e0; padding-top:0.3cm;'><tr><td style='width:33.33%; text-align:left; padding-left:1.5cm; font-size:8pt; color: #666; padding-bottom:0.5cm;'>Pagina <span class='pageNumber'></span> di <span class='totalPages'></span></td><td style='width:33.33%; text-align:center; font-size:8pt; color: #666; padding-bottom:0.5cm;'><span class='title'></span></td><td style='width:33.33%; text-align:right; padding-right:1.5cm; font-size:8pt; color: #666; padding-bottom:0.5cm;'>Giuseppe Bosi</td></tr></table>"
}
```

**Variante con header a tabella:**
```json
{
  "format": "A4",
  "displayHeaderFooter": true,
  "headerTemplate": "<table style='width:100%; border-collapse:collapse; border-bottom:1pt solid #e0e0e0; padding-bottom:0.3cm;'><tr><td style='width:33.33%; text-align:left; padding-left:1.5cm; font-size:9pt; color: #555; padding-top:0.5cm;'><span class='date'></span></td><td style='width:33.33%; text-align:center; font-size:9pt; color: #555; padding-top:0.5cm; font-weight:600;'><span class='title'></span></td><td style='width:33.33%; text-align:right; padding-right:1.5cm; font-size:9pt; color: #555; padding-top:0.5cm;'>Giuseppe Bosi</td></tr></table>",
  "footerTemplate": "<table style='width:100%; border-collapse:collapse; border-top:1pt solid #e0e0e0; padding-top:0.3cm;'><tr><td style='width:33.33%; text-align:left; padding-left:1.5cm; font-size:8pt; color: #666; padding-bottom:0.5cm;'>Pagina <span class='pageNumber'></span></td><td style='width:33.33%; text-align:center; font-size:8pt; color: #666; padding-bottom:0.5cm;'><span class='title'></span></td><td style='width:33.33%; text-align:right; padding-right:1.5cm; font-size:8pt; color: #666; padding-bottom:0.5cm;'>Giuseppe Bosi</td></tr></table>",
  "margin": {
    "top": "2.5cm",
    "bottom": "2.5cm",
    "left": "1.5cm",
    "right": "1.5cm"
  },
  "printBackground": true
}
```

---

## 🔧 Troubleshooting

### Problema: CSS non viene applicato

**Soluzione:** Verifica che il percorso del file CSS sia corretto e che lo script trovi `style.css` nella stessa directory.

### Problema: Header/Footer non compaiono

**Soluzione:** Verifica che `displayHeaderFooter` sia impostato a `true` nel JSON.

### Problema: Margini non corrispondono

**Soluzione:** Assicurati che i margini nel CSS (`@page`) e nel JSON (`margin`) siano coerenti. Il JSON ha la priorità.

### Problema: Colori di sfondo non compaiono

**Soluzione:** Imposta `printBackground: true` nel JSON.

---

## 📚 Risorse Aggiuntive

- [md-to-pdf Documentation](https://github.com/simonhaenisch/md-to-pdf)
- [Puppeteer PDF Options](https://pptr.dev/api/puppeteer.pdfoptions)
- [CSS Print Media Queries](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/print)

---

**Ultima modifica:** 2026
