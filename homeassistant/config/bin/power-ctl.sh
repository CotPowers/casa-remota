#!/bin/sh
# Puente Home Assistant -> power-ctl del host por el tunel. GENERADO por setup-hub-vps.sh
# Uso: power-ctl.sh online | status-json | status | apagar
H=powerctl@<ip-privada-8>
O="-i /config/.ssh/power_ed25519 -o UserKnownHostsFile=/config/.ssh/known_hosts -o StrictHostKeyChecking=yes -o BatchMode=yes -o ConnectTimeout=5"
case "$1" in
  online)
    if ping -c1 -W3 <ip-privada-8> >/dev/null 2>&1; then echo on; else echo off; fi ;;
  status-json)
    out=$(ssh $O $H status 2>/dev/null) || { echo '{"error":"sin conexion"}'; exit 0; }
    echo "$out" | awk '{printf "{"; for(i=1;i<=NF;i++){split($i,a,"="); printf "%s\"%s\":\"%s\"", (i>1?",":""), a[1], a[2]} print "}"}' ;;
  status|apagar)
    ssh $O $H "$1" 2>&1 ;;
  *)
    echo "orden no permitida: $1"; exit 1 ;;
esac
