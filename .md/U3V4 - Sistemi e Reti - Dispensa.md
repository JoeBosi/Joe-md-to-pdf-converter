# U3 VOLUME 4 - NETWORK LAYER

## LEZIONE 1 - Il Livello Network e il Protocollo IP

### 1. Funzioni e Tipologia di Servizio

Nello stack TCP/IP, il **Livello Network** ricopre il ruolo fondamentale di trasferire i pacchetti da un host mittente a un host destinatario, attraversando reti complesse ed eterogenee. Per garantire questo servizio, il livello si appoggia a due funzioni chiave che operano su piani distinti:

- **Forwarding (Inoltro):** È un'attività locale svolta dal router nel cosiddetto *Data Plane*. Quando un pacchetto arriva su una linea di ingresso, il router deve decidere istantaneamente su quale linea di uscita trasferirlo per farlo avanzare verso la destinazione.
- **Routing (Instradamento):** È un'attività globale di pianificazione svolta nel *Control Plane*. Attraverso specifici algoritmi, la rete determina il percorso completo che i pacchetti devono seguire, gestendo percorsi alternativi in caso di guasti o congestione.

È importante sottolineare che, in linea teorica, il Livello Network può offrire due tipi di servizio:

1. **Connection-oriented (Connesso):** Basato su "circuiti virtuali", dove viene stabilita una connessione stabile prima della trasmissione (tipico delle vecchie reti telefoniche, X.25 o ATM).
2. **Connectionless (Non connesso):** Dove ogni pacchetto viene trattato individualmente senza preamboli. **Questo è il modello adottato da Internet e dal protocollo IP**, che scambia dati (chiamati *datagram*) senza handshake iniziale.

### 2. Il Protocollo IP (Internet Protocol)

L'**Internet Protocol (IP)**, definito nella RFC 791, è un protocollo **Best Effort**: fa il "massimo sforzo" per consegnare i dati, ma non garantisce l'ordine di arrivo, l'integrità del payload o la consegna stessa (garanzie delegate al livello superiore, come il TCP).

### 3. L'Header IPv4: Struttura e Logica dei Campi

<img src="assets/2026-01-21-15-06-34-image.png" title="" alt="" width="332">

Il protocollo incapsula i dati in un **header** (intestazione) che contiene tutte le informazioni di controllo. Di seguito sono analizzati i campi dell'header, rispondendo implicitamente ai quesiti fondamentali sulla struttura del pacchetto.

#### Gestione delle Dimensioni

L'header IP ha una dimensione variabile a causa della possibile presenza di campi opzionali.

- **Lunghezza Minima:** Se non ci sono opzioni, l'header ha una lunghezza minima di **20 byte**.
- **Perché due campi di lunghezza?** Nell'header sono presenti due campi distinti per gestire correttamente la lettura del pacchetto:
  1. **HLEN (Header Length):** Indica quanto è lungo *solo l'header*, espresso in parole da 32 bit (word). Serve al ricevente per capire dove finisce l'intestazione e dove iniziano i dati.
  2. **Total Length:** Indica la dimensione totale del datagramma (*header + payload*), che può arrivare fino a 65.535 byte.

#### Il Meccanismo della Frammentazione

Quando un datagramma deve attraversare una rete fisica con un limite di dimensione dei pacchetti (MTU) inferiore alla propria, deve essere diviso in pezzi più piccoli. Questo processo è gestito tramite tre campi:

