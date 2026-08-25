# Marketplace by Ben

Bens Plugin-Marktplatz für Claude. Ein Marktplatz ist nur ein Git-Repo, das Claude
lesen kann — dieses hier ist öffentlich, damit Installation und **Updates** ohne
GitHub-Konto funktionieren.

## Was drin ist

| Plugin | Skills | Wofür |
|---|---|---|
| `second-brain` | `onboarding`, `feierabend`, `fragmichaus`, `pm-tool-verbinden` | Skills für einen PARA-Vault aus der [Second-Brain-Vorlage](https://github.com/thebenfarmer/second-brain-vorlage) |
| `pen` | `pen` | Designs mit der [pen.dev](https://pen.dev)-CLI erzeugen und bearbeiten — bietet sich nur an, wo die Pen-App installiert ist (CLI wird bei Bedarf nachinstalliert) |

Die Skills im Überblick:

- **`onboarding`** — richtet einen frischen Vault per Interview ein und fragt am Ende,
  ob ein Projektwerkzeug angebunden werden soll
- **`feierabend`** — schließt eine Session ab: Inbox, Tagesnotiz, Prüflauf
- **`fragmichaus`** — löchert dich zu einem Plan oder einer Entscheidung, Frage für
  Frage, bis das Denken stressgetestet ist
- **`pm-tool-verbinden`** — verbindet den Assistenten mit Azure DevOps, Jira oder
  Notion, damit er dort Tickets und Seiten bearbeiten kann
- **`pen`** — erzeugt und ändert `.pen`-Design-Dateien per Prompt über die
  pen.dev-CLI (eigener pen.dev-Account nötig; ohne installierte Pen-App hält der Skill still,
  eine fehlende CLI installiert er selbst nach)

## Installieren

### Claude Code (Terminal)

```bash
claude plugin marketplace add thebenfarmer/marketplace-by-ben
claude plugin install second-brain@marketplace-by-ben
```

Oder in einer laufenden Sitzung `/plugin` tippen und den Marktplatz dort eintragen.

### Claude Cowork (Desktop App)

**Customize -> Plugins -> Add marketplace**, dann `thebenfarmer/marketplace-by-ben`
eintragen und das Plugin `second-brain` installieren. Danach eine **neue** Sitzung
starten — Skills laden beim Start.

### ChatGPT / Codex

Codex kennt keine Marktplätze, es liest Skill-Ordner. Wer die Second-Brain-Vorlage
nutzt: Im Vault liegt `bin/skills-update.sh` — das Skript holt die Skills aus diesem
Repo und legt sie in die Ordner, die Codex (und Claude im Terminal) lesen.

### OpenCode

Nichts zu installieren: [OpenCode](https://opencode.ai) liest die Skills unter
`.claude/skills/` eines Vaults direkt mit (nachgemessen) — `bin/skills-update.sh`
hält also auch OpenCode aktuell. Global lassen sie sich alternativ nach
`~/.config/opencode/skills/` kopieren.

## Updates

- **Claude Code / Cowork:** über die Plugin-Verwaltung aktualisieren
  (`claude plugin update second-brain` bzw. der Update-Knopf in der Plugins-Ansicht).
- **Codex / Vault-Ordner:** `bin/skills-update.sh` im Vault erneut ausführen.

## Ändern

**Dieses Repo ist die Quelle der Skills.** Die Second-Brain-Vorlage und die daraus
kopierten Vaults halten nur Kopien und ziehen sie per Skript nach. Wer einen Skill
ändert, ändert ihn hier — nirgendwo sonst.

Prüfen vor dem Commit:

```bash
python3 bin/plugin-check.py
claude plugin validate .
```
