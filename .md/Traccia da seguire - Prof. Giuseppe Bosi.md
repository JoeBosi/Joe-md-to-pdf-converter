ORGANIZZAZIONE DEL MANUALE TECNICO:

1 - Il network Layer: cosa è, a cosa serve, ecc..

1.1 - permette comunicazione host to host

1.2 - svolge funzioni di forwarding e di routing

1.3 - lavora con apparati come i router

1.4 - usa il protocollo di inoltro dei dati: IP

1.4.1 - questo è connectionless

1.4.2 - header del protocollo ip: regole generali, tabella con tutti i campi dell'header e loro spiegazioni, disegno del pacchetto e come è composto

1.4.3 - indirizzi logici (ip address) 

1.4.3.1 - sono assegnati da icann (iana) e regionali

1.4.3.2 - esiste la versione ipv6 ed ipv4

1.4.3.3 - ipv4

1.4.3.3.1 - è formato da 32 bit DEC  (4 ottetti) divisi in host id e net id

1.4.3.3.2 - Ci sono le classi.. come se riconoscono n° host n° di net

1.4.3.3.3 - Indirizzi speciali e riservati (e tecniche per trovarli)

1.4.3.3.4 - Indiirizzi privati (rfc) ed indirizzi pubblici

1.4.3.3.5 - ipv4 usa delle tecniche di indirizzamento

1.4.3.3.5.1 - tecniche di indirizzamento classful con uso di subnet mask

1.4.3.3.5.1.1 subnetting sttico

1.4.3.3.5.1.2 subnetting dinamico (VLSM)

1.4.3.3.5.2 - tecniche di indirizzamento classless

1.4.3.3.5.2 - uso del supernetting con CIDR

----

Concetti/keywords per me importanti ed immancabili che devono essere presenti, contestualizzati e spiegati:

- data plane e Control plane

- connection-oriented e connectionless

- Identification, flages, fragment offset (frammntazione e riassemblaggio con esempio disegnato), ttl, source ip destination ip, padding (perchè?)

- come si passa da un numero decimale a binario e viceversa

- DatO UN IP, saper TROVARE :IP DELLA RETE, il range di indirizzi, LA CLASSE DI APPARTENENZA, INDIRIZZO BROADCAST, quanti host ip ho disponibili

- SAPERE QUALI ONO GLI INDIRIZZI RISEVATI O SPECIALI (COMPRESO APIPA)

- RFC 1918 INDIRIZZI PRIVATI CONSIGLIATI  A B C

- Subnetting: dato il numero di subnet da realizzare ed il numero di indirizzi host per ogni subnet, progettare la rete.

- Cosa è la subnet mask e a cosa serve, cosa rappresenta ed indica. Cosa è la "MESSA IN AND", forwarding diretto e forwarding indiretto. 

- Dato un ip address e la su subnet mask, saper ricavare quante sottoreti sono state create e quanti indirizzi host sono disponbili per ogni sottorete. Saper dire un indirizzo ip appartenente alla stessa subnet, ed un indirizzo ip appartenente alla stessarete ma non alla stessa subnet. Indicare a aquale subnet appartiene e a quale host appartiene di quella subnet.

- Dato un indirizzo ip e sapendo in quante subnet è divisa la rete, saper determinare quale è il suo indirizzo di rete e qunti host può indirizzare la subnet. E quale è la sua subnetmask.

- Procedura per realizzare un piano di indirizzamento.

- Procedura per progettare una rete con subnet e regole e quone pratiche da rispettare (date le informazioni come pag 124)

- Cosa è il CIDR e come funziona il supernetting (spiegazione della tecnica di supernetting ed esempio pratico). E come mai si parla di netmask e non di subnet mask (spiegazione e differenza esempio)

- VLSM, definizione, spiegazione pratica della tecnica.

- VLSM: data una rete in una certa classe, e dato il numero di sottoreti e per ogni sottorete il numero minimo di host: procedura da seguire per saper realizzare il VLSM ed avere come output: Nome Rete, Indirizzo rete, Range indirizzi, subnet mask, ip broadcast. (tutto sia ain binario che in decimale). E come il router inoltra i pacchetti fra una subnet e l'altra.

- VLSM: Data una rete (per esempio WAN) formata da 3 router (per esempio tipo pag 131 132)  e delle specifiche sul numero di host per ogni subnet: procedura da seguire per saper realizzare il VLSM e progettare la rete






