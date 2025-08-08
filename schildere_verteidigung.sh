#!/data/data/com.termux/files/usr/bin/bash
echo "🛡️ AUREON VERTEIDIGUNGSAUSKUNFT:"
echo "🔁 Git-AutoSync:        AKTIV"
echo "🔒 Selbstschutz-Modus:  AKTIV"
echo "📡 Remote-Sync alle:    60 Sekunden"
echo "📂 Überwachtes Verzeichnis: ~/"
echo "📜 Logfile:             ~/AUREON/logs/gitwatch.log"
echo "📥 Letzter Eintrag:"
tail -n 3 ~/AUREON/logs/gitwatch.log
