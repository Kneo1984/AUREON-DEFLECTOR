#!/data/data/com.termux/files/usr/bin/bash
while true; do
  CHANGES=$(git status --porcelain)
  if [ ! -z "$CHANGES" ]; then
    echo "$(date) – Änderung erkannt, Git-Push wird ausgeführt..." >> ~/AUREON/logs/gitwatch.log
    git add . && \
    git commit -m "🛡️ AUREON Auto-Sync – Selbstschutz-Modus aktiv" && \
    git push origin main >> ~/AUREON/logs/gitwatch.log 2>&1
  fi
  sleep 60
done
