---
name: pm-tool-verbinden
description: Verbindet den Assistenten mit dem Projektwerkzeug - Azure DevOps, Jira oder Notion - damit er dort Tickets, Boards und Seiten lesen und bearbeiten kann. Richtet ein, wo die Umgebung es erlaubt, und leitet sonst Schritt fuer Schritt an. Nutze bei "verbinde Jira", "Azure DevOps anbinden", "Notion verbinden", "pm-tool-verbinden".
---

# PM-Tool verbinden

## Worum es geht

Der Vault kennt den Menschen — aber seine Arbeit liegt in einem Projektwerkzeug:
Azure DevOps, Jira oder Notion. Dieser Skill stellt die Verbindung her, damit der
Assistent dort direkt arbeiten kann: Tickets lesen und anlegen, Boards abfragen,
Seiten bearbeiten.

Die Verbindung läuft über **MCP** (Model Context Protocol) — ein Standard-Stecker,
über den ein Assistent fremde Anwendungen bedienen darf.

**Diese Befehle veralten.** Wenn einer fehlschlägt oder eine Adresse nicht mehr
stimmt: erst die verlinkte offizielle Doku prüfen, dann weitermachen — nicht raten.

## Schritt 1: Lage prüfen

**Umgebung erkennen, ehrlich.** Der Weg hängt davon ab, wo dieses Gespräch läuft:

