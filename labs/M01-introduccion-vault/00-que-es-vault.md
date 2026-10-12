# Qué es Vault

[← Página anterior](README.md) · [Siguiente página →](01-arquitectura-vault.md)

Quien mantiene sistemas acaba con las contraseñas, los tokens y las claves de API repartidos por el código y por la infraestructura. Esta página sigue el recorrido del vídeo [Seguridad con Vault](https://www.youtube.com/watch?v=ZOEDItZJaZM): el problema, qué centraliza Vault, el secreto que caduca, la arquitectura de confianza cero y los casos de uso. Los fotogramas son los de ese vídeo.

## Dispersión de secretos

![Dispersión de secretos: proliferación de contraseñas y claves API esparcidas por código e infraestructura](../img/M01-que-es-dispersion.jpg)

- Los datos sensibles de la organización acaban en texto plano, en más de un sitio.
- Pasa cuando las contraseñas, los tokens y las claves de API se copian sin un sitio único que las controle.

![Vulnerabilidades: el archivo .env sin asegurar en el centro, unido al código, a la configuración, al repositorio y a la tubería](../img/M01-que-es-vulnerabilidades.jpg)

- El secreto queda escrito en el código.
- Se queda en un fichero de configuración que nadie ha protegido. En el fotograma, ese fichero es el `.env`.
- Sube al repositorio.
- Circula por la tubería de integración, Jenkins o GitLab.
- Si cae uno de esos ficheros, el resto de la red queda expuesto.

## La ruta

![Ruta del vídeo: dispersión de secretos, qué es Vault, secretos dinámicos, arquitectura zero trust y casos de uso](../img/M01-que-es-ruta.jpg)

1. Dispersión de secretos.
2. Qué es Vault.
3. Secretos dinámicos.
4. Arquitectura de confianza cero.
5. Casos de uso.

## Qué es Vault

![Seguridad con Vault](../img/M01-que-es-titulo.jpg)

![Qué es Vault: HashiCorp Vault como bóveda central](../img/M01-que-es-que-es.jpg)

- Vault es la caja fuerte central. Los secretos dejan el repositorio y viven en un solo servicio.
- El dato guardado va cifrado, y también el tráfico entre Vault y quien lo consulta.

![Contraseñas estáticas, de vida infinita y pegadas al código, frente a secretos dinámicos en una bóveda centralizada](../img/M01-que-es-estatico.jpg)

- La contraseña estática va pegada en el código y no caduca.
- El secreto dinámico sale de la bóveda y dura un contrato de arrendamiento, un *lease*: al vencer, el acceso desaparece.

## Secretos dinámicos

![Secretos dinámicos, los superpoderes de Vault](../img/M01-que-es-dinamicos.jpg)

![Funciones principales: almacenamiento seguro, secretos dinámicos, cifrado como servicio y revocación granular](../img/M01-que-es-funciones.jpg)

- **Almacenamiento seguro.** Pares clave-valor, cifrados antes de guardarse.
- **Secretos dinámicos.** No existen hasta que alguien los pide.
- **Cifrado como servicio.** La aplicación entrega el dato y recibe el resultado. La criptografía la hace Vault.
- **Revocación granular.** Un acceso concreto se corta en el momento, sin esperar a que caduque.

![¿Cómo reducen el riesgo los secretos dinámicos?](../img/M01-que-es-riesgo.jpg)

- La reducción está en el tiempo que el secreto existe.

![Una hora: la credencial de base de datos nace y se revoca al cumplirse el plazo](../img/M01-que-es-hora.jpg)

- Una aplicación que consulta PostgreSQL recibe una credencial nueva en ese instante.
- Esa credencial vale una hora.
- Pasada la hora, Vault la revoca. Quien la copie después ya no entra.

## Arquitectura de confianza cero

![Arquitectura zero trust, confianza cero](../img/M01-que-es-zero.jpg)

![Barrera criptográfica: todo lo que va al almacenamiento sale cifrado](../img/M01-que-es-barrera.jpg)

- Lo que llega al almacenamiento, un disco local o un bucket, ya va cifrado. Quien copie ese disco se lleva datos ilegibles.

![Proceso de desellado: sellado, Shamir, umbral y desellado](../img/M01-que-es-desellado.jpg)

- Al arrancar, Vault está sellado. Sabe dónde están los datos y no puede leerlos: le falta la clave maestra.
- Shamir parte esa clave en fragmentos.
- El umbral pide un mínimo de fragmentos a la vez. Una sola persona no despierta Vault.
- Desellado, Vault ya puede descifrar.

![Autorización estricta: cada petición cruza una puerta antes de llegar al secreto](../img/M01-que-es-auth.jpg)

- Cada petición se autentica. Un servidor presenta un token. Una persona entra por GitHub o por LDAP.
- La policy aplica el mínimo privilegio: ese token lee el camino que le corresponde.

## Casos de uso

![Casos de uso, aplicaciones reales](../img/M01-que-es-casos.jpg)

![De estático a efímero en datos, de texto plano a cifrado en pagos, de clave fija a tokens en la nube](../img/M01-que-es-tabla.jpg)

- **Datos.** El usuario fijo de la base se sustituye por una credencial efímera, creada y destruida con la petición.
- **Pago.** El número de tarjeta no se guarda en claro. La aplicación lo envía al motor de tránsito y almacena el valor cifrado.
- **Nube.** La clave de AWS que no caduca, la del fotograma, se sustituye por un token que muere al terminar el despliegue.

![Usos avanzados: autoridad certificadora, certificado SSH de 10 minutos, X.509 entre microservicios e inyección en Kubernetes](../img/M01-que-es-avanzados.jpg)

- Vault actúa como autoridad certificadora.
- El acceso a un servidor Linux sale como un certificado SSH de 10 minutos. Al terminar el trabajo, el certificado ya no vale.
- Entre microservicios, Vault emite certificados X.509 para que el tráfico vaya con mTLS.
- En Kubernetes, un inyector deja el secreto en la memoria del pod. Quien desarrolla no copia el valor a un fichero.

![Una sola fuente de verdad, registros de auditoría con hashes y cumplimiento automatizado](../img/M01-que-es-fuente.jpg)

- Hay un solo sitio donde vive el secreto. Deja de perderse en correos y en notas.
- Cada petición queda registrada, la concedida y la denegada. El registro guarda un hash, no el secreto.
- Con ese registro se demuestra el cumplimiento de normas como PCI o HIPAA.

![Vault, el corazón criptográfico de las infraestructuras modernas](../img/M01-que-es-corazon.jpg)

- Vault deja el papel de almacén de contraseñas y pasa a ser el sitio que cifra, entrega y revoca.

![¿Debes seguir usando secretos estáticos en la nube?](../img/M01-que-es-pregunta.jpg)

- El vídeo cierra con esa pregunta. En una infraestructura que se crea y se destruye, el secreto que no caduca es el que más tiempo queda expuesto.

## Qué de esto se practica aquí

El [recorrido de arquitectura](01-arquitectura-vault.md) usa un secreto estático en el motor KV, con un token y una policy, en un Vault de laboratorio que arranca ya desellado. Ahí se ve el camino. El sellado de esta página se prueba en [su laboratorio](03-lab-sellado.md). Base de datos, tránsito, certificados y el inyector de Kubernetes quedan en este mapa.