1. **Identification (ID):** Un numero univoco assegnato al datagramma originale che viene copiato su tutti i frammenti, permettendo al destinatario di riconoscerli come parte dello stesso pacchetto.
2. **Flags:** 3 bit di controllo, tra cui il bit **DF** (Don't Fragment - se impostato a 1 vieta la frammentazione) e il bit **MF** (More Fragments - se impostato a 1 indica che seguono altri frammenti).
3. **Fragment Offset:** Indica la posizione esatta del frammento rispetto all'inizio del datagramma originale (in gruppi di 8 byte), consentendo il riassemblaggio corretto anche se i frammenti arrivano disordinati.

#### Controllo del Ciclo di Vita (TTL)

Per evitare che i pacchetti circolino all'infinito nella rete a causa di errori di instradamento (loop), si utilizza il campo **TTL (Time To Live)**.

- **Come viene usato:** È un contatore inizializzato dal mittente. Ogni volta che il pacchetto attraversa un router, il valore viene decrementato di 1. Se il TTL raggiunge lo 0, il pacchetto viene scartato e il router invia solitamente un messaggio di errore al mittente.

#### Interfaccia con il Livello Superiore (Protocol)

Il livello Network deve sapere a chi consegnare il contenuto del pacchetto una volta arrivato a destinazione.

- **Campo Protocol:** Contiene un numero compreso tra 0 e 255 che identifica il protocollo di livello superiore (Trasporto). Ad esempio, il valore **6** indica TCP, il **17** indica UDP e l'**1** indica ICMP. Questo permette il demultiplexing del pacchetto verso il servizio corretto.

#### Opzioni, Allineamento e Integrità

- **Header Checksum:** Un codice di controllo per verificare l'integrità del *solo header*. Poiché il TTL cambia a ogni salto, il checksum deve essere ricalcolato da ogni router.
- **Options (Campi Opzionali):** Utilizzati per funzioni di controllo, debug o misurazione. Ogni opzione è strutturata in tre sottocampi:
  1. *Copy Flag:* (1 bit) Indica se l'opzione va copiata nei frammenti.
  2. *Option Class:* (2 bit) La categoria dell'opzione (es. controllo).
  3. *Option Number:* (5 bit) Il tipo specifico di opzione.
- **Padding:** Poiché l'header deve avere una lunghezza sempre multipla di 32 bit (per via del campo HLEN), il campo Padding aggiunge bit riempitivi (fittizi) alla fine dell'header per garantire il corretto allineamento se le opzioni non riempiono perfettamente la parola.

Ecco il sunto rielaborato della **Lezione 2**, organizzato per fornire una spiegazione chiara e logica della struttura degli indirizzi IP, includendo le risposte ai quesiti di verifica di pagina 116 e integrando esempi pratici svolti.

---

## LEZIONE 2 - La Struttura degli Indirizzi IP

### 1. Definizione e Formato dell'Indirizzo IPv4

Il protocollo IP fornisce l'indirizzamento logico necessario per identificare univocamente un host all'interno di una rete. È fondamentale comprendere che un indirizzo IP non identifica la macchina fisica in sé, ma la sua **interfaccia di rete**. Un dispositivo con più interfacce (come un router o un PC con scheda Wi-Fi ed Ethernet) avrà un indirizzo IP distinto per ciascuna di esse.

Un indirizzo IPv4 è costituito da **32 bit**, solitamente rappresentati nella **notazione decimale puntata** (dotted-decimal notation). I 32 bit sono divisi in 4 gruppi da 8 bit (ottetti), separati da un punto. Ogni ottetto viene convertito in un numero decimale compreso tra 0 e 255.

> **Struttura Logica:** Ogni indirizzo IP è diviso gerarchicamente in due parti:
> 
> - **NetID (Network ID):** Identifica la rete a cui appartiene l'host.
> - **HostID:** Identifica lo specifico host all'interno di quella rete.

### 2. Le Classi di Indirizzi (Classful Addressing)

Per gestire reti di diverse dimensioni, gli indirizzi IP sono stati organizzati storicamente in **5 classi** (A, B, C, D, E). L'appartenenza a una classe è determinata dal valore dei bit più significativi del primo ottetto.

#### Classe A: Grandi Reti

Progettata per un numero ridotto di reti molto grandi.

- **Identificazione:** Il primo bit è sempre **0**.
- **Range primo ottetto:** da **0 a 127**.
- **Struttura:** Il primo ottetto è il NetID, gli altri tre sono l'HostID (Formato: `N.H.H.H`).
- **Calcolo delle Reti:** I bit dedicati alla rete sono 7 (il primo è fisso a 0). Il numero di reti possibili è 2⁷ − 2 = 126.
  - *Giustificazione del "-2":* La rete 0.0.0.0 è riservata (default route) e la rete 127.0.0.0 è riservata per il loopback.
- **Calcolo degli Host:** I bit dedicati agli host sono 24. Il numero di host per rete è 2²⁴ − 2 = 16.777.214.
  - *Giustificazione del "-2":* In ogni rete, l'indirizzo con tutti i bit di host a 0 (indirizzo di rete) e quello con tutti i bit di host a 1 (broadcast) non possono essere assegnati a un dispositivo.

#### Classe B: Reti di Medie Dimensioni

- **Identificazione:** I primi due bit sono **10**.
- **Range primo ottetto:** da **128 a 191**.
- **Struttura:** I primi due ottetti sono il NetID, gli altri due sono l'HostID (Formato: `N.N.H.H`).
- **Calcolo delle Reti:** I bit dedicati alla rete sono 14 (16 − 2 fissi). Reti possibili: 2¹⁴ = 16.384.
- **Calcolo degli Host:** I bit dedicati agli host sono 16. Host per rete: 2¹⁶ − 2 = 65.534.

#### Classe C: Piccole Reti (LAN)

- **Identificazione:** I primi tre bit sono **110**.
- **Range primo ottetto:** da **192 a 223**.
- **Struttura:** I primi tre ottetti sono il NetID, l'ultimo è l'HostID (Formato: `N.N.N.H`).
- **Calcolo delle Reti:** I bit dedicati alla rete sono 21 (24 − 3 fissi). Reti possibili: 2²¹ = 2.097.152
- **Calcolo degli Host:** I bit dedicati agli host sono solo 8. Host per rete: 2⁸ − 2 = 254.

#### Altre Classi

- **Classe D (224-239):** Riservata al **Multicasting** (indirizzare gruppi di host). Non assegnabile a singoli host.
- **Classe E (240-255):** Riservata per scopi sperimentali o usi futuri.

### 3. Indirizzi Riservati e Speciali

Esistono indirizzi che hanno funzioni specifiche e non possono essere assegnati liberamente agli host:

1. **Indirizzo di Rete:** Ha tutti i bit dell'HostID impostati a **0**. Serve a identificare la rete stessa e viene usato dai router nelle tabelle di instradamento.
2. **Indirizzo di Broadcast:** Ha tutti i bit dell'HostID impostati a **1** (es. 255 nel caso di una classe C standard). Serve per inviare pacchetti a *tutti* gli host di quella specifica rete.
3. **Loopback (Localhost):** L'intero blocco **127.0.0.0/8** è riservato. Solitamente si usa **127.0.0.1**. Serve per testare lo stack TCP/IP locale: un pacchetto inviato a questo indirizzo non lascia mai il computer ma "torna indietro".
4. **APIPA (Automatic Private IP Addressing):** Il range **169.254.x.x**. Viene auto-assegnato dal sistema operativo quando un host configurato per ottenere l'IP automaticamente non riesce a contattare un server DHCP.

### 4. Tipologie di Indirizzi IP

Gli indirizzi possono essere categorizzati in base alla visibilità (Pubblici/Privati) e alla modalità di assegnazione (Statici/Dinamici).

#### Indirizzi Pubblici vs Privati

- **Indirizzi Pubblici:** Sono univoci a livello mondiale e sono necessari per navigare su Internet. Sono assegnati dall'autorità internazionale ICANN (tramite i registri regionali RIR) agli ISP e alle organizzazioni.
- **Indirizzi Privati:** Definiti nella **RFC 1918**, non sono instradabili su Internet (non sono raggiungibili dall'esterno). Servono per creare reti locali (LAN) senza consumare indirizzi pubblici. Per accedere a Internet, una rete privata usa un router con funzionalità **NAT** (Network Address Translation) che "maschera" gli IP privati dietro un unico IP pubblico.
  - *Range Privato Classe A:* 10.0.0.0 – 10.255.255.255
  - *Range Privato Classe B:* 172.16.0.0 – 172.31.255.255
  - *Range Privato Classe C:* 192.168.0.0 – 192.168.255.255

#### Indirizzi Statici vs Dinamici

- **Statici:** L'indirizzo viene configurato manualmente dall'amministratore di rete sul dispositivo. Non cambia nel tempo. È ideale per server, stampanti di rete o router che devono essere sempre reperibili allo stesso indirizzo.
- **Dinamici:** L'indirizzo viene assegnato automaticamente da un server **DHCP** (Dynamic Host Configuration Protocol) quando il dispositivo si collega alla rete. L'indirizzo può cambiare a ogni connessione. È la modalità standard per i PC client, smartphone e tablet per semplificare la gestione.

---

### 5. Esempi Pratici e Risoluzione Problemi

Per padroneggiare gli indirizzi IP è necessario saperli analizzare convertendoli in binario (o mentalmente) per individuarne le componenti.

#### Esempio 1: Analisi completa di un indirizzo

**Problema:** Dato l'indirizzo IP **130.10.67.160**, determinare:

1. La classe di appartenenza.
2. L'indirizzo di rete.
3. L'indirizzo di broadcast.
4. L'HostID.

**Svolgimento Spiegato:**

1. **Classe:** Osserviamo il primo ottetto: **130**. Poiché rientra nel range 128-191, è un indirizzo di **Classe B**.
   - *Verifica binaria:* 130₁₀ = 10000010₂. Inizia con i bit `10`, confermando la Classe B.
2. **Indirizzo di Rete:** In Classe B, i primi 2 ottetti sono la rete (NetID) e gli ultimi 2 sono l'host (HostID).
   - Per trovare l'indirizzo di rete, poniamo tutti i bit di host a **0**.
   - NetID (invariato): 130.10
   - HostID (azzerato): 0.0
   - Risultato: **130.10.0.0**
3. **Indirizzo di Broadcast:** Si ottiene ponendo tutti i bit di host a **1** (che in decimale corrisponde a 255 per ottetto).
   - NetID (invariato): 130.10
   - HostID (tutti a 1): 255.255
   - Risultato: **130.10.255.255**
4. **HostID:** È la parte dell'indirizzo dedicata all'host.
   - Risultato: **67.160** (corrispondente agli ultimi due ottetti).

#### Esempio 2: Verifica validità indirizzo host

**Problema:** Indicare se i seguenti indirizzi possono essere assegnati a un PC (Host) e giustificare la risposta.

- A) 192.168.1.255
- B) 10.0.0.5
- C) 127.0.0.1
- D) 150.10.0.0

