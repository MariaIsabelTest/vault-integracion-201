#!/usr/bin/env bash
# En el Codespace, Vault corre en el Docker del anfitrión y el puerto 8200
# no es el localhost de la terminal. Este puente lo deja en 127.0.0.1:8200.
# En Docker local, si el puerto ya responde, no hace nada.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

responde() {
  local code
  code="$(curl -s -m 2 -o /dev/null -w '%{http_code}' http://127.0.0.1:8200/v1/sys/health || true)"
  [[ "$code" != "000" && -n "$code" ]]
}

if responde; then
  exit 0
fi

if [[ ! -f /.dockerenv ]]; then
  echo "Vault no responde en http://127.0.0.1:8200" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "Falta python3 en el Codespace. Vuelve a crear el codespace para que el arranque lo instale." >&2
  exit 1
fi

cid="$(hostname)"
net="$(docker inspect -f '{{range $k, $v := .NetworkSettings.Networks}}{{$k}}{{"\n"}}{{end}}' vault-dev | head -n 1)"
if [[ -z "$net" ]]; then
  echo "vault-dev no tiene red. Revisa: docker logs vault-dev" >&2
  exit 1
fi
docker network connect "$net" "$cid" >/dev/null 2>&1 || true

vip="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' vault-dev | awk '{print $1}')"
if [[ -z "$vip" ]]; then
  echo "No veo la IP de vault-dev." >&2
  exit 1
fi
printf '%s\n' "$vip" > /tmp/vault-puente.upstream

if [[ ! -f /tmp/vault-puente.pid ]] || ! kill -0 "$(cat /tmp/vault-puente.pid)" 2>/dev/null; then
  nohup python3 "$ROOT/infra/puente.py" >/tmp/vault-puente.log 2>&1 &
  echo $! > /tmp/vault-puente.pid
  disown || true
fi

for _i in $(seq 1 25); do
  if responde; then
    exit 0
  fi
  sleep 0.2
done

echo "El puente a Vault no responde en http://127.0.0.1:8200. Revisa /tmp/vault-puente.log" >&2
exit 1
