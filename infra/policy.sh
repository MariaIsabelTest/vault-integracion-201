#!/usr/bin/env bash
# Registra una policy leyendo el HCL por la entrada estándar.
# Uso:
#   bash infra/policy.sh solo-pagos <<'EOF'
#   path "secret/data/pagos/api" {
#     capabilities = ["read"]
#   }
#   EOF
set -euo pipefail
name="${1:?falta el nombre de la policy}"
dest="/tmp/policy-${name}.hcl"
docker exec -i vault-dev tee "$dest" >/dev/null
docker exec \
  -e VAULT_ADDR=http://127.0.0.1:8200 \
  -e VAULT_TOKEN="${VAULT_TOKEN:-root}" \
  vault-dev vault policy write "$name" "$dest"
echo "Policy ${name} escrita."
