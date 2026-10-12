# M01 — Introducción y arquitectura

[← Página anterior](../../README.md) · [Siguiente página →](00-arquitectura-vault.md)

Vault ya está en SELAE. Este módulo pone nombre a las piezas que vas a ver cuando pruebes una integración: dónde vive el secreto, quién puede leerlo y con qué credencial entra la aplicación.

## Qué aprenderás

- Qué problema evita Vault frente a un secreto escrito en el código o en un fichero.
- Qué es un secret engine, un auth method, un token y una policy.
- En qué se diferencia el Vault de este laboratorio del de producción.

## Teoría

| Pieza | Para qué sirve cuando pruebas |
|-------|-------------------------------|
| Secret engine | Dónde está el dato (`secret/` es KV). Si pruebas otro camino, no es el mismo API. |
| Auth method | Cómo entra la aplicación (token, usuario, AppRole…). |
| Token | La credencial de sesión, con caducidad. |
| Policy | La lista de caminos permitidos. Un 403 casi siempre es esto, no «Vault está caído». |

> [!NOTE]
> El laboratorio arranca Vault en modo dev: no está sellado y el token `root` lo puede todo. En producción el nodo arranca sellado y nadie usa `root` para probar.

## Páginas

| # | Página | Qué hay |
|---|--------|---------|
| 00 | [Arquitectura](00-arquitectura-vault.md) | Recorrido por el estado del servidor y el primer mapa de caminos |
| 01 | [Primer secreto](01-lab-primer-secreto.md) | Escribes y lees un secreto, por CLI y por API |

→ Empieza por **[00 — Arquitectura](00-arquitectura-vault.md)**.
