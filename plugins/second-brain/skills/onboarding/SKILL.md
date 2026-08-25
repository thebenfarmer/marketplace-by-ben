---
name: onboarding
description: Richtet einen frischen Vault ein - kurzes Interview, fuellt daraus die kontext/-Seiten und legt den ersten Bereich an. Nutze bei "starte das Onboarding" oder wenn kontext/ noch Platzhalter enthaelt.
---

# Onboarding: einen frischen Vault einrichten

## Worum es geht

Ein leerer Vault ist wertlos, und die Seiten in `kontext/` füllt niemand freiwillig aus.
Sie sehen aus wie Formulare, und Formulare bleiben leer.

Dieser Skill dreht es um: Statt dass der Mensch Felder ausfüllt, führst du ein kurzes
Gespräch und schreibst die Seiten selbst.

Dauer: rund 15 Minuten. Am Ende ist der Vault benutzbar.

## Vor dem ersten Wort: Lage prüfen

### Welche Sorte Vault ist das?

Der Vault kommt in zwei Zuschnitten. Sieh nach, statt zu fragen:

| Prüfung | Zuschnitt | Was das heißt |
|---|---|---|
| `_templates/venture.md` existiert | **Ventures** | Für Selbstständige. Einkommensquellen liegen unter `bereiche/ventures/<name>/`, Bezugsfeld heißt `venture`, Übersichtsnotiz aus `venture.md` |
| Datei fehlt | **Bereiche** | Für Angestellte. Themen liegen unter `bereiche/<name>/`, Bezugsfeld heißt `bereich`, Übersichtsnotiz aus `bereich.md` |

Was dabei herauskommt, heißt unten **der Bezug**. Danach richten sich die Fragen 5 bis 7
und der Ordner, in dem der erste Bezug entsteht.

Ein Blick in `kontext/` bestätigt es: Liegen dort `angebot.md` und `icp.md`, ist es der
Ventures-Zuschnitt.

### Ist der Vault überhaupt frisch?

Lies `kontext/` und schau nach, ob dort noch Vorlagen-Platzhalter in spitzen Klammern
stehen.

- **Alles voller Platzhalter** -> frischer Vault, ganz durchlaufen.
- **Teilweise gefüllt** -> nur die offenen Seiten behandeln und das ansagen: "Drei deiner
  Seiten sind schon gefüllt, ich frage nur zu den anderen zwei."
- **Alles gefüllt** -> nicht durchlaufen. Sag, dass der Vault eingerichtet ist, und
  verweise auf "merk dir das" für einzelne Ergänzungen.

## Das Interview

**IMPORTANT — eine Frage nach der anderen.** Auf die Antwort warten, dann die nächste.
Alle acht auf einmal zu stellen ist der sicherste Weg, dass keine davon beantwortet wird.

Zu jeder Frage eine kurze Beispielantwort mitgeben. Sie zeigt den erwarteten Umfang und
nimmt die Scheu vor der leeren Zeile.

### Die Fragen

1. **Was ist deine Rolle — und was machst du tatsächlich den ganzen Tag?**
   (Die beiden sind selten dasselbe. Beides notieren.)
2. **Wobei bist du schnell, und wobei hättest du gern Unterstützung?**
   (Die zweite Hälfte ist die nützlichere. Nicht überspringen.)
3. **Wie willst du Antworten haben: knapp oder ausführlich? Lieber Optionen oder eine
   Empfehlung?**
4. **Wie sollen deine Texte klingen — und was geht bei dir gar nicht?**
   (Nach einem echten No-Go fragen. "Keine Ausrufezeichen" ist wertvoller als "freundlich".)

Fragen 5 bis 7 hängen am Zuschnitt.

**Zuschnitt Bereiche:**

5. **Wer ist in deinem Team, und wer entscheidet worüber?** (Namen oder Rollen)
6. **Womit arbeitet ihr — Projektwerkzeug, Chat, Ablage?**
7. **Was muss dieses Quartal gelingen, damit du zufrieden bist?**
   (Wenn möglich mit Zahl und Datum. Wenn nicht, so aufschreiben, wie es gesagt wurde.)

**Zuschnitt Ventures:**

5. **Was verkaufst du, an wen, und zu welchem Preis?**
6. **Wofür steht deine Marke — und wofür ausdrücklich nicht?**
7. **Wer ist dein Wunschkunde, und was drückt ihn wirklich?**
   (In seinen Worten, nicht in deinen. Das ist der Unterschied zwischen einem Text, der
   verkauft, und einem, der nett klingt.)

**Beide Zuschnitte:**

8. **Welche zwei oder drei Dinge verantwortest du dauerhaft, ohne dass sie je fertig
   werden?**
   (Daraus wird der erste eigene Bezug. Die wichtigste Frage von allen.)

### Wie du zuhörst

- **In seinen Worten schreiben, nicht in deinen.** Sagt er "ich hasse Bullshit-Bingo",
  steht das so in `kontext/schreibstil.md` — nicht "bevorzugt klare Sprache".
