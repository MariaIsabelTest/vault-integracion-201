# M05 — Integración con aplicaciones

[← Página anterior](../M04-autenticacion/01-lab-approle.md) · [Siguiente página →](00-integrar-aplicacion.md)

El Departamento de Test no administra el clúster: comprueba que una aplicación obtiene el secreto. Este módulo deja ese consumo por escrito, en un script (lo que haría un job de CI) y con Vault Agent (lo que haría un proceso que renderiza un fichero).

## Qué aprenderás

- El orden real: login AppRole, token, lectura del secreto.
- Inyectar la clave en una variable sin dejar `root` en la aplicación.
- Qué hace Vault Agent con una plantilla, para reconocerlo cuando lo veas en un despliegue.

## Teoría

Un pipeline no «tiene Vault». Tiene `role_id` y `secret_id` en el entorno, hace el POST de login y usa el token solo para esa ejecución. Si el job guarda el token `root`, la prueba no representa la integración.

Vault Agent es el mismo login, hecho por un proceso que escribe el secreto ya renderizado en un fichero. La aplicación lee el fichero y no habla con Vault. El test, entonces, mira el fichero y no un `vault kv get` lanzado a mano.

## Páginas

| # | Página | Qué hay |
|---|--------|---------|
| 00 | [Integrar una aplicación](00-integrar-aplicacion.md) | Script de CI y render de Agent |
| 01 | [Consumo automático](01-lab-consumo-automatico.md) | Los dos caminos, desde un servidor vacío |

→ Empieza por **[00 — Integrar una aplicación](00-integrar-aplicacion.md)**.
