# M02 — Secretos y API

[← Página anterior](../M01-introduccion-vault/04-lab-dos-motores.md) · [Siguiente página →](00-cli-api-y-kv.md)

Lo que prueba un test de integración no es «Vault funciona». Es una versión concreta de un secreto, leída por el mismo camino HTTP que usa la aplicación.

## Qué aprenderás

- Escribir y leer KV v2 por CLI y por API.
- Pedir la versión actual y una versión anterior.
- Sacar un campo a una variable, que es lo que hace un script de arranque.
- Distinguir una versión borrada, una destruida y un listado de caminos.

## Teoría

KV v2 no pisa el valor: guarda versiones. `vault kv put` otra vez crea la versión 2. La aplicación, si no pide versión, recibe la última. Un test que fija `version=1` sigue viendo la clave vieja: eso es una rotación mal comprobada, no un fallo de Vault.

El CLI acepta `secret/pagos/api`. La API pide `secret/data/pagos/api`. Son el mismo secreto.

## Páginas

| # | Página | Qué hay |
|---|--------|---------|
| 00 | [CLI, API y KV](00-cli-api-y-kv.md) | Dónde está la versión en la respuesta |
| 01 | [Versiones y API](01-lab-versiones-y-api.md) | Dos versiones, lectura por curl y un script |
| 02 | [Borrar una versión](02-lab-borrar-version.md) | Borrado, recuperación y destrucción |
| 03 | [Listar y variables](03-lab-listar-y-variables.md) | Caminos y el campo que arranca la aplicación |

→ Empieza por **[00 — CLI, API y KV](00-cli-api-y-kv.md)**.
