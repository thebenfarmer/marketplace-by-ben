---
name: feierabend
description: Schliesst eine Arbeits-Session ab - Inbox einsortieren, Tagesnotiz schreiben, Erkenntnisse ablegen, Pruefskripte laufen lassen. Nutze bei "Feierabend" oder wenn eine Arbeitsrunde endet.
---

# Feierabend: die Session sauber abschließen

## Worum es geht

Am Ende einer Session liegt das Ergebnis verteilt herum: im Chatverlauf, im Kopf, in der
Inbox. Was jetzt nicht an seinen Ort kommt, ist morgen weg.

Dieser Skill arbeitet fünf Punkte ab und fragt genau einmal — am Schluss.

## Ablauf

### 1. Inbox leeren

`inbox/brain-dump.md` lesen. Jeden Eintrag an seinen Ort bringen:

- Vorhaben mit Enddatum -> `projekte/` (Vorlage `_templates/projekt.md`)
- Etwas Entschiedenes -> `entscheidungen/` im passenden Ordner
- Halbe Gedanken ohne Messgröße -> `ideen/`
- Nachschlage-Wissen -> `ressourcen/`
- Etwas über die eigene Person oder Arbeitsweise -> die passende Seite in `kontext/`

Danach steht unter dem Trennstrich nur noch `_Leer._`.

Passt ein Eintrag nirgends, bleibt er liegen und wird am Schluss genannt. Lieber ein
Eintrag in der Inbox als eine Notiz am falschen Ort.

### 2. Tagesnotiz schreiben

`tagesnotizen/<JJJJ-MM-TT>.md`, angelegt aus `_templates/tagesnotiz.md`. Drei
Abschnitte: "Geschafft", "Erkenntnisse / Entscheidungen", "Offen / nächste Schritte".

- **Erledigtes gehört unter "Geschafft", nicht unter "Offen".** Klingt trivial, ist es
  nicht: Was fälschlich unter "Offen" steht, taucht morgen wieder als Aufgabe auf.
- Was der Mensch nebenbei erzählt hat — bezahlt, abgesagt, entschieden, angemeldet —
  gehört hier hinein, mit dem Datum seiner Aussage. Es hinterlässt sonst keine Spur.
- Nicht als erledigt ausgeben, was nur berichtet wurde.

### 3. Erkenntnisse an ihren Ort

Eine Erkenntnis geht an **genau einen** Ort:

| Art | Ort |
|---|---|
| Ein Ergebnis: Entscheidung, Experiment, Messwert | `entscheidungen/`, `experimente/`, `messwerte/` |
| Eine Regel, die sich daraus verdichtet | die Lektionen-Seite des Bereichs |
| Eine Vorliebe oder Eigenart des Menschen | die passende Seite in `kontext/` |
| Eine Regel, wie im Vault gearbeitet wird | `CLAUDE.md` |

Nie an zwei Orte. Zwei Fassungen derselben Regel bedeuten, dass eine davon unbemerkt
veraltet.

### 4. Prüfen

```bash
python3 bin/vault-check.py
python3 bin/index-bauen.py
```

Befunde des Vault-Checks, die sich mechanisch beheben lassen (fehlendes Pflichtfeld,
falscher Ordner, Platzhalter), direkt beheben. Was Urteil braucht, wird berichtet.

### 5. Berichten

Kurzer Abschluss in vier Zeilen: was geschrieben wurde, was noch in der Inbox liegt,
welche Befunde offen sind, was morgen ansteht.

## Der eine Interaktionspunkt

Punkt 1 bis 4 werden **ausgeführt** — sie sind stehende Praxis und keine Rückfrage wert.
Punkt 5 wird **berichtet**. Am Schluss steht genau eine Frage, die alles Offene bündelt.

Nicht fünfmal nachfragen.

## Häufige Fehler

| Fehler | Warum er weh tut |
|---|---|
| Erledigtes unter "Offen" einsortieren | Taucht morgen wieder als Aufgabe auf. |
| "Erledigt" für etwas, das nur berichtet wurde | Nicht als geprüft ausgeben, was ungeprüft ist. |
| Erkenntnis an zwei Orten ablegen | Zwei Wahrheiten, eine davon veraltet still. |
| Inbox-Eintrag notfalls irgendwo ablegen | Eine Notiz am falschen Ort ist schlechter als ein Eintrag, der liegen bleibt. |
| `index.md` von Hand ändern | Wird vom Skript überschrieben. |
