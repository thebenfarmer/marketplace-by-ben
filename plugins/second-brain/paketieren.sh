#!/usr/bin/env bash
# Packt das Plugin zu second-brain-plugin.zip, wie die Plugins-Seite es erwartet:
# das Plugin-Verzeichnis liegt IM Zip, nicht dessen Inhalt.
set -euo pipefail

cd "$(dirname "$0")"
ziel="$PWD/second-brain-plugin.zip"

rm -f "$ziel"
cd ..
zip -r -q "$ziel" second-brain -x '*.DS_Store' '*second-brain-plugin.zip'

echo "Paket erstellt: $ziel"
unzip -l "$ziel" | tail -n +4 | head -20
