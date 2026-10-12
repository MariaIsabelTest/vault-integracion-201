# Diseñar las pruebas

[← Página anterior](README.md) · [Siguiente página →](01-lab-escenarios-de-fallo.md)

Antes de romper nada, la ficha del caso dice qué preparas, qué haces y qué tiene que pasar. Esta página usa un servidor nuevo y una sola aplicación de prueba.

## Punto de partida

```bash
bash infra/reiniciar-vault.sh
source infra/entorno.sh
```

## Recorrido

1. La aplicación de referencia hace login AppRole y lee `secret/data/pagos/api`. En el caso feliz imprime la clave y el HTTP es 200. Si el login falla, no llega a haber HTTP de lectura: el fallo es 400 en `/auth/approle/login` y el informe se queda ahí.

2. La ficha de cada caso, la que usarías en un checklist:

| Caso | Preparación | Acción | Resultado que afirmas |
|------|-------------|--------|------------------------|
| Token caducado | Token con TTL de 5 segundos y policy de lectura | Esperar 6 segundos y leer | No hay clave. Error 403 |
| Permiso insuficiente | Token cuya policy no incluye ese `data/` | Leer `secret/pagos/api` | 403 y `permission denied`. El secreto sigue existiendo con `root` |
| Secreto inexistente | Login válido, camino `secret/pagos/no-existe` | Leer | 404. El login no se repite: ya había token |
| Rotación | Versión 2 escrita, la prueba pide `?version=1` | Leer | HTTP 200 y la clave antigua. El fallo sería afirmar que «ya está la nueva» |
| Cambio en caliente | La app lee, alguien hace `kv put`, la app lee otra vez | Dos lecturas sin reiniciar el proceso | La segunda lectura trae el valor nuevo |
| No disponible | `docker pause` del contenedor | `curl` con `--max-time 3` | No hay HTTP 200 ni 403. Es timeout o conexión rechazada. Al quitar la pausa, el secreto sigue |

3. Lo que no entra en esta ficha: instalar Vault, desellar el clúster de producción, ni probar un motor que esta aplicación no usa. Si el equipo nombra otro engine en la sesión, se añade un caso con el mismo esquema (preparación, acción, resultado), no se diluye este.

## Qué queda visto

Cada fallo tiene un sitio distinto. El [laboratorio](01-lab-escenarios-de-fallo.md) ejecuta la tabla en un servidor limpio.
