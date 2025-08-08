#!/usr/bin/env python3
import os, datetime

def log(msg):
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(os.path.expanduser("~/AUREON/logs/firewall.log"), "a") as f:
        f.write(f"[{now}] {msg}\n")
    print(f"🛡️ {msg}")

def activate_omega():
    log("OMEGA-FIREWALL wird aktiviert...")
    os.system("iptables -F")
    os.system("iptables -X")
    os.system("iptables -P INPUT DROP")
    os.system("iptables -P FORWARD DROP")
    os.system("iptables -P OUTPUT ACCEPT")
    os.system("iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT")
    os.system("iptables -A INPUT -i lo -j ACCEPT")
    os.system("pkill tor || true")
    os.system("tor &")
    log("TOR-Verbindung gestartet.")
    os.system('iptables -A INPUT -p tcp --dport 23 -j LOG --log-prefix "TRAP DETECTED: "')
    log("Traffic-Trap aktiv.")
    os.system("iptables -A OUTPUT -p udp --dport 53 -j DROP")
    log("Externe DNS-Anfragen blockiert.")
    log("OMEGA-FIREWALL vollständig aktiv.")

if __name__ == "__main__":
    activate_omega()
