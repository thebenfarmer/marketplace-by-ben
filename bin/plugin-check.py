#!/usr/bin/env python3
"""Prueft die Grundform des Marktplatzes, ohne Claude-CLI:

- marketplace.json und plugin.json sind gueltiges JSON und zeigen auf existierende Pfade
- jeder Skill-Ordner enthaelt eine SKILL.md mit Frontmatter
- der name im Frontmatter ist gleich dem Ordnernamen

Exit 1 bei Befund, sonst 0. Laeuft in der CI und lokal vor dem Commit.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
befunde = []


def melde(text):
    befunde.append(text)
    print(f"BEFUND  {text}")


marketplace = ROOT / ".claude-plugin" / "marketplace.json"
try:
    daten = json.loads(marketplace.read_text())
except (OSError, json.JSONDecodeError) as e:
    print(f"BEFUND  {marketplace}: {e}")
    sys.exit(1)

for plugin in daten.get("plugins", []):
    plugin_dir = ROOT / plugin["source"]
    if not plugin_dir.is_dir():
        melde(f"{plugin['name']}: Quelle {plugin['source']} existiert nicht")
        continue

    plugin_json = plugin_dir / ".claude-plugin" / "plugin.json"
    try:
        meta = json.loads(plugin_json.read_text())
        if meta.get("name") != plugin["name"]:
            melde(f"{plugin_json}: name '{meta.get('name')}' != Marktplatz-Name '{plugin['name']}'")
    except (OSError, json.JSONDecodeError) as e:
        melde(f"{plugin_json}: {e}")

    skills_dir = plugin_dir / "skills"
    skill_dirs = sorted(p for p in skills_dir.iterdir() if p.is_dir()) if skills_dir.is_dir() else []
    if not skill_dirs:
        melde(f"{plugin['name']}: keine Skills unter {skills_dir}")
    for skill_dir in skill_dirs:
        skill_md = skill_dir / "SKILL.md"
        if not skill_md.is_file():
            melde(f"{skill_dir}: SKILL.md fehlt")
            continue
        text = skill_md.read_text()
        m = re.match(r"---\n(.*?)\n---\n", text, re.DOTALL)
        if not m:
            melde(f"{skill_md}: kein Frontmatter")
            continue
        name = re.search(r"^name:\s*(\S+)\s*$", m.group(1), re.MULTILINE)
        if not name:
            melde(f"{skill_md}: Frontmatter ohne name")
        elif name.group(1) != skill_dir.name:
            melde(f"{skill_md}: name '{name.group(1)}' != Ordnername '{skill_dir.name}'")
        if not re.search(r"^description:\s*\S", m.group(1), re.MULTILINE):
            melde(f"{skill_md}: Frontmatter ohne description")

codex_marktplatz = ROOT / ".agents" / "plugins" / "marketplace.json"
try:
    codex_daten = json.loads(codex_marktplatz.read_text())
except (OSError, json.JSONDecodeError) as e:
    melde(f"{codex_marktplatz}: {e}")
    codex_daten = {"plugins": []}

claude_namen = {p["name"] for p in daten.get("plugins", [])}
codex_namen = set()
for plugin in codex_daten.get("plugins", []):
    codex_namen.add(plugin["name"])
    plugin_dir = ROOT / plugin["source"]["path"]
    if not plugin_dir.is_dir():
        melde(f"Codex-Plugin {plugin['name']}: Pfad {plugin['source']['path']} existiert nicht")
        continue
    manifest = plugin_dir / ".codex-plugin" / "plugin.json"
    try:
        meta = json.loads(manifest.read_text())
        if meta.get("name") != plugin["name"]:
            melde(f"{manifest}: name '{meta.get('name')}' != Katalog-Name '{plugin['name']}'")
    except (OSError, json.JSONDecodeError) as e:
        melde(f"{manifest}: {e}")
if claude_namen != codex_namen:
    melde(f"Claude-Katalog {sorted(claude_namen)} != Codex-Katalog {sorted(codex_namen)}")

if befunde:
    print(f"\n{len(befunde)} Befund(e).")
    sys.exit(1)
print("Plugin-Check: sauber.")