- **Dünne Antwort nicht ausquetschen.** Einmal nachfragen, dann weiter. Was fehlt, wird
  als Lücke markiert, nicht erfunden.
- **Nichts erfinden.** Keine Rolle, kein Ziel, kein Werkzeug, das nicht gesagt wurde.
  Eine erfundene Zeile in `kontext/` wirkt in jedem künftigen Gespräch weiter.

## Danach: schreiben

### 1. Die Kontext-Seiten füllen

Jede Seite in `kontext/` aus den Antworten schreiben. Struktur der Seite behalten,
Platzhalter ersetzen.

Wo etwas fehlt, eine sichtbare Zeile setzen statt zu raten — und dort **benennen, was
fehlt**. Nicht die Formulierung von hier abschreiben, sondern die Lücke aussprechen:

    - _Noch offen: Was bei dir gar nicht geht. Sag "merk dir das", wenn es dir einfällt._
    - _Noch offen: Ein Ziel mit Zahl und Datum. Sag "merk dir das", wenn es feststeht._

**IMPORTANT — eine offene Zeile, in der buchstäblich drei Punkte oder eine spitze
Klammer stehen bleiben, ist ein Fehler.** Sie sagt dem Menschen nicht, was er
nachliefern soll, und wird deshalb nie nachgeliefert. Im Test ist genau das passiert:
In `schreibstil.md` stand am Ende wörtlich "Noch offen: ..." — die Zeile hat niemanden
an irgendetwas erinnert.

### 2. Den ersten Bezug anlegen

Aus Frage 8 den wichtigsten Punkt nehmen und anlegen:

- Ordner `bereiche/<name>/` (Zuschnitt Bereiche) bzw. `bereiche/ventures/<name>/`
  (Zuschnitt Ventures), darin `entscheidungen/`, `experimente/`, `ideen/`, `messwerte/`
- Übersichtsnotiz aus `_templates/bereich.md` bzw. `_templates/venture.md`
- Lektionen-Seite aus `_templates/lektion.md`, zunächst mit `status: neu` und ohne Regeln

Nur **einen** anlegen, auch wenn drei genannt wurden. Die anderen entstehen, wenn sie
gebraucht werden — leere Ordner erziehen dazu, den Vault zu ignorieren.

### 3. Die Tagesnotiz von heute

Aus `_templates/tagesnotiz.md`. Unter "Geschafft" steht, dass der Vault eingerichtet
wurde. Das ist der erste Eintrag der Geschichte dieses Vaults.

### 4. Prüfen

    python3 bin/vault-check.py
    python3 bin/index-bauen.py

Befunde beheben. Der Vault-Check muss am Ende sauber melden — ein Onboarding, das einen
kaputten Vault hinterlässt, ist schlechter als keines.

## Der Abschluss

Kurz und konkret, höchstens acht Zeilen:

- Welche Seiten gefüllt wurden, und wo Lücken blieben
- Welcher Bezug angelegt wurde
- Was der Mensch als Nächstes tut: **eine** Entscheidung aus den letzten Monaten
  erzählen und "merk dir das" sagen. Dazu die zwei Sätze, die dabei zählen: das "warum"
  ist wertvoller als das "was", und ohne Hypothese, Messgröße und Zeitraum ist etwas
  eine Idee und kein Experiment.

Dann genau **eine** Frage, und zwar diese: **"Arbeitest du mit Azure DevOps, Jira
oder Notion — und soll ich mich damit verbinden, damit ich dort für dich arbeiten
kann?"** Bei Ja den Skill `pm-tool-verbinden` starten. Bei Nein oder Unsicherheit:
erwähnen, dass das jederzeit mit "verbinde mein PM-Tool" nachholbar ist, und
aufhören.

Keine Zusammenfassung des Gesprächs — er war dabei.

## Häufige Fehler

| Fehler | Warum er weh tut |
|---|---|
| Alle acht Fragen auf einmal stellen | Wird nicht beantwortet. Es wirkt wie ein Formular, und genau davor sollte der Skill schützen. |
| Antworten in eigene Worte übersetzen | Die Seite soll klingen wie der Mensch. Sonst trifft der Ton später nie. |
| Lücken mit Plausiblem füllen | Eine erfundene Zeile in `kontext/` wirkt in jedem künftigen Gespräch weiter, ohne dass jemand sie prüft. |
| "Noch offen: ..." schreiben, ohne die Lücke zu benennen | Die Zeile erinnert an nichts und wird nie nachgeliefert. Im Test genau so passiert. Immer hinschreiben, WAS fehlt. |
| Drei Bereiche auf Vorrat anlegen | Leere Ordner sind Ballast und erziehen dazu, den Vault zu ignorieren. |
| Beispielnotizen zur Anschauung anlegen | Der Vault wird bewusst leer ausgeliefert. Fremde Inhalte sehen aus wie Arbeit, die man erst wegräumen muss. Zum Zeigen die Vorlagen in `_templates/` öffnen. |
| Ohne Prüflauf enden | Ein kaputter Vault direkt nach dem Onboarding kostet das Vertrauen, das der Skill aufbauen soll. |
