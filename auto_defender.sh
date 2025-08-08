#!/data/data/com.termux/files/usr/bin/bash

WATCH_DIRS=(
    "$HOME/routersploit/modules/creds"
    "$HOME/routersploit/modules/exploits"
    "$HOME/quantumshield"
    "$HOME/AUREON"
)

LOG_FILE="$HOME/AUREON/logs/shield_response.log"
QUARANTINE="$HOME/AUREON/quarantine"
BACKUP="$HOME/AUREON/backup"
SCAN_LOG="$HOME/AUREON/scanlog/scan_$(date +%Y%m%d_%H%M%S).log"

echo "[AUREON] Autodefender gestartet am $(date)" >> "$LOG_FILE"

inotifywait -m -r -e modify,create,delete,move "${WATCH_DIRS[@]}" | while read path action file; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    FULL_PATH="$path$file"
    HASH=$(sha256sum "$FULL_PATH" 2>/dev/null | cut -d ' ' -f1)

    echo "$TIMESTAMP | $action | $FULL_PATH | HASH=$HASH" >> "$LOG_FILE"

    # Backup prüfen und ggf. Wiederherstellen
    if [[ -f "$BACKUP/$file" ]]; then
        cp "$FULL_PATH" "$QUARANTINE/${file}_$(date +%s)"
        cp "$BACKUP/$file" "$FULL_PATH"
        echo "$TIMESTAMP | Wiederhergestellt aus Backup: $file" >> "$LOG_FILE"
    else
        cp "$FULL_PATH" "$BACKUP/$file"
        echo "$TIMESTAMP | Neuer Backup-Eintrag: $file" >> "$LOG_FILE"
    fi

    # 🧙 IP des Angreifers sichtbar machen
    echo "$TIMESTAMP | Suche nach verdächtigem Ursprung..." >> "$LOG_FILE"
    netstat -tnp 2>/dev/null | grep ESTABLISHED >> "$LOG_FILE"

    SUSPECT_IP=$(netstat -tnp 2>/dev/null | grep ESTABLISHED | awk '{print $5}' | cut -d: -f1 | sort | uniq | head -n 1)

    if [[ ! -z "$SUSPECT_IP" ]]; then
        echo "$TIMESTAMP | Verdächtige IP entdeckt: $SUSPECT_IP" >> "$LOG_FILE"

        echo "[AUREON] Starte Gegenscan gegen $SUSPECT_IP" >> "$SCAN_LOG"
        whois $SUSPECT_IP >> "$SCAN_LOG"
        nmap -Pn -sS -T4 $SUSPECT_IP >> "$SCAN_LOG"

        echo "$TIMESTAMP | Gegenscan abgeschlossen. Ergebnisse in $SCAN_LOG" >> "$LOG_FILE"
    else
        echo "$TIMESTAMP | Keine verdächtige IP erkennbar (lokaler Zugriff?)" >> "$LOG_FILE"
    fi

done