| Umgebung | Kannst du selbst einrichten? |
|---|---|
| Claude Code (Terminal) | Ja — per `claude mcp add` |
| Codex (Terminal) | Ja — per `~/.codex/config.toml` |
| OpenCode (Terminal) | Ja — per `opencode.json`, Abschnitt `mcp` (Doku: <https://opencode.ai/docs/mcp-servers/>) |
| Claude Cowork (Desktop App) | Nein — anleiten: Connector-Einstellungen im Claude-Konto |
| Codex Work (Desktop App) | Teilweise — prüfen, ob die App `~/.codex/config.toml` liest; sonst anleiten |

Bist du nicht sicher, in welcher Umgebung du läufst: **fragen**, nicht raten.

Dann **eine** Frage stellen: Welches Werkzeug soll angebunden werden — Azure DevOps,
Jira oder Notion? (Eines nach dem anderen. Der Skill lässt sich für ein zweites
Werkzeug erneut aufrufen.)

## Schritt 2: einrichten

### Jira (und Confluence)

Atlassian betreibt einen offiziellen Server mit Browser-Login (OAuth) — kein Token
nötig. Doku: <https://support.atlassian.com/rovo/docs/getting-started-with-the-atlassian-remote-mcp-server/>

- **Claude Code:**
  `claude mcp add --transport sse atlassian https://mcp.atlassian.com/v1/sse`
  Danach `/mcp` aufrufen und den Browser-Login durchklicken.
- **Codex:** in `~/.codex/config.toml`:

      [mcp_servers.atlassian]
      command = "npx"
      args = ["-y", "mcp-remote", "https://mcp.atlassian.com/v1/sse"]

- **Cowork:** In den Claude-Einstellungen unter **Connectors** nach Atlassian/Jira
  suchen und verbinden. Den Menschen durchklicken lassen, Schritt für Schritt ansagen.

### Notion

Notion betreibt einen offiziellen Server mit Browser-Login (OAuth). Doku:
<https://developers.notion.com/docs/mcp>

- **Claude Code:**
  `claude mcp add --transport http notion https://mcp.notion.com/mcp`
  Danach `/mcp` aufrufen und den Browser-Login durchklicken.
- **Codex:** in `~/.codex/config.toml`:

      [mcp_servers.notion]
      command = "npx"
      args = ["-y", "mcp-remote", "https://mcp.notion.com/mcp"]

- **Cowork:** In den Claude-Einstellungen unter **Connectors** Notion verbinden —
  das ist dort ein eingebauter Connector.

### Azure DevOps

Microsofts offizieller Server: <https://github.com/microsoft/azure-devops-mcp>.
Er läuft lokal (`npx`) und braucht einen Zugang. **Vor dem Einrichten die README
prüfen**, welche Anmeldewege der Server aktuell unterstützt — bevorzugt den
**Personal Access Token (PAT)**, weil er ohne Azure-CLI-Installation auskommt.

**PAT anlegen** (macht der Mensch selbst, im Browser):

1. `https://dev.azure.com/<organisation>` öffnen
2. Oben rechts: Benutzereinstellungen -> **Personal access tokens** -> New Token
3. Nur die nötigen Rechte: **Work Items (Read & Write)**, bei Bedarf **Code (Read)**
4. Ablaufdatum setzen (90 Tage sind ein guter Standard) und das Token kopieren

Dann einrichten — das Token landet dabei **nur in der lokalen Config oder einer
Umgebungsvariable**, siehe Sicherheitsregeln unten.

- **Claude Code:** `claude mcp add` mit dem Startbefehl aus der README des Servers,
  das PAT als Umgebungsvariable (`--env NAME=wert`), Organisation als Argument.
- **Codex:** Eintrag in `~/.codex/config.toml` mit `command`/`args` aus der README,
  das PAT unter `env`.
- **Cowork / Codex Work:** Für Azure DevOps gibt es keinen eingebauten Connector.
  Prüfen, ob die App lokale MCP-Server per Config-Datei unterstützt, und den
  Menschen durch genau diese Datei führen. Geht das nicht, ehrlich sagen: Dieser
  Weg funktioniert derzeit nur im Terminal.

## Sicherheitsregeln (nicht verhandelbar)

- **Ein PAT ist ein Geheimnis.** Es gehört in die MCP-Config oder eine
  Umgebungsvariable — **niemals in den Vault, niemals in eine Notiz, niemals in
  Git.** Auch nicht "nur zur Erinnerung".
- Vor dem Speichern prüfen: Liegt die Config-Datei in einem Git-Repo? Dann darf
  das Token dort nicht hinein.
- Nie mehr Rechte anfordern als gebraucht. Lesen und Schreiben von Work Items
  reicht fast immer.

## Schritt 3: prüfen

Eine Verbindung, die nicht getestet wurde, ist keine. Nach dem Einrichten (im
Terminal sofort, in Cowork/Codex Work nach dem Neustart der Sitzung — Verbindungen
laden beim Start):

- **Jira:** ein bekanntes Ticket abrufen oder die eigenen offenen Vorgänge listen
- **Notion:** eine Seite suchen, deren Titel der Mensch nennt
- **Azure DevOps:** die Work Items des aktuellen Sprints listen

Kommt echtes Ergebnis zurück: Verbindung steht. Kommt ein Fehler: Fehlermeldung
lesen und beheben, nicht "sollte jetzt gehen" melden.

## Schritt 4: festhalten

Eine Zeile ergänzen: welches Werkzeug verbunden ist und seit wann. Wohin, hängt am
Zuschnitt des Vaults: in `kontext/arbeitsumfeld.md`, wenn es die Seite gibt
(Zuschnitt Bereiche), sonst in `kontext/ueber-mich.md` (Zuschnitt Ventures).
**Kein Token, keine Adresse mit Zugangsdaten** — nur die Tatsache.

## Der Abschluss

Höchstens fünf Zeilen: was verbunden wurde, wie es getestet wurde, wo die
Config liegt (Pfad, ohne Geheimnisse), und der Hinweis, dass der Skill für ein
weiteres Werkzeug erneut aufrufbar ist. Danach keine weiteren Fragen.

## Häufige Fehler

| Fehler | Warum er weh tut |
|---|---|
| Token in den Vault oder eine Notiz schreiben | Der Vault ist Klartext und oft ein Git-Repo. Ein geleaktes PAT ist ein fremder Login. |
| Verbindung einrichten, aber nicht testen | "Eingerichtet" ohne Test heißt: Der Fehler fällt erst auf, wenn der Mensch mittendrin steckt. |
| In Cowork Config-Dateien schreiben wollen | Cowork lädt Verbindungen über die Connector-Einstellungen des Kontos. Eine Datei im Ordner ändert daran nichts. |
| Bei unklarer Umgebung einfach loslegen | Der falsche Weg hinterlässt halbe Configs, die später niemand zuordnen kann. Erst fragen. |
| Veraltete Befehle aus diesem Skill erzwingen | Die Werkzeuge ändern sich. Schlägt ein Befehl fehl, gilt die verlinkte Doku, nicht dieser Text. |
