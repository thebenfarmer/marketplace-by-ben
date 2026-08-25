#!/bin/sh

# Direkter, lesender Zugriff auf die Azure-DevOps-REST-API (Cloud und eigener Server).
# Zugangsdaten gehören in eine lokale Datei AUSSERHALB des Vaults.

set -eu

usage() {
  cat <<'EOF'
Aufruf:
  bin/azdo.sh projects
  bin/azdo.sh teams "<Projekt>"
  bin/azdo.sh iterations "<Projekt>"
  bin/azdo.sh iteration-workitems "<Projekt>" "<Iterations-ID>"
  bin/azdo.sh workitems "<Projekt>" [Anzahl]
  bin/azdo.sh workitem-details "<Projekt>" "<ID,ID,...>"
  bin/azdo.sh workitem-comments "<Projekt>" "<ID>"
  bin/azdo.sh repos "<Projekt>"
  bin/azdo.sh repo-items "<Projekt>" "<Repository>" [Pfad]
  bin/azdo.sh repo-file "<Projekt>" "<Repository>" "<Pfad>"
EOF
}

command=${1:-}

case "$command" in
  ""|-h|--help|help)
    usage
    exit 0
    ;;
esac

env_home=${HOME:?HOME is required}
env_file=${AZDO_ENV_FILE:-"$env_home/.config/secondbrain/azure-devops.env"}

if [ ! -f "$env_file" ]; then
  echo "Azure-DevOps-Konfiguration fehlt: $env_file" >&2
  echo "Lege dort AZDO_COLLECTION_URL und AZDO_PAT an; keine Zugangsdaten im Vault speichern." >&2
  exit 2
fi

# shellcheck disable=SC1090
. "$env_file"

: "${AZDO_COLLECTION_URL:?AZDO_COLLECTION_URL is required}"
: "${AZDO_PAT:?AZDO_PAT is required}"

api_version=${AZDO_API_VERSION:-6.0}

request() {
  endpoint=$1
  shift
  curl --silent --show-error --fail-with-body \
    --user ":$AZDO_PAT" \
    "$@" \
    "$AZDO_COLLECTION_URL$endpoint"
}

url_path() {
  printf '%s' "$1" | sed 's/ /%20/g'
}

case "$command" in
  projects)
    request "/_apis/projects?api-version=$api_version"
    ;;
  teams)
    project=${2:-}
    [ -n "$project" ] || { usage; exit 1; }
    request "/_apis/projects/$(url_path "$project")/teams?api-version=$api_version"
    ;;
  iterations)
    project=${2:-}
    [ -n "$project" ] || { usage; exit 1; }
    request "/$(url_path "$project")/_apis/work/teamsettings/iterations?api-version=$api_version"
    ;;
  iteration-workitems)
    project=${2:-}
    iteration_id=${3:-}
    [ -n "$project" ] && [ -n "$iteration_id" ] || { usage; exit 1; }
    request "/$(url_path "$project")/_apis/work/teamsettings/iterations/$iteration_id/workitems?api-version=$api_version"
    ;;
  workitems)
    project=${2:-}
    top=${3:-10}
    [ -n "$project" ] || { usage; exit 1; }
    request "/$(url_path "$project")/_apis/wit/wiql?api-version=$api_version&\$top=$top" \
      -X POST \
      -H "Content-Type: application/json" \
      --data "{\"query\":\"Select [System.Id], [System.Title], [System.State] From WorkItems Where [System.TeamProject] = '$project' Order By [System.ChangedDate] Desc\"}"
    ;;
  workitem-details)
    project=${2:-}
    ids=${3:-}
    [ -n "$project" ] && [ -n "$ids" ] || { usage; exit 1; }
    request "/$(url_path "$project")/_apis/wit/workitemsbatch?api-version=$api_version" \
      -X POST \
      -H "Content-Type: application/json" \
      --data "{\"ids\":[$ids],\"fields\":[\"System.Id\",\"System.Title\",\"System.State\",\"System.WorkItemType\",\"System.IterationPath\",\"System.AssignedTo\"]}"
    ;;
  workitem-comments)
    project=${2:-}
    item_id=${3:-}
    [ -n "$project" ] && [ -n "$item_id" ] || { usage; exit 1; }
    request "/$(url_path "$project")/_apis/wit/workItems/$item_id/comments?api-version=6.0-preview.3"
    ;;
  repos)
    project=${2:-}
    [ -n "$project" ] || { usage; exit 1; }
    request "/$(url_path "$project")/_apis/git/repositories?api-version=$api_version"
    ;;
  repo-items)
    project=${2:-}
    repository=${3:-}
    item_path=${4:-/}
    [ -n "$project" ] && [ -n "$repository" ] || { usage; exit 1; }
    encoded_path=$(url_path "$item_path")
    request "/$(url_path "$project")/_apis/git/repositories/$(url_path "$repository")/items?scopePath=$encoded_path&recursionLevel=OneLevel&includeContentMetadata=true&api-version=$api_version"
    ;;
  repo-file)
    project=${2:-}
    repository=${3:-}
    item_path=${4:-}
    [ -n "$project" ] && [ -n "$repository" ] && [ -n "$item_path" ] || { usage; exit 1; }
    encoded_path=$(url_path "$item_path")
    request "/$(url_path "$project")/_apis/git/repositories/$(url_path "$repository")/items?path=$encoded_path&includeContent=true&resolveLfs=true&api-version=$api_version"
    ;;
  *)
    usage
    exit 1
    ;;
esac
