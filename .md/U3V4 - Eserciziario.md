# ESERCIZI: SUBNETTING, VLSM E CIDR

Questo documento approfondisce le tre principali tecniche di gestione degli indirizzi IP, definendo per ciascuna il caso d'uso specifico e fornendo esercizi pratici svolti.

## 1. SUBNETTING STATICO (FLSM)

**Acronimo:** Fixed Length Subnet Mask.

### Quando si usa (Caso d'Uso)

Si utilizza quando si ha bisogno di dividere una rete in sottoreti che abbiano **tutte la stessa dimensione** (stesso numero di host).

- **Scenario tipico:** Un edificio con 4 piani, dove ogni piano ha lo stesso numero massimo di uffici/computer. Oppure un'azienda che vuole dividere i dipartimenti (Amministrazione, Vendite, IT) assegnando a tutti lo stesso spazio di indirizzamento per semplicità di gestione.

- **Vantaggio:** Semplicità di progettazione.

- **Svantaggio:** Spreco di indirizzi IP se le sottoreti hanno fabbisogni molto diversi.

### Esercizio 1: Divisione per numero di Sottoreti

**Scenario:**

Un amministratore di rete deve configurare la rete `192.168.50.0/24` per un edificio scolastico che ospita 4 laboratori distinti. Per questioni di sicurezza e gestione del traffico, ogni laboratorio deve essere isolato in una propria sottorete. Poiché i laboratori sono identici, si decide di dividere la rete in parti uguali.

**Obiettivo:**

Dividere la rete Classe C data in **4 sottoreti di uguale dimensione** (FLSM) e determinare i range di indirizzi utilizzabili per ciascun laboratorio.

**Svolgimento:**

1. **Analisi:** Dobbiamo creare 4 sottoreti.

2. **Formula:** 2^n ≥ 4 (dove *n* sono i bit presi in prestito).
   
   - 2² = 4. Servono **2 bit**.

3. **Nuova Maschera:** La maschera originale è `/24`. Nuova mask = **/26** (24 + 2 = 26).
   
   - In decimale: `/26` = `255.255.255.192` (perché 128+64=192).

4. **Magic Number (Passo):** 256 − 192 = **64**. Le reti avanzano di 64 in 64.

**Tabella Risultante:**

| **Nome Subnet** | **Indirizzo di Rete** | **Primo Host** | **Ultimo Host** | **Broadcast** |

| **Subnet A** | 192.168.50.0 | .1 | .62 | 192.168.50.63 |

| **Subnet B** | 192.168.50.64 | .65 | .126 | 192.168.50.127 |

| **Subnet C** | 192.168.50.128 | .129 | .190 | 192.168.50.191 |

| **Subnet D** | 192.168.50.192 | .193 | .254 | 192.168.50.255 |

### Esercizio 2: Divisione per numero di Host

**Scenario:** Un'azienda ha a disposizione la rete privata `172.16.0.0/16`. Deve pianificare l'indirizzamento per le sue nuove sedi distaccate. La richiesta del management è che ogni sottorete creata sia abbastanza grande da ospitare almeno **500 dipendenti (host)**, indipendentemente dal numero totale di sottoreti create.

**Obiettivo:** Calcolare la Subnet Mask necessaria per garantire 500 host per sottorete e identificare i parametri delle prime 3 sottoreti risultanti.

**Svolgimento:**

1. **Analisi:** Non ci interessa il numero di reti, ma garantire 500 host.

2. **Formula:** 2^h − 2 ≥ 500 (dove *h* sono i bit di host che dobbiamo lasciare a 0).
   
   - 2⁸ = 256 (Troppo pochi).
   
   - 2⁹ = 512 (Sufficienti). Quindi **h = 9**.

3. **Nuova Maschera:** La lunghezza totale è 32 bit. Se servono 9 bit per gli host, i restanti sono per la rete.
   
   - Nuova Mask = **/23** (32 − 9 = 23).
   
   - In decimale: `/23` significa che il terzo ottetto ha 7 bit a 1 (`11111110` = 254). Mask: `255.255.254.0`.

4. **Magic Number:** L'ottetto interessante è il terzo (valore 254). 256 − 254 = **2**.
   
   - Le reti avanzano di 2 nel terzo ottetto.

**Tabella Risultante (prime 3 subnet):**

| **Nome Subnet** | **Indirizzo di Rete** | **Primo Host** | **Ultimo Host** | **Broadcast** |

| **Subnet 1** | 172.16.0.0 | 172.16.0.1 | 172.16.1.254 | 172.16.1.255 |

