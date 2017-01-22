Project: Proof Assistant for HoareLogic - HA
Author: Paolo Di Domenico , Universit� La Sapienza - Roma - didomenico.953026@studenti.uniroma1.it
For: Linguaggi di Programmazione, Prof. Cenciarelli, 23/01/2017

 This file is part of HA - Hoare logic proof Assistant.

    HA is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    HA is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with HA.  If not, see <http://www.gnu.org/licenses/>
	
*********************************************

Questo software � stato prodotto come progetto per un esame universitario,
� il primo apporccio dell'autore con il linguaggui SML e in generale con
i linguaggi funzionali. 
Lo stile e i risultati ottenuti ne sono ampliamente prova.
L'obiettivo del progetto era quello di creare un poof assistant scritto in SML
per assistere la validazine delle triple nella logica di Hoare.
Il progetto implementa solo le regole speciali, quelle relative ad ogni programma.

Gran parte dello sforzo nella produzione di questo progetto si � concentrata nei tentativi
di risconoscimento delle stringhe inserite dall'utente e nella loro trascrizione in tipi di dati
utilizzabili dal programma per l'analisi successiva.

Il progetto � diviso  in diversi file che rappresentano ognuno una struttura.
Il file ha.cm � il sorgente per compilare il programma ed utilizzarlo.
La struttura main (in Main.sml) utilizza tutte le altre strutture ed effettua materialmente la prima richiesta di input
e il parsing della triple inserita dall'utente.

Per l'avvio dell'applicazione � necessario invocare la funzione Run di questa struttura.

La prima struttura che viene utilizzata � TripleParser.sml. Questa struttura fa uso delle regular expression
per suddividere la triple inserita dall'utente nelle tre componenti: precondizione, programma e post condizione.
Per ragioni storiche (� stata la prima ad essere implementata) � stato mantenuto l'utilizzo delle regular expression.
Le altre strutture fanno uso di un pi� versatile sistema di parsing.
I punti deboli di questo sistema sono:
	a) Introduce la pesante struttura delle RegEx per scopi "poco nobili"
	b) Le RegEx utilizzate da sml e gi� implementate sono quelle della sintassi awk che mancano delle backreference (?)
	c) Obbliga il linguaggio utilizzato all'interno dei programmi a non utilizzare dei caratteri "preziosi" quali le "{" e le ","

La parte di tripla riconosciuta come programma viene poi parsata dalla struttura ProgramParser(.sml).
In questa struttura � rappresentata la grammatica del linguaggio utilizzabile.
E' stata presa la decisione di separare la struttura dei Programmi da quella delle Preposizioni (pre-e-post condizioni) per
rendere il sistema pi� versatile, mantenere separate le due strutture per� ha come inconveniente - dal punto di vista dello sviluppatore
quello di dover "tradurre" i termini dalla grammatica del linguaggio di programmazione a quella della logica per effettuare le operazioni
di trascrizione. In ogni caso, questo ulteriore passaggio, a parere dell'autore, illustra in modo pi� efficente il senso di queste riscritture.

La struttura che si occupa della traduzione di stringhe nella grammatica delle proposizioni � LogicParser(.sml)
struttura "gemella" a ProgramParser

Per finire, la logica delle triple Hoare e l'interazione con l'utente sono gestite attraverso la struttura
HoareLogic, che contiene il core del progetto. In questa struttura sono infatti implementate le regole delle triple ed � presente
la funzione "validate" che, prende in input una tripla gi� parsata (e registrata in un record) e risponde true al termine.
Questa funzione viene richiamata dalle funzioni che utilizzano le regole ricorsivamente, cos� che l'intero albero di derivazione della tripla
viene esplorato (creato) con una visit� in profodit� (DFS).

Diversi sono i punti deboli del programma e le strutture che potrebbero essere ampliate:
potrebbe tenere traccia dei risultati ottenuti e dare la possibilit� all'utente di fare bracktracking per tornare indietro sui propri passi.
potrebbe occuparsi di tutte le regole che ora sono disattivate, o almeno potrebbe dare la possibilit� all'utente si inserire manualmente
durante l'esecuzione del programma stesso nuove triple per portare avanti la regola globale.
Potrebbe gestire banalmente gli skip e un minimo di riconoscimento nella logica consentirebbe al programma di riconoscere triple "chiuse".

In ogni caso maggior cura � stata data alla creazione di un framework che rendesse pi� facile possibile la creazione
di queste funzionalit�. Sopra ogni cosa, si potrebbe sfruttare decisamente meglio la potenzialit� del lignuaggio SML al quale l'autore
si � appena approcciato. Sarebbe un campo di studi estramemente interessante il continuare a seguire questo progetto rendendolo pi� completo, pi�
rispondente allo stile funzionale e nel complesso pi� utile per eventuali utenti.