**Svolgimento Spiegato:**

- **A) 192.168.1.255:** **NO**. È un indirizzo di Classe C (range 192-223). In Classe C l'HostID è l'ultimo ottetto. Qui l'ultimo ottetto è 255 (tutti bit a 1), quindi è l'**indirizzo di Broadcast** della rete 192.168.1.0.
- **B) 10.0.0.5:** **SÌ**. È un indirizzo di Classe A privato. L'HostID non è né tutto 0 né tutto 1.
- **C) 127.0.0.1:** **NO**. È riservato per il **Loopback** locale, non si assegna a un'interfaccia di rete fisica per comunicare in rete.
- **D) 150.10.0.0:** **NO**. È un indirizzo di Classe B (range 128-191). In Classe B l'HostID sono gli ultimi due ottetti. Qui sono `0.0`, quindi questo è l'**Indirizzo di Rete**, non utilizzabile per un singolo host.

---

## LEZIONE 3 - Pianificazione di Reti IP: Il Subnetting

### 1. Che cos'è il Subnetting

Il **Subnetting** è la tecnica che permette di suddividere una singola rete IP in più sottoreti logiche (chiamate *subnet*), collegate tra loro tramite router. Questa operazione è fondamentale per ottimizzare il traffico di rete, migliorare la sicurezza e organizzare meglio i dispositivi (ad esempio, separando i reparti di un'azienda).

**Come si realizza:** Il meccanismo si basa sul prendere in "prestito" alcuni bit dalla parte dell'indirizzo destinata all'host (**HostID**) per assegnarli alla rete. In questo modo, l'indirizzo IP non è più diviso solo in due parti (NetID + HostID), ma in tre:

1. **NetID:** L'identificativo della rete originale.
2. **SubnetID:** I bit sottratti all'HostID per identificare la specifica sottorete.
3. **HostID:** I bit rimanenti per identificare i dispositivi.

### 2. Calcolo dei Bit e Dimensionamento

Per pianificare correttamente il subnetting, è necessario bilanciare il numero di sottoreti desiderate con il numero di host necessari per ciascuna di esse.

#### Calcolo delle Subnet

Per ottenere un certo numero di sottoreti (*N*), dobbiamo determinare quanti bit (*n*) sottrarre all'HostID. La formula da soddisfare è:

**2^n ≥ N** — Dove *n* è il numero di bit da dedicare al **SubnetID**. *Esempio: Se servono 5 subnet, non bastano 2 bit (2²=4), ne servono 3 (2³=8).*

#### Calcolo degli Host

Una volta definiti i bit per le subnet, i bit rimanenti (*h*) costituiscono il nuovo HostID. Il numero di host disponibili per ogni subnet si calcola con la formula:

**2^h − 2** **Perché il −2?** Anche nelle sottoreti, il primo indirizzo (tutti i bit di host a 0) identifica la **rete stessa** e l'ultimo (tutti i bit di host a 1) è l'indirizzo di **broadcast**. Questi non possono essere assegnati ai dispositivi.

### 3. La Subnet Mask

La **Subnet Mask** (maschera di sottorete) è una sequenza di 32 bit che serve a indicare al protocollo IP quali bit dell'indirizzo appartengono alla rete (NetID + SubnetID) e quali all'host.

- I bit di rete sono impostati a **1**.
- I bit di host sono impostati a **0**.

#### Maschere di Default e Slash Notation

Se non viene applicato il subnetting (indirizzamento *classful*), si usano le maschere predefinite:

- **Classe A:** 255.0.0.0 (o /8)
- **Classe B:** 255.255.0.0 (o /16)
- **Classe C:** 255.255.255.0 (o /24)

Quando si fa subnetting, la maschera cambia. Si utilizza spesso la **Slash Notation** (es. /26), che indica semplicemente il numero totale di bit a 1 nella maschera (Prefix Length).

### 4. Il Processo di "Messa in AND"

Il processo di messa in AND è il meccanismo fondamentale con cui un dispositivo determina a quale rete o sottorete appartiene un indirizzo IP.

**Come funziona:** Si esegue un'operazione logica **AND bit a bit** tra l'indirizzo IP e la Subnet Mask.

- **Regola dell'AND:** Se entrambi i bit sono 1, il risultato è 1. In tutti gli altri casi (1-0, 0-1, 0-0), il risultato è 0.
- In pratica, i bit dell'IP corrispondenti agli "1" della maschera vengono mantenuti (copiati), mentre quelli corrispondenti agli "0" vengono azzerati.

**A cosa serve:** Il risultato dell'operazione è l'**Indirizzo di Rete (NetID)**. Questo permette a un host mittente di capire se il destinatario si trova nella sua stessa rete locale (comunicazione diretta) o su una rete diversa (necessità di inviare i dati al router/gateway).

---

### 5. Esempi Pratici e Svolgimento

#### Esempio 1: Creazione di Subnet (Dall'IP alla Maschera)

**Problema:** Hai l'indirizzo di Classe C **192.168.1.0** e devi creare **4 sottoreti**. Determina la maschera necessaria e il numero di host per subnet.

**Svolgimento:**

1. **Calcolo bit per le subnet:** Servono 4 subnet.
   Formula: 2^n ≥ 4.
   Con *n* = 2 bit, otteniamo esattamente 4 combinazioni (00, 01, 10, 11).
   Quindi prendiamo in prestito **2 bit**.
2. **Calcolo della nuova Maschera:** Maschera base Classe C: /24 (24 bit a 1).
   Nuova maschera: 24 + 2 = 26 bit a 1.
   In binario (ultimo ottetto): `11000000`.
   In decimale: 128 + 64 = 192. **Subnet Mask:** 255.255.255.192 (/26).
3. **Calcolo Host:**    Bit rimanenti per host = 8 (totali nell'ottetto) − 2 (usati) = 6.
   Host utili = 2⁶ − 2 = 64 − 2 = **62** **host per subnet**.

#### Esempio 2: Messa in AND (Dall'IP alla Rete)

**Problema:** Un host ha indirizzo IP **130.10.67.160** e Subnet Mask **255.255.192.0**. A quale sottorete appartiene?

**Svolgimento:** L'indirizzo è di Classe B. La maschera standard sarebbe 255.255.0.0.
La maschera attuale ha 192 nel terzo ottetto.
Convertiamo in binario solo la parte interessante (il terzo ottetto, dove avviene il taglio):

- **IP (terzo ottetto - 67):** `01000011`
- **Mask (terzo ottetto - 192):** `11000000`

Eseguiamo l'AND colonna per colonna:

```
  01000011 (IP: 67)
AND
  11000000 (Mask: 192)
  --------
  01000000
```

Il risultato binario `01000000` corrisponde al decimale **64**.
I primi due ottetti (130.10) passano invariati perché la maschera è 255 (tutti 1). L'ultimo ottetto viene azzerato perché la maschera è 0.

**Risultato:** L'host appartiene alla sottorete **130.10.64.0**.

---

## LEZIONE 4 - Esempi di Piani di Indirizzamento IP e Calcolo delle Subnet

Mentre le lezioni precedenti si sono concentrate sulla teoria dell'indirizzamento e del subnetting, la Lezione 4 applica questi concetti alla realtà, illustrando come progettare un piano di indirizzamento efficiente e come calcolare l'appartenenza di un host a una specifica sottorete.

### 1. Metodologia di Progettazione di un Piano di Indirizzamento

Quando un amministratore di rete deve configurare una LAN complessa, non assegna gli indirizzi a caso. Deve seguire una procedura strutturata per garantire scalabilità e ordine.

**I passi fondamentali per realizzare un piano di indirizzamento sono:**

1. **Analisi dei requisiti:** Determinare quanti dipartimenti (sottoreti o subnet) sono necessari e quanti dispositivi (host) devono essere ospitati, al massimo, in ciascuna di esse.
2. **Scelta dell'indirizzo privato:** Scegliere un blocco di indirizzi privati (Classe A, B o C) adeguato alle dimensioni della rete.
3. **Calcolo del Subnetting:**
   - Valutare quanti bit sottrarre all'HostID per creare le subnet necessarie (usando la formula 2^n ≥ numero subnet).
   - Verificare che i bit rimanenti per l'HostID siano sufficienti per coprire il numero di dispositivi previsti (usando la formula 2^h − 2 ≥ numero host).
4. **Stesura del Piano:** Creare una tabella che elenchi per ogni subnet: Indirizzo di Rete, Range di indirizzi utili per gli host, Indirizzo di Broadcast.

### 2. Strategie di Indirizzamento: Il Caso della Classe B

Una situazione molto comune nella progettazione delle reti aziendali è l'utilizzo di un indirizzo privato di **Classe B** (es. 172.16.0.0) applicando però una maschera di sottorete tipica della Classe C (255.255.255.0 o /24).

**Perché questa scelta è conveniente?** Assegnare un intero ottetto alle subnet e un intero ottetto agli host semplifica drasticamente la gestione per l'amministratore umano:

- Il **terzo ottetto** identifica la sottorete (es. 172.16.**1**.0, 172.16.**2**.0).
- Il **quarto ottetto** identifica l'host (es. 172.16.1.**1**, 172.16.1.**50**).
  In questo modo, la lettura dell'indirizzo IP diventa intuitiva e non richiede calcoli binari complessi per capire a quale sottorete appartiene un dispositivo, mantenendo comunque un ampio spazio di indirizzamento (fino a 256 subnet da 254 host ciascuna).

### 3. Best Practices per l'Assegnazione degli Indirizzi

All'interno del range di indirizzi disponibili per una subnet, esistono convenzioni standard per decidere quali IP assegnare ai vari dispositivi:

- **Router (Default Gateway):** Di solito si assegna il **primo indirizzo utile** (es. .1) o, meno frequentemente, l'ultimo indirizzo utile (es. .254). Questo indirizzo deve essere configurato staticamente sull'interfaccia del router.
- **Server e Stampanti di Rete:** Si assegnano **indirizzi statici bassi**, subito dopo quello del router (es. dal .2 al .10 o .20). È fondamentale che i server abbiano un IP fisso per essere sempre raggiungibili dagli altri client.
- **Client (PC, Smartphone):** Si utilizzano gli indirizzi rimanenti nel range (es. dal .21 in poi). Solitamente questi vengono assegnati dinamicamente tramite **DHCP** per semplificare la configurazione.

---

### 4. Calcolo e Verifica: Individuare la Subnet di Appartenenza

Un compito tipico è determinare a quale sottorete appartiene un host conoscendo il suo IP e la Subnet Mask.

**L'operazione "Applicare la Maschera":** Quando si dice che "applichiamo la maschera" a un indirizzo IP, si intende che il computer (o l'amministratore) esegue un'operazione di **AND logico bit a bit** tra l'indirizzo IP dell'host e la Subnet Mask.

- Dove la maschera ha un bit **1**, il bit dell'IP viene mantenuto (copiato).
- Dove la maschera ha un bit **0**, il bit dell'IP viene azzerato.
  Il risultato di questa operazione è il **NetID (Indirizzo di Rete)** della sottorete a cui l'host appartiene.

### Esempio Pratico Guidato 1: Analisi di una Subnet

**Problema:** Dato l'indirizzo IP **192.198.1.75** e la subnet mask **255.255.255.240**, determinare a quale subnet appartiene l'host e qual è il suo numero d'ordine all'interno della subnet.

**Svolgimento Spiegato:**

1. **Analisi della Maschera:** La maschera è /28 (24 bit standard + 4 bit nell'ultimo ottetto).
   L'ultimo ottetto della maschera è 240. In binario: `11110000`.
   Questo ci dice che i primi 4 bit dell'ultimo ottetto sono usati per la subnet, e gli ultimi 4 per l'host.

2. **Calcolo delle combinazioni:** Con 4 bit di host, ogni subnet ha 2⁴ = 16 indirizzi totali.
   Quindi le subnet avanzano di 16 in 16:
   
   - Subnet 0: 192.198.1.0 – 192.198.1.15
   - Subnet 1: 192.198.1.16 – 192.198.1.31
   - ...
   - Subnet 4: 192.198.1.64 – 192.198.1.79

3. **Verifica dell'IP:** L'IP 192.198.1.75 cade nell'intervallo tra .64 e .79.
   Quindi l'indirizzo di rete è **192.198.1.64**.
   In alternativa, convertiamo l'ultimo ottetto dell'IP (75) in binario: `01001011`.
   Applichiamo l'AND con la maschera (240 -> `11110000`): `01001011` AND `11110000` = `01000000` (che in decimale è **64**).

**Risposta:** L'host appartiene alla **Subnet 4** (indirizzo di rete 192.198.1.64) ed è l'**11° host** utile della subnet (poiché 64 + 11 = 75).

---

#### Esempio Pratico Guidato 2: Calcolo Numero di Subnet

**Problema:** Dato l'indirizzo di rete **150.185.0.0** (Classe B) e la subnet mask **255.255.224.0**, quante sottoreti sono state create e quanti host può contenere ciascuna?

**Svolgimento Spiegato:**

1. **Analisi:** Indirizzo Classe B standard ha maschera di default 255.255.0.0 (/16).
   La maschera fornita è 255.255.**224**.0.
2. **Differenza Binaria:** Convertiamo il terzo ottetto della maschera (224) in binario: `11100000`.
   Rispetto alla maschera standard (/16), sono stati presi in "prestito" **3 bit** per il subnetting.
3. **Calcolo Subnet:** Con 3 bit si possono creare 2³ = 8 **sottoreti**.
4. **Calcolo Host:** I bit rimanenti per gli host sono 13 (5 nel terzo ottetto + 8 nel quarto ottetto).
   Numero di host per subnet = 2¹³ − 2 = 8192 − 2 = 8190 **host**.

---

## LEZIONE 5 - Pianificazione Avanzata di Reti IP: CIDR e VLSM

### 1. Oltre i Limiti del Subnetting Classico

Nelle lezioni precedenti abbiamo visto il "subnetting statico" (FLSM - Fixed Length Subnet Mask), dove una rete viene divisa in sottoreti tutte della stessa dimensione. Questo approccio, però, presenta due grandi limiti:

1. **Spreco di Indirizzi:** Se una filiale ha bisogno di 2 indirizzi e un'altra di 100, usare la stessa maschera per entrambe costringe a sprecare un'enorme quantità di IP nella filiale piccola.
2. **Rigidità:** Non è flessibile e non si adatta alla reale topologia della rete.

Per risolvere questi problemi e affrontare la carenza di indirizzi IPv4, negli anni '90 sono state introdotte due tecniche fondamentali: il **CIDR** e il **VLSM**.

### 2. CIDR e Supernetting

Il **CIDR (Classless Inter-Domain Routing)** è la tecnica che ha abolito il concetto rigido di "Classi" (A, B, C).

- **Caratteristica principale:** L'indirizzamento è definito **Classless** (senza classi). La maschera di sottorete non è più determinata dai primi bit dell'indirizzo IP, ma è definita esplicitamente tramite il **Prefix Length** (la notazione a "slash", es. /20).
- **Prefix Length:** Indica semplicemente il numero di bit impostati a 1 nella maschera di rete, ovvero la lunghezza del prefisso di rete.

#### Il Supernetting

Mentre il subnetting divide una rete grande in piccole, il **Supernetting** fa l'opposto: **aggrega** più reti contigue di piccole dimensioni in un'unica rete più grande (una "super-rete").

- **Scopo:** Ridurre la dimensione delle tabelle di routing nei router internet. Invece di memorizzare 4 rotte per 4 reti diverse, il router ne memorizza una sola che le comprende tutte.
- **Summary Route:** È l'indirizzo unico che viene pubblicizzato dal router per rappresentare questo blocco di reti aggregate.

```
DIAGRAMMA LOGICO DEL SUPERNETTING

Rete A: 192.168.0.0/24  \
Rete B: 192.168.1.0/24   |--->  Summary Route (Supernet)
Rete C: 192.168.2.0/24   |      192.168.0.0/22
Rete D: 192.168.3.0/24  /
```

### 3. VLSM (Variable Length Subnet Mask)

La tecnica **VLSM** permette di utilizzare **maschere di sottorete di lunghezza diversa** all'interno dello stesso piano di indirizzamento di rete.
A differenza del subnetting statico, con VLSM si crea una sottorete su misura per ogni segmento di rete, ottimizzando al massimo lo spazio di indirizzamento.

#### Regola Aurea: Dal più grande al più piccolo

Per pianificare correttamente con VLSM ed evitare sovrapposizioni di indirizzi, esiste una regola fondamentale: **si parte sempre dalla sottorete che richiede più host**, per poi scendere a quella che ne richiede meno.

#### Risposte ai quesiti fondamentali (Pag. 132)

Integrando i concetti sopra esposti, possiamo rispondere alle domande di verifica:

- **Caratteristica del CIDR:** Elimina le classi di indirizzi IP permettendo l'uso di maschere di qualsiasi lunghezza.
- **Supernetting:** È l'aggregazione di più reti contigue in un'unica rotta per semplificare il routing.
- **Summary Route:** È la rotta aggregata che rappresenta un gruppo di reti.
- **Prefix Length:** Rappresenta il numero di bit che compongono la parte di rete (NetID + SubnetID).
- **Limiti del subnetting statico:** Spreco di indirizzi IP e rigidità nella gestione di segmenti di rete con esigenze diverse.
- **Caratteristica VLSM:** Permette di usare subnet mask diverse nella stessa rete.
- **Applicazione VLSM:** Si applica partendo dalla subnet con **più host** (più grande) verso quella con meno host.
- **Duplicati:** Due host di due subnet diverse **non** possono avere lo stesso IP logico; ogni IP nella rete deve essere univoco.

---

### 4. Esempio Pratico di VLSM: Svolgimento Guidato

**Problema:** Hai a disposizione l'indirizzo di rete privato di Classe C **192.168.1.0/24**. Devi creare 3 sottoreti per tre dipartimenti con esigenze diverse:

- **N1 (Sviluppo):** 100 host.
- **N2 (Amministrazione):** 50 host.
- **N3 (Direzione):** 50 host.

**Nota:** Se usassimo il subnetting statico, per accomodare la rete più grande (100 host) servirebbero 7 bit di host (2⁷=128), lasciando solo 1 bit per le subnet (2¹=2). Non riusciremmo a creare 3 reti. **Dobbiamo usare VLSM.**

**Svolgimento:**

**PASSO 1: Soddisfare la rete più grande (N1 - 100 host)**

- Host richiesti: 100.
- Bit Host necessari: 2^h − 2 ≥ 100 → h=7 (2⁷ = 128 indirizzi).
- Nuova Maschera: **/25** (o 255.255.255.128).
- Range N1: La rete inizia a 192.168.1.0. Il blocco è di 128 indirizzi.
  - Rete: **192.168.1.0 /25**
  - Range Host: 192.168.1.1 - 192.168.1.126
  - Broadcast: 192.168.1.127
  - *Prossimo indirizzo libero:* 192.168.1.128

**PASSO 2: Soddisfare la seconda rete (N2 - 50 host)**

- Partiamo dall'indirizzo libero: 192.168.1.128.
- Host richiesti: 50.
- Bit Host necessari: 2^h − 2 ≥ 50 → h=6 (2⁶ = 64 indirizzi).
- Nuova Maschera: **/26** (o 255.255.255.192).
- Range N2: Il blocco è di 64 indirizzi.
  - Rete: **192.168.1.128 /26**
  - Range Host: 192.168.1.129 - 192.168.1.190
  - Broadcast: 192.168.1.191
  - *Prossimo indirizzo libero:* 192.168.1.192

**PASSO 3: Soddisfare la terza rete (N3 - 50 host)**

- Partiamo dall'indirizzo libero: 192.168.1.192.
- Host richiesti: 50.
- Bit Host necessari: come prima, *h*=6.
- Nuova Maschera: **/26**.
- Range N3: Il blocco è di 64 indirizzi.
  - Rete: **192.168.1.192 /26**
  - Range Host: 192.168.1.193 - 192.168.1.254
  - Broadcast: 192.168.1.255

**Schema Riassuntivo del Piano VLSM:**

```
| Subnet | Host Nec.| Bit Host | Maschera | Indirizzo Rete    | Range Utile Host          | Broadcast       |
|--------|----------|----------|----------|-------------------|---------------------------|-----------------|
| N1     | 100      | 7        | /25      | 192.168.1.0       | 192.168.1.1 - .126        | 192.168.1.127   |
| N2     | 50       | 6        | /26      | 192.168.1.128     | 192.168.1.129 - .190      | 192.168.1.191   |
| N3     | 50       | 6        | /26      | 192.168.1.192     | 192.168.1.193 - .254      | 192.168.1.255   |
```

In questo modo, abbiamo allocato tutte e tre le reti all'interno di un unico indirizzo di Classe C, cosa impossibile con il subnetting statico.