| **Subnet 2** | 172.16.2.0 | 172.16.2.1 | 172.16.3.254 | 172.16.3.255 |

| **Subnet 3** | 172.16.4.0 | 172.16.4.1 | 172.16.5.254 | 172.16.5.255 |

<div class="page-break"></div>

## 2. VLSM (Variable Length Subnet Mask)

**Acronimo:** Variable Length Subnet Mask.

### Quando si usa (Caso d'Uso)

Si utilizza per **ottimizzare lo spazio di indirizzamento** assegnando maschere di dimensione diversa in base al reale fabbisogno di ogni sottorete.

- **Scenario tipico:** Una rete aziendale che ha una LAN principale con molti PC, delle LAN secondarie più piccole e dei collegamenti seriali (WAN) tra router.

- **Vantaggio:** Efficienza massima, zero sprechi (es. usare una /30 per un link punto-punto invece di una /24).

### Esercizio 1: Scenario LAN + WAN

**Scenario:** Si deve configurare una nuova filiale aziendale partendo dalla rete base `192.168.10.0/24`. La topologia prevede tre segmenti di rete con esigenze molto diverse: un ufficio open space (molti utenti), un ufficio amministrativo (pochi utenti) e un collegamento punto-punto verso il router dell'ISP. Si deve evitare di sprecare indirizzi IP assegnando maschere su misura.

**Richieste (in ordine di grandezza):**

1. **LAN A (Open Space):** Necessita di 100 indirizzi IP.

2. **LAN B (Amministrazione):** Necessita di 25 indirizzi IP.

3. **Link WAN (Verso ISP):** Necessita di soli 2 indirizzi IP per i router.

**Svolgimento:**

**Passo 1: LAN A (100 Host)**

- 2^h − 2 ≥ 100 → h=7.

- Mask: **/25** (`.128`).

- Block Size: 128.

- **Range:** `192.168.10.0` - `192.168.10.127`.

**Passo 2: LAN B (25 Host)**

- Start IP: È il successivo libero (`.128`).

- 2^h − 2 ≥ 25 → h=5.

- Mask: **/27** (`.224`).

- Block Size: 32.

- **Range:** `192.168.10.128` - `192.168.10.159` (perché 128+32=160, quindi finisce a 159).

**Passo 3: Link WAN (2 Host)**

- Start IP: È il successivo libero (`.160`).

- 2^h − 2 ≥ 2 → h=2.

- Mask: **/30** (`.252`).

- Block Size: 4.

- **Range:** `192.168.10.160` - `192.168.10.163`.

**Tabella Finale:**

| **Reparto** | **IP Rete** | **CIDR** | **IP Broadcast** |

| **LAN A** | 192.168.10.0 | /25 | 192.168.10.127 |

| **LAN B** | 192.168.10.128 | /27 | 192.168.10.159 |

| **Link** | 192.168.10.160 | /30 | 192.168.10.163 |

### Esercizio 2: Scenario Enterprise

**Scenario:** Una grande multinazionale possiede l'intera rete di Classe A `10.0.0.0/8`. Deve assegnare blocchi di indirizzi alle varie sedi regionali. Per evitare la frammentazione, si vuole assegnare blocchi contigui. Si inizia assegnando gli indirizzi alla **Sede Centrale** (molto grande) e poi a una **Filiale** secondaria.

**Richieste:**

1. **Sede Centrale:** 4000 Host

2. **Filiale:** 500 Host

**Svolgimento:**

**Passo 1: Sede Centrale (4000 Host)**

- 2^h − 2 ≥ 4000.
  
  - 2¹¹ = 2048 (No).
  
  - 2¹² = 4096 (Ok). **h=12**.

- Mask: **/20** (32 − 12 = 20).

- Mask decimale: `/20` copre tutto il secondo ottetto (8+8+4). Nel terzo ottetto abbiamo 4 bit di rete (11110000₂ = 240).

- Magic Number (terzo ottetto): 256 − 240 = 16.

- **Rete:** `10.0.0.0/20`.

- **Next IP:** `10.0.16.0`. (Il range è 10.0.0.0 - 10.0.15.255).

**Passo 2: Filiale (500 Host)**

- Start IP: `10.0.16.0`.

- 2^h − 2 ≥ 500 → h=9.

- Mask: **/23** (32 − 9 = 23).

- Mask decimale: `/23` (terzo ottetto 11111110₂ = 254).

- Magic Number (terzo ottetto): 256 − 254 = 2.

- **Rete:** `10.0.16.0/23`.

