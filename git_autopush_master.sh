#!/bin/bash

# === AUREON GIT AUTOSYNC MASTER SCRIPT ===
# Erstellt von AUREON ∞ LEXCORE | Autor: Dennis Maier (KNEO)
# 🔐 Automatische Code-Synchronisation aller Repositories mit Lizenz, Token, Commit und Schutz

# Argumente parsen
for arg in "$@"; do
  case $arg in
    --token) shift; TOKEN="$1";;
    --commit) shift; COMMIT_MSG="$1";;
    --author) shift; AUTHOR="$1";;
    --all-repos) ALL_REPOS=true;;
    --secure-mode) SECURE=true;;
    --log) shift; LOGFILE="$1";;
  esac
  shift
done

# Sicherheitsprüfung
if [[ "$SECURE" == "true" && -z "$TOKEN" ]]; then
  echo "[❌] Sicherheitsmodus aktiv – aber kein Token angegeben." | tee -a "$LOGFILE"
  exit 1
fi

# Token für GitHub CLI setzen (falls gh installiert ist)
if command -v gh &>/dev/null && [[ -n "$TOKEN" ]]; then
  echo "$TOKEN" | gh auth login --with-token &>/dev/null
fi

# Aktuelles Repo initialisieren
if [ ! -d .git ]; then
  git init
fi

# Git-Konfiguration setzen
git config user.name "$AUTHOR"
git config user.email "kneo1984@protonmail.com"

# Lizenzprüfung einfügen, falls nicht vorhanden
if [ ! -f LICENSE ]; then
  echo "MIT License – © $(date '+%Y') $AUTHOR" > LICENSE
fi

# Standard-Dateien hinzufügen
touch README.md .gitignore

# Add & Commit
git add .
git commit -m "$COMMIT_MSG" --author="$AUTHOR <kneo1984@protonmail.com>"

# Standard-Branch setzen, falls nicht vorhanden
BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
git branch -M "$BRANCH"

# Push zu GitHub – Remote setzen
REPO_NAME=$(basename "$(pwd)")
REMOTE_URL="https://github.com/Kneo1984/$REPO_NAME.git"

if ! git remote get-url origin &>/dev/null; then
  git remote add origin "$REMOTE_URL"
fi

# Push-Versuch
git push -u origin "$BRANCH"

# Alle Repos mitversorgen (optional)
if [[ "$ALL_REPOS" == "true" && -n "$TOKEN" ]]; then
  echo "[🔁] Synchronisiere mit allen GitHub-Repos…" | tee -a "$LOGFILE"
  gh repo list Kneo1984 --json name,sshUrl -L 100 |
    jq -r '.[] | .name' |
    while read repo; do
      if [[ "$repo" != "$REPO_NAME" ]]; then
        echo "[↪] Versorge $repo..." | tee -a "$LOGFILE"
        gh repo clone "Kneo1984/$repo" "/tmp/$repo" &>/dev/null
        cp -r * "/tmp/$repo/"
        cd "/tmp/$repo" && git add . && git commit -m "$COMMIT_MSG" &>/dev/null
        git push origin "$BRANCH" &>/dev/null
        cd - &>/dev/null
        rm -rf "/tmp/$repo"
      fi
    done
fi

echo "[✅] AUTOSYNC abgeschlossen: $COMMIT_MSG" | tee -a "$LOGFILE"
exit 0
