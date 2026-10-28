# Política de seguridad

## Versiones soportadas

Este repositorio es una configuración de referencia que se mantiene en su rama principal. Solo se atiende la última versión publicada en ella.

## Cómo comunicar una vulnerabilidad

Usa el **aviso privado de vulnerabilidades de GitHub**: en la pestaña *Security* del repositorio, elige *Report a vulnerability*. De este modo el informe es privado hasta que se corrija. Por favor, no abras una incidencia pública ni pongas detalles en un comentario.

## Qué se considera dentro de alcance

- Datos sensibles que hayan quedado publicados por error (credenciales, direcciones reales, identificadores).
- Configuraciones del repositorio que expongan servicios de forma insegura o amplíen el acceso más de lo necesario.
- Fallos en las utilidades y tareas programadas incluidas que permitan ejecutar órdenes no previstas.

Quedan fuera de alcance los problemas de Home Assistant, Caddy, Docker u otros programas de terceros: comunícalos a sus responsables. Tampoco se atienden pruebas contra instalaciones ajenas.

## Qué incluir en el aviso

- Qué fichero o configuración está afectado.
- Cómo reproducirlo o comprobarlo.
- Qué impacto crees que tiene.

Sin datos sensibles reales en el informe: si has encontrado uno publicado, indica solo el fichero y la línea, no el valor.

## Plazo orientativo

Se procurará acusar recibo en unos días y corregir lo confirmado cuanto antes. Es un proyecto personal, por lo que no hay un plazo garantizado.
