# Plugin "Zweites Gehirn"

Die Skills der [Second-Brain-Vorlage](https://github.com/thebenfarmer/second-brain-vorlage)
als Claude-Plugin. Nötig vor allem für **Cowork**, wo Skills aus dem angehängten Ordner
nicht gelesen werden (geprüft: ein Wegwerf-Skill mit einmaligem Codewort kam in einer
frischen Cowork-Sitzung nicht zurück). Im Terminal findet Claude Code Ordner-Skills von
selbst — dort schadet das Plugin aber auch nicht und bringt die Updates.

## Was drin ist

| Skill | Was er tut |
|---|---|
| `onboarding` | Interview mit acht Fragen, füllt daraus `kontext/`, legt den ersten Bereich an, bietet die PM-Tool-Anbindung an |
| `feierabend` | Inbox einsortieren, Tagesnotiz schreiben, Erkenntnisse ablegen, Prüflauf |
| `fragmichaus` | Löchert dich zu einem Plan oder einer Entscheidung, bis das Denken stressgetestet ist |
| `pm-tool-verbinden` | Verbindet den Assistenten mit Azure DevOps, Jira oder Notion |

`onboarding` und `feierabend` erkennen selbst, welchen Zuschnitt der Vault hat
(Bereiche oder Ventures) — es gibt sie deshalb nur einmal, nicht je Variante.

## Installieren

Der normale Weg ist der Marktplatz — siehe README im Repo-Root. Er bringt Updates mit.

**Rückfallweg ohne GitHub-Zugriff:** das Zip hochladen. In Cowork
**Customize -> Plugins** öffnen, die Hochlade-Option wählen und
`second-brain-plugin.zip` auswählen. Fehlt das Zip: `./paketieren.sh` in diesem
Ordner erzeugt es, braucht nur `zip`. Ein per Zip installiertes Plugin bekommt
**keine** Updates — bei der nächsten Änderung das neue Zip erneut hochladen.

**Wichtig:** Nach der Installation eine **neue** Sitzung starten. Skills werden beim
Start einer Sitzung geladen, in einer laufenden tauchen sie nicht auf.

## Prüfen

```bash
claude plugin validate .
```
