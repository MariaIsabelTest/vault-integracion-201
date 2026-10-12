# M04 — Autenticación

[← Página anterior](../M03-policies-y-tokens/03-lab-dos-perfiles.md) · [Siguiente página →](00-userpass-y-approle.md)

El token del módulo anterior lo has fabricado tú con `vault token create`. Una aplicación no hace eso: se autentica con un método y Vault le entrega el token. Esta es la diferencia que tiene que respetar el test.

## Qué aprenderás

- Entrar como persona con UserPass.
- Entrar como aplicación con AppRole (`role_id` + `secret_id`).
- Ver que el token resultante solo puede lo que dice su policy.
- Acotar la sesión de una persona y gastar un `secret_id` sin invalidar el token ya emitido.

## Teoría

| Método | Quién lo usa | Qué secreto de entrada guarda |
|--------|----------------|-------------------------------|
| Token | Esta práctica, y poco más en producción | El propio token |
| UserPass | Una persona | Usuario y contraseña |
| AppRole | Una aplicación o un pipeline | `role_id` (casi público) y `secret_id` (secreto) |

El `secret_id` no es el secreto de la API de pagos. Es la credencial para obtener un token. Si el test los mezcla, el caso no prueba la integración.

## Páginas

| # | Página | Qué hay |
|---|--------|---------|
| 00 | [UserPass y AppRole](00-userpass-y-approle.md) | Los dos logins, de principio a fin |
| 01 | [AppRole](01-lab-approle.md) | Login de aplicación y un `secret_id` que no vale |
| 02 | [UserPass](02-lab-userpass.md) | Persona, contraseña, TTL del método y 403 |
| 03 | [secret_id de un solo uso](03-lab-secret-id-un-uso.md) | El segundo login falla; el token del primero sigue |

→ Empieza por **[00 — UserPass y AppRole](00-userpass-y-approle.md)**.
