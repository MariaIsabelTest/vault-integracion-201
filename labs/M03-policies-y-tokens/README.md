# M03 — Policies, tokens y seguridad

[← Página anterior](../M02-secretos-y-api/01-lab-versiones-y-api.md) · [Siguiente página →](00-policies-tokens-auditoria.md)

El token `root` del laboratorio no sirve para afirmar que una aplicación «puede leer el secreto». Puede leerlo todo. Una prueba de autorización usa un token recortado por una policy, con caducidad.

## Qué aprenderás

- Escribir una policy que solo lee un camino.
- Emitir un token con esa policy y ver un 403 en el camino de al lado.
- Ver que el token caduca y que la auditoría guarda la petición, no una excusa en el log de la app.

## Teoría

La policy no nombra a la persona. Nombra caminos y capacidades (`read`, `create`, `update`, `list`, `delete`). El token lleva pegada una o varias policies.

En KV v2 el camino de la policy es `secret/data/pagos/api` para leer el valor. `secret/pagos/api` en la policy no coincide con la API y el token recibe 403 con el secreto bien escrito.

## Páginas

| # | Página | Qué hay |
|---|--------|---------|
| 00 | [Policies, tokens y auditoría](00-policies-tokens-auditoria.md) | Un token que solo lee pagos |
| 01 | [Permisos y TTL](01-lab-permisos-y-ttl.md) | 403, caducidad y rastro de auditoría |

→ Empieza por **[00 — Policies, tokens y auditoría](00-policies-tokens-auditoria.md)**.
