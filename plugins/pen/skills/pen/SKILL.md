---
name: pen
description: Erzeugt und bearbeitet Designs (.pen-Dateien) mit der pen.dev-CLI - UI-Mockups, Landing Pages, Grafiken per Prompt. Nutze bei "design mir", "Mockup erstellen", "pen", "pencil", "pen-Datei" - aber NUR, wenn die CLI installiert ist (pen status prueft das); ist sie es nicht, Design-Arbeit nicht ueber pen.dev anbieten.
---

# Pen.dev: Designs per CLI

## Worum es geht

Die pen.dev-CLI (Befehl `pen`) lässt einen Assistenten echte Design-Dateien erzeugen
und bearbeiten: UI-Mockups, Landing Pages, Grafiken. Das Ergebnis ist eine
`.pen`-Datei, die der Mensch auf <https://pen.dev> oder in der Pen-Desktop-App
öffnet und weiterbearbeitet.

**Stand der Befehle: August 2026.** Schlägt ein Befehl fehl: erst `pen --help`
lesen, dann die Doku auf <https://pen.dev> — nicht raten.

## Schritt 1: Lage prüfen — und nur weitermachen, wenn Pen da ist

`pen status` ausführen.

- **Eingeloggt:** bereit, weiter zu Schritt 2.
- **CLI installiert, aber nicht eingeloggt:** `pen login` ist interaktiv (E-Mail +
  Passwort oder Einmal-Code) — das macht der Mensch selbst, mit seinem eigenen
  pen.dev-Account. Im Terminal von Claude Code: vorschlagen, `! pen login` in die
  Prompt zu tippen.
- **CLI fehlt** (`command not found`): **Hier endet der Skill.** Pen.dev nicht
  anbieten, keine Installation vorschlagen, nicht nachfragen — wer die CLI nicht
  hat, arbeitet ohne sie. Nur wenn der Mensch von sich aus nach der Einrichtung
  fragt: `npm install -g @pen.dev/cli` (braucht Node.js), danach `pen login`.

Dasselbe gilt fürs proaktive Anbieten: "Soll ich dir das als Design entwerfen?"
ist nur dann eine erlaubte Frage, wenn `pen` installiert ist.

## Schritt 2: designen

**Für Agenten ist `pen interactive` der vorgesehene Modus** — die CLI sagt das
selbst in ihrer Hilfe. Für einzelne Aufträge tut es der Direktaufruf:

    # Neues Design aus einem Prompt
    pen --out entwurf.pen --prompt "Landing Page für einen Dachdecker-Betrieb, seriös, viel Weißraum"

    # Bestehendes Design ändern
    pen --in entwurf.pen --out entwurf-v2.pen --prompt "Füge einen Preisbereich mit drei Paketen hinzu"

    # Bild als Vorlage mitgeben (Screenshot, Logo, Moodboard)
    pen --out entwurf.pen --prompt "Baue diese Skizze als sauberes UI nach" --prompt-file skizze.png

Dabei gilt:

- **Prompts wie ein Design-Briefing schreiben:** Zweck, Zielgruppe, Tonalität,
  gewünschte Bausteine. "Mach eine Website" liefert Beliebiges.
- **Versionen behalten:** beim Ändern in eine neue `--out`-Datei schreiben, nicht
  die alte überschreiben — ein missglückter Prompt soll nichts kosten.
- **`.pen`-Dateien nie mit Lese- oder Suchwerkzeugen öffnen** — sie sind kein
  Klartext. Anschauen und feinjustieren passiert auf pen.dev oder in der App.
- Die CLI treibt selbst ein KI-Modell an (`--agent claude`, `codex` oder
  `gemini`) und läuft auf Rechnung des eingeloggten Accounts. Bei großen
  Batch-Aufträgen vorher ansagen, dass das Kosten erzeugt.

## Schritt 3: übergeben

Am Ende dem Menschen sagen: welche `.pen`-Datei entstanden ist, wo sie liegt, und
dass er sie auf <https://pen.dev> oder in der Pen-App öffnet. Nicht behaupten, wie
das Design aussieht — du hast es nicht gesehen, du hast es beauftragt.

## Häufige Fehler

| Fehler | Warum er weh tut |
|---|---|
| Pen anbieten, obwohl die CLI fehlt | Der Mensch landet in einer Installations-Odyssee, die er nie wollte. Erst `pen status`, dann reden. |
| `pen login` selbst ausführen wollen | Der Login ist interaktiv und gehört dem Menschen. Automatisierte Eingaben scheitern oder landen im falschen Account. |
| `.pen`-Datei mit Read/Grep öffnen | Kein Klartext — das Ergebnis ist Zeichensalat und verbrennt nur Kontext. |
| Die Ausgangsdatei überschreiben | Ein missglückter Prompt vernichtet dann den letzten guten Stand. |
| Das Ergebnis beschreiben, als hättest du es gesehen | Die CLI liefert eine Datei, kein Bild. Ehrlich bleiben: erzeugt ja, begutachtet nein. |
