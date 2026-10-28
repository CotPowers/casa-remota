# casa-remota

Domótica del hogar con Home Assistant, proxy y túnel, configuración anonimizada.

Este repositorio recoge, a modo de portfolio, la configuración de un sistema doméstico que se gestiona de forma remota desde un servidor privado virtual (VPS). El servidor aloja Home Assistant y un proxy inverso; el hogar se conecta a él por un túnel cifrado. Los datos reales (dominios, direcciones, identificadores) están sustituidos por marcadores.

## Qué es

Un conjunto de ficheros de configuración que, juntos, permiten:

- Acceder a Home Assistant desde Internet por HTTPS, con certificado gestionado automáticamente.
- Mantener actualizado el nombre de dominio dinámico del servidor.
- Controlar y supervisar dispositivos del hogar (enchufes inteligentes, aspiradora robot, termo eléctrico) desde un único panel.
- Encender, apagar y vigilar un servidor del hogar a través del túnel.
- Recibir avisos y dar órdenes desde un bot de mensajería, con confirmación para las acciones delicadas.

## Cómo funciona

```
Internet ──► Proxy inverso (HTTPS) ──► Home Assistant ──► nube del fabricante de los enchufes
                                              │
                                              └──► túnel cifrado ──► servidor del hogar (control por SSH)
```

- **Proxy inverso (Caddy).** Recibe el tráfico web, obtiene y renueva el certificado y lo reenvía a Home Assistant por una red interna de contenedores. Home Assistant no se expone directamente a Internet.
- **Home Assistant (contenedor).** Reúne la lógica del hogar. La configuración se organiza en *paquetes*, un fichero por área, de modo que cada función se entiende y se cambia por separado.
- **Tarea programada de DuckDNS.** Actualiza periódicamente la dirección asociada a los subdominios, para que el acceso siga funcionando aunque cambie la IP del servidor.
- **Túnel cifrado.** Une el servidor remoto con el hogar. Home Assistant lo usa para consultar y ordenar el apagado del servidor del hogar mediante una utilidad con órdenes limitadas.
- **Bot de mensajería.** Recibe órdenes (estado, encender, apagar, consumo…) y envía avisos. Las acciones que cortan corriente o apagan equipos piden una confirmación explícita antes de ejecutarse.

## Estructura

| Carpeta o fichero | Contenido |
|---|---|
| `proxy/` | Proxy inverso: composición de contenedores y configuración del sitio. |
| `homeassistant/` | Composición del contenedor de Home Assistant y su carpeta de configuración. |
| `homeassistant/config/` | Configuración principal, automatizaciones, scripts y escenas. |
| `homeassistant/config/packages/` | Un paquete por área: aspiradora, servidor, enchufes, bot de mensajería y termo. |
| `homeassistant/config/bin/` | Utilidad que conecta Home Assistant con el control del servidor del hogar. |
| `homeassistant/config/secrets.yaml.example` | Plantilla de los secretos que esperan los paquetes. |
| `ops/` | Tarea programada que mantiene actualizado el dominio dinámico. |
| `LICENSE` | Licencia del proyecto. |
| `SECURITY.md` | Cómo comunicar un problema de seguridad. |

## Marcadores a sustituir

| Marcador | Qué poner | Dónde aparece |
|---|---|---|
| `<dominio-1>` | Dominio público completo de Home Assistant | `proxy/Caddyfile`, `homeassistant/config/configuration.yaml` |
| `<subdominio-1>` | Subdominio de DuckDNS (sin `.duckdns.org`) | `ops/duckdns.cron` |
| `<fichero-token>` | Ruta del fichero con el token de DuckDNS, solo root | `ops/duckdns.cron` |
| `<ip-privada-8>` | IP del servidor del hogar dentro del túnel | `homeassistant/config/bin/power-ctl.sh` |
| `<ID Servidor Enchufe>` | ID del enchufe que mide el servidor | paquetes `servidor` y `shelly` |
| `<ID Termo Enchufe>` | ID del enchufe del termo | paquetes `termo` y `shelly` |
| `<Chat ID Telegram>` | ID numérico del chat autorizado del bot | paquete `telegram` |
| `<bot-telegram>` | Nombre de usuario del bot | comentario en el paquete `telegram` |

Además, `vacuum.xiaomi` es el `entity_id` genérico de la aspiradora: cámbialo por el de tu integración.

## Instalación genérica

Requisitos: un servidor Linux con Docker y Docker Compose, un nombre de dominio que apunte a él, acceso a un túnel cifrado hacia tu red doméstica y una cuenta en el servicio de dominio dinámico y en la nube de tus dispositivos.

1. **Sustituye los marcadores.** Los ficheros usan marcadores entre ángulos, como `<dominio-1>` o `<ip-privada-8>`. Reemplázalos por tus propios valores en todos los ficheros donde aparezcan.
2. **Crea los secretos.** Los paquetes leen sus credenciales con `!secret`. Copia `homeassistant/config/secrets.yaml.example` a `secrets.yaml` en esa misma carpeta y rellena tus valores (`shelly_get_url` y `shelly_set_url`). El fichero real está ignorado por git.
3. **Crea la red compartida y arranca el proxy.** La composición de Home Assistant se conecta a una red externa que crea la del proxy. Levanta primero `proxy/` y después `homeassistant/` con `docker compose up -d`.
4. **Programa el dominio dinámico.** Instala la tarea de `ops/` en el cron del sistema, guardando el token en un fichero legible solo por el administrador.
5. **Configura la integración del bot** desde la interfaz de Home Assistant y comprueba la configuración antes de reiniciar.

## Anonimización

Todo dato real está sustituido por un marcador. Los marcadores indican el tipo de dato y no corresponden a valores reales. Si adaptas el proyecto, no subas tus valores reales a un repositorio público: guarda los secretos fuera del control de versiones.

## Seguridad

Consulta [`SECURITY.md`](SECURITY.md) para comunicar vulnerabilidades de forma privada.

## Licencia

Consulta el fichero [`LICENSE`](LICENSE).
