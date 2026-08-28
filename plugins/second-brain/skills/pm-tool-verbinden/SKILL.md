---
name: pm-tool-verbinden
description: Verbindet den Assistenten mit dem Projektwerkzeug - Azure DevOps, Jira oder Notion - damit er dort Tickets, Boards und Seiten lesen und bearbeiten kann. Azure DevOps wahlweise per MCP oder direkt per REST-Skript (nur lesend, auch fuer eigene Server). Richtet ein, wo die Umgebung es erlaubt, und leitet sonst Schritt fuer Schritt an. Nutze bei "verbinde Jira", "Azure DevOps anbinden", "Notion verbinden", "pm-tool-verbinden".
---

# PM-Tool verbinden

## Worum es geht

Der Vault kennt den Menschen — aber seine Arbeit liegt in einem Projektwerkzeug:
Azure DevOps, Jira oder Notion. Dieser Skill stellt die Verbindung her, damit der
Assistent dort direkt arbeiten kann: Tickets lesen und anlegen, Boards abfragen,
Seiten bearbeiten.

Die Verbindung läuft meist über **MCP** (Model Context Protocol) — ein
Standard-Stecker, über den ein Assistent fremde Anwendungen bedienen darf. Für
Azure DevOps gibt es zusätzlich einen direkten REST-Weg ohne MCP (Weg B unten).

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

Zwei Wege — zuerst entscheiden, welcher passt:

| Situation | Weg |
|---|---|
| Cloud (`dev.azure.com`), Terminal, Schreiben gewünscht | A — MCP-Server |
| Eigener Server (Azure DevOps Server, eigene Adresse) | B — direkt per REST |
| Umgebung ohne MCP-Möglichkeit | B — direkt per REST |
| Nur lesen gewünscht | B — direkt per REST |

**PAT anlegen** (macht der Mensch selbst, im Browser — gilt für beide Wege):

1. `https://dev.azure.com/<organisation>` öffnen — beim eigenen Server stattdessen
   `https://<server>/<collection>`
2. Oben rechts: Benutzereinstellungen -> **Personal access tokens** -> New Token
3. Nur die nötigen Rechte: für Weg B reicht **Read**; für Weg A **Work Items
   (Read & Write)**, bei Bedarf **Code (Read)**
4. Ablaufdatum setzen (90 Tage sind ein guter Standard) und das Token kopieren

Das Token landet danach **nur in der lokalen Config, einer Umgebungsvariable
oder der Env-Datei aus Weg B** — siehe Sicherheitsregeln unten.

#### Weg A: MCP-Server

Microsofts offizieller Server: <https://github.com/microsoft/azure-devops-mcp>.
Er läuft lokal (`npx`) und meldet sich standardmäßig **interaktiv per
Browser-Login** (Microsoft-Konto) an — dafür reicht die Organisation als
Argument, kein PAT nötig. Vollständige Anleitung mit allen Anmeldewegen:
<https://github.com/microsoft/azure-devops-mcp/blob/main/docs/GETTINGSTARTED.md>
**Vor dem Einrichten dort nachsehen**, ob sich Befehle geändert haben.

- **Claude Code, interaktiv (einfachster Weg):**

      claude mcp add --transport stdio azure-devops -- npx -y @azure-devops/mcp <organisation>

  Danach `claude mcp list` zur Kontrolle. Beim ersten Tool-Aufruf öffnet sich
  der Browser für den Login.

- **Claude Code mit PAT** (wenn kein Browser verfügbar ist, z.B. headless):
  Drei Stolperfallen, die genau hier die Verbindung kaputt machen, wenn man sie
  übergeht — der Variablenname ist **fest** `PERSONAL_ACCESS_TOKEN` (kein
  beliebiger Name), der Wert muss **base64-kodiert als `<email>:<pat>`**
  übergeben werden (nicht das rohe Token), und ohne das zusätzliche
  `--authentication pat`-Argument ignoriert der Server das Token und versucht
  trotzdem den Browser-Login:

      claude mcp add --transport stdio azure-devops \
        --env PERSONAL_ACCESS_TOKEN="$(printf '%s' '<email>:<pat>' | base64)" \
        -- npx -y @azure-devops/mcp <organisation> --authentication pat

  Die E-Mail-Adresse kann ein beliebiger nicht-leerer Wert sein, sie wird nicht
  geprüft.

- **Nur die gebrauchten Tool-Gruppen laden** hält die Tool-Liste klein — z.B.
  für "Repos lesen, Arbeitselemente anlegen" reicht
  `-d repositories -d work-items` als zusätzliches Server-Argument (verfügbare
  Domains: `core`, `work`, `work-items`, `search`, `test-plans`, `repositories`,
  `wiki`, `pipelines`, `advanced-security`).

- **Codex:** `codex mcp add azure-devops -- npx -y @azure-devops/mcp <organisation>`
  (interaktiv) oder mit `az login` + `--authentication azcli`. Manueller
  Eintrag in `~/.codex/config.toml` unter `[mcp_servers.azure-devops]` mit
  `command`/`args` wie oben.
- **Cowork / Codex Work:** Für Azure DevOps gibt es keinen eingebauten Connector.
  Prüfen, ob die App lokale MCP-Server per Config-Datei unterstützt, und den
  Menschen durch genau diese Datei führen. Geht das nicht: Weg B nehmen.

#### Weg B: direkt per REST (ohne MCP)

Ein kleines Shell-Skript ruft die REST-API von Azure DevOps direkt auf — kein
MCP-Server, nichts zu installieren, funktioniert überall, wo der Assistent
Shell-Befehle ausführen darf, und als einziger Weg auch mit einem eigenen
Azure DevOps Server. Bewusst **nur lesend**: Projekte, Teams, Iterationen,
Work Items samt Details und Kommentaren, Repos, Dateien.

1. Skript kopieren: `references/azdo.sh` (liegt neben diesem Skill) nach
   `bin/azdo.sh` im Vault, dann `chmod +x bin/azdo.sh`.
2. Zugangsdaten **außerhalb des Vaults** ablegen, in
   `~/.config/secondbrain/azure-devops.env`:

       AZDO_COLLECTION_URL=https://dev.azure.com/<organisation>
       AZDO_PAT=<das Token>
       AZDO_API_VERSION=6.0

   Beim eigenen Server ist die URL `https://<server>/<collection>`. Die
   API-Version 6.0 verstehen der Cloud-Dienst und Azure DevOps Server ab 2020;
   schlägt ein Aufruf fehl, die Version prüfen, die der Server spricht.
3. `bin/azdo.sh` ohne Argumente zeigt alle Unterbefehle.

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
- **Azure DevOps (Weg A):** die Work Items des aktuellen Sprints listen
- **Azure DevOps (Weg B):** `bin/azdo.sh projects` — kommt die Projektliste
  zurück, steht die Verbindung

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