- **Next IP:** `10.0.18.0`.

**Tabella Finale:**

| **Sede** | **IP Rete** | **CIDR** | **Range Host** |

| **Centrale** | 10.0.0.0 | /20 | 10.0.0.1 - 10.0.15.254 |

| **Filiale** | 10.0.16.0 | /23 | 10.0.16.1 - 10.0.17.254 |

<div class="page-break"></div>

## 3. CIDR e SUPERNETTING (Aggregazione)

**Acronimo:** Classless Inter-Domain Routing.

### Quando si usa (Caso d'Uso)

Si utilizza per **aggregare** (riassumere) più reti contigue in un'unica voce nella tabella di routing. Questo processo è detto **Route Summarization** o Supernetting.

- **Scenario tipico:** Un router ISP o un router Core che deve raggiungere 4 sottoreti diverse (es. filiali) connesse a un router a valle. Invece di memorizzare 4 righe nella tabella di routing, ne memorizza 1 sola (la Supernet) che le include tutte.

- **Vantaggio:** Riduce l'uso di CPU e memoria dei router e velocizza il routing.

### Esercizio 1: Aggregazione di Classe C

**Scenario:** Un router di distribuzione deve instradare il traffico verso 4 VLAN adiacenti. Attualmente, deve annunciare 4 rotte separate ai router vicini, sprecando banda e risorse di elaborazione. Le reti da annunciare sono: `192.168.0.0/24`, `192.168.1.0/24`, `192.168.2.0/24`, `192.168.3.0/24`.

**Obiettivo:** Calcolare un'unica rotta aggregata (Supernet) che includa tutte e 4 le reti, da inserire nella tabella di routing al posto delle singole rotte.

**Svolgimento:**

1. **Verifica Contiguità:** Le reti sono consecutive (0, 1, 2, 3).

2. **Conversione Binaria (Terzo Ottetto):**
   
   - .0 = `00000000`
   
   - .1 = `00000001`
   
   - .2 = `00000010`
   
   - .3 = `00000011`

3. **Trovare i bit comuni:** Guardando da sinistra, i primi **6 bit** sono identici (`000000`) per tutte le reti. Gli ultimi 2 bit cambiano.

4. **Calcolo Nuova Maschera:**
   
   - La maschera originale era /24 (8 bit nel terzo ottetto).
   
   - Abbiamo trovato solo 6 bit comuni nel terzo ottetto.
   
   - Nuova Mask = **/22** (16 primi due ottetti + 6 = 22).

5. **Risultato:** `192.168.0.0/22`.

**Tabella Riassuntiva:**

| **Reti Originali** | **Route Aggregata (Supernet)** | **Maschera Decimale** |

| 192.168.0.0 - 3.0 (/24) | **192.168.0.0/22** | 255.255.252.0 |

### Esercizio 2: Aggregazione Intermedia

**Scenario:** Un router Core di un ISP (Internet Service Provider) sta ricevendo annunci di routing da un cliente business. Il cliente possiede un blocco continuo di 16 reti di Classe C, che vanno da `172.16.128.0/24` fino a `172.16.143.0/24`. Attualmente, la tabella di routing del Core Router contiene **16 righe separate**, una per ogni rete del cliente. Questo è inefficiente.

**Obiettivo:** Semplificare la tabella di routing trovando la "Summary Route" (Supernet) più efficiente: una singola riga che copra esattamente l'intervallo dalla .128 alla .143, senza includere reti estranee.

**Svolgimento:**

1. **Analisi Range:** Le reti vanno da .128 a .143.

2. **Conteggio Reti:** Da 128 a 143 ci sono **16 reti** (143 − 128 + 1 = 16).

3. **Calcolo Bit:** 16 è una potenza di 2 (2⁴). Significa che stiamo aggregando un blocco di 4 bit.

4. **Sottrazione Maschera:** Stiamo "tornando indietro" di 4 bit rispetto alla maschera originale (/24).
   
   - Nuova Mask = **/20** (24 − 4 = 20).

5. **Verifica Binaria (Terzo Ottetto):**
   
   - 128 = `10000000`
   
   - 143 = `10001111`
   
   - I primi 4 bit (`1000`) sono uguali per tutte le reti nel range. 16 + 4 = 20.

6. **Risultato:** `172.16.128.0/20`.

**Tabella Riassuntiva:**

| **Range Terzo Ottetto** | **Bit Comuni** | **Route Aggregata** |

| 128 - 143 | 4 bit (`1000`) | **172.16.128.0/20** |
