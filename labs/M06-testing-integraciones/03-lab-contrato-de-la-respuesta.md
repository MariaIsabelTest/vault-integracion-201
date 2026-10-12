# Contrato de la respuesta

[← Página anterior](02-lab-checklist.md)

Un HTTP 200 con el JSON mal leído es un fallo del test, no de Vault. Un HTTP 404 tampoco basta: la versión puede estar borrada, destruida o no haber existido nunca. Vas a afirmar el cuerpo.

### Objetivo

Ver el 404 de una versión borrada (con `deletion_time` y `destroyed` false), el 200 de la versión anterior, el `KeyError` de leer `data.clave` en un 200, y un `destroyed: true` que `undelete` no revierte.

### Punto de partida

```bash
bash infra/reiniciar-vault.sh
source infra/entorno.sh
```

Servidor vacío. Se usa el token `root` porque aquí se afirma el cuerpo de KV, no la policy. La policy ya tiene su laboratorio.

### En qué consiste

Dos versiones, borrado de la vigente, lectura de la vieja, un parser equivocado sobre un 200 y la destrucción de la versión nueva.

### 1 — Dos versiones

**Acción:**

```bash
vault kv put secret/pagos/api clave=clave-v1
vault kv put secret/pagos/api clave=clave-v2
```

**Por qué:** el contrato que vas a romper necesita una versión vigente y otra que siga siendo legible.

**Resultado esperado:** la segunda escritura dice `version` `2`.

### 2 — Borra la vigente y lee el cuerpo

**Acción:**

```bash
vault kv delete secret/pagos/api
curl -sS -o /tmp/borrada.json -w "http=%{http_code}\n" \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/secret/data/pagos/api"
python3 -c 'import json; d=json.load(open("/tmp/borrada.json"))["data"]; print("data", d["data"]); print("version", d["metadata"]["version"]); print("deletion_time", bool(d["metadata"]["deletion_time"])); print("destroyed", d["metadata"]["destroyed"])'
```

**Por qué:** el 404 solo dice que no hay valor en la última versión. `deletion_time` con contenido y `destroyed` false dicen que se borró y que todavía se puede recuperar. Un camino que nunca se escribió no trae esa metadata de versión.

**Resultado esperado:** `http=404`, `data None`, `version 2`, `deletion_time True`, `destroyed False`.

![Versión 2 borrada: 404, deletion_time presente, destroyed false](../img/M06-03-404.png)

### 3 — La versión 1 sigue en el contrato

**Acción:**

```bash
curl -sS -o /tmp/v1.json -w "http=%{http_code}\n" \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/secret/data/pagos/api?version=1"
python3 -c 'import json; d=json.load(open("/tmp/v1.json")); print(d["data"]["data"]["clave"], d["data"]["metadata"]["version"])'
```

**Por qué:** afirmar «el secreto desapareció» es falso si la versión 1 responde 200. El test tiene que nombrar la versión.

**Resultado esperado:** `http=200`, `clave-v1` y `1`.

![version=1 sigue devolviendo clave-v1](../img/M06-03-v1.png)

### 4 — Recupera y lee el campo en el sitio equivocado

**Acción:**

```bash
vault kv undelete -versions=2 secret/pagos/api
curl -sS -o /tmp/ok.json -w "http=%{http_code}\n" \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/secret/data/pagos/api"
python3 -c 'import json; print(json.load(open("/tmp/ok.json"))["data"]["clave"])' || true
python3 -c 'import json; print(json.load(open("/tmp/ok.json"))["data"]["data"]["clave"])'
```

**Por qué:** el HTTP es 200. El primer Python busca `clave` dentro de `data`, y en KV v2 el valor está en `data.data`. El test que hace esa lectura falla con el secreto bien guardado. El segundo Python es el contrato correcto.

**Resultado esperado:** `http=200`. El primer Python termina con `KeyError: 'clave'`. El segundo imprime `clave-v2`.

![HTTP 200 y KeyError si se lee data.clave; data.data.clave es clave-v2](../img/M06-03-clave.png)

> [!TIP]
> El `|| true` deja seguir la página después del `KeyError`. En un test real ese error es el fallo, no algo que se trague.

### 5 — Destruye y no te fíes del Success

**Acción:**

```bash
vault kv destroy -versions=2 secret/pagos/api
vault kv undelete -versions=2 secret/pagos/api
curl -sS -o /tmp/des.json -w "http=%{http_code}\n" \
  --header "X-Vault-Token: ${VAULT_TOKEN}" \
  "${VAULT_ADDR}/v1/secret/data/pagos/api?version=2"
python3 -c 'import json; d=json.load(open("/tmp/des.json"))["data"]; print("data", d["data"], "destroyed", d["metadata"]["destroyed"])'
```

**Por qué:** `undelete` imprime `Success` también cuando la versión está destruida. La afirmación que distingue «borrada» de «destruida» es `destroyed` en el JSON, no esa línea del CLI.

**Resultado esperado:** `Success` en el undelete, después `http=404`, `data None` y `destroyed True`.

![undelete tras destroy: el cuerpo sigue con destroyed true](../img/M06-03-destroy.png)

## Comprueba tu entendimiento

**La versión 1 después del destroy**
`curl -sS --header "X-Vault-Token: ${VAULT_TOKEN}" "${VAULT_ADDR}/v1/secret/data/pagos/api?version=1" | python3 -c 'import json,sys; print(json.load(sys.stdin)["data"]["data"]["clave"])'`
→ `clave-v1`. Destruiste la 2.

## Reto

### 1 — Afirmar destroyed, no solo el 404

Sobre el cuerpo que ya tienes en `/tmp/des.json`, imprime una línea `ASSERT destroyed` solo si `destroyed` es verdadero. Si no lo es, imprime `ASSERT no`.

<details>
<summary>Ver solución</summary>

```bash
python3 -c 'import json; d=json.load(open("/tmp/des.json"))["data"]["metadata"]; print("ASSERT destroyed" if d["destroyed"] else "ASSERT no")'
```

`ASSERT destroyed`.

</details>

## Errores frecuentes

| Síntoma | Causa probable | Cómo arreglarlo |
|---------|----------------|-----------------|
| El paso 2 es 200 y muestra `clave-v2` | El `delete` no se ejecutó o luego hubo un `put` | `vault kv metadata get secret/pagos/api` y mira `deletion_time` de la versión vigente |
| El primer Python del paso 4 imprime la clave | Estás leyendo `["data"]["data"]["clave"]` | El fallo buscado es `["data"]["clave"]`, sin el segundo `data` |
| `destroyed` sale false tras el paso 5 | `destroy` no llegó a la versión 2 | `vault kv destroy -versions=2 secret/pagos/api` y repite el `curl` con `?version=2` |
