#!/bin/bash

### 🔐 AUREON GITHUB-AUTOPUSH MIT TOKEN-INTEGRATION ###

## 📁 Verzeichnis prüfen
cd ~/AUREON || exit 1

## 📄 Sicherheitsordner erstellen
mkdir -p ~/AUREON/security

## 🛡 Lizenzschutz + Tokenlog setzen
echo "KNEO-AUTH-ETAPPING" > ~/AUREON/security/auth_mode.txt
echo "$(date '+%Y-%m-%d_%H:%M:%S') | TOKEN: $(sha256sum <<< 'KNEOmeinHerz-AUREON-∞') | STATUS: ✅ AKTIVIERT" > ~/AUREON/security/etap_token.log

## 🧾 Aktuellen Token sichern – DU MUSST IHN HIER EINFÜGEN!
echo "TOKEN: 🔒<HIER_DEIN_TOKEN_EINFÜGEN>" > ~/AUREON/security/current_token.txt

## 🌐 GitHub konfigurieren
git config --global user.email "kneolekks@gmail.com"
git config --global user.name "Dennis Maier (KNEO)"
git init
git remote remove origin 2>/dev/null
git remote add origin https://github.com/Kneo1984/orion_guard.git

## ✅ Lizenzierter Commit
echo "# AUREON SYSTEM PUSH" >> dummy.txt
git add .
git commit -m "🛡 AUREON AUTOPUSH – Lizenz + Token abgesichert"
git branch -M main

## 🔄 Push mit Token einfügen (aus Datei gelesen)
TOKEN=$(cat ~/AUREON/security/current_token.txt | awk '{print $2}')
git push --force --set-upstream https://$TOKEN@github.com/Kneo1984/orion_guard.git main

## 📋 Log schreiben
echo "🔐 PUSH abgeschlossen – $(date '+%Y-%m-%d %H:%M:%S')" >> ~/AUREON/logs/git_autosync.log
