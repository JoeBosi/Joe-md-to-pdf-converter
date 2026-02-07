# Figure Geometriche SVG

Questo documento contiene tre figure geometriche create con SVG.

## 1. Cerchio

<svg width="200" height="200" xmlns="http://www.w3.org/2000/svg">
  <!-- Cerchio centrale -->
  <circle cx="100" cy="100" r="80" 
          fill="#4CAF50" 
          stroke="#2E7D32" 
          stroke-width="3"/>
  
  <!-- Etichetta -->
  <text x="100" y="105" 
        text-anchor="middle" 
        fill="white" 
        font-size="18" 
        font-family="Arial">
    Cerchio
  </text>
</svg>

**Caratteristiche:**
- Centro: (100, 100)
- Raggio: 80 px
- Colore: Verde

---

## 2. Rettangolo

<svg width="300" height="200" xmlns="http://www.w3.org/2000/svg">
  <!-- Rettangolo -->
  <rect x="50" y="50" 
        width="200" height="100" 
        fill="#2196F3" 
        stroke="#1565C0" 
        stroke-width="3"
        rx="10" ry="10"/>
  
  <!-- Etichetta -->
  <text x="150" y="105" 
        text-anchor="middle" 
        fill="white" 
        font-size="18" 
        font-family="Arial">
    Rettangolo
  </text>
</svg>

**Caratteristiche:**
- Posizione: (50, 50)
- Dimensioni: 200 × 100 px
- Colore: Blu
- Angoli arrotondati: 10 px

---

## 3. Cono (Prospettiva 3D)

<svg width="250" height="300" xmlns="http://www.w3.org/2000/svg">
  <!-- Base ellittica del cono (parte inferiore) -->
  <ellipse cx="125" cy="250" rx="80" ry="25" 
           fill="#C44545" 
           stroke="#8B3030" 
           stroke-width="2"/>
  
  <!-- Corpo del cono (triangolo) -->
  <path d="M 125 30 L 45 250 L 205 250 Z" 
        fill="#FF6B6B" 
        stroke="#C44545" 
        stroke-width="3"/>
  
  <!-- Linea di contorno superiore della base (per effetto 3D) -->
  <ellipse cx="125" cy="250" rx="80" ry="25" 
           fill="none" 
           stroke="#8B3030" 
           stroke-width="2"/>
  
  <!-- Punto apice -->
  <circle cx="125" cy="30" r="5" fill="#8B3030"/>
  
  <!-- Etichetta -->
  <text x="125" y="150" 
        text-anchor="middle" 
        fill="white" 
        font-size="20" 
        font-family="Arial"
        font-weight="bold">
    Cono
  </text>
</svg>

**Caratteristiche:**
- Altezza: ~220 px
- Base: ellisse (160 × 50 px)
- Colore: Rosso-arancione con gradiente
- Effetto 3D con prospettiva

---

## Note Tecniche

Tutte le figure sono create utilizzando **SVG (Scalable Vector Graphics)**, un formato vettoriale che garantisce:
- ✅ Scalabilità senza perdita di qualità
- ✅ Dimensioni file ridotte
- ✅ Compatibilità con tutti i browser moderni
- ✅ Possibilità di animazione e interazione

### Codice SVG Base

```svg
<!-- Cerchio -->
<circle cx="x" cy="y" r="raggio" fill="colore"/>

<!-- Rettangolo -->
<rect x="x" y="y" width="larghezza" height="altezza" fill="colore"/>

<!-- Forma personalizzata (per il cono) -->
<path d="M x1 y1 L x2 y2 L x3 y3 Z" fill="colore"/>
```
