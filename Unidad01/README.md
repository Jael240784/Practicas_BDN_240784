# Unidad 1 · Infraestructura y conexiones

[Inicio del repositorio](../README.md) / **Infraestructura**

> **Entrega** · Instalación de MySQL y PostgreSQL, configuración con Compose y evidencia de conexión.

**En esta guía** · [Instalación](#instalación-y-validación) · [Reporte](Reporte_Unidad1_240784.pdf) · [Evidencias](evidencias/)

---

## Instalación y validación

| Recurso | Contenido |
|---|---|
| [Docker Compose](docker-compose.yml) | MySQL, PostgreSQL, phpMyAdmin y pgAdmin |
| [Plantilla de variables](.env.example) | Variables del despliegue |
| [Reporte de Unidad 1](Reporte_Unidad1_240784.pdf) | Desarrollo y evidencia |
| [Evidencias](evidencias/) | Capturas y verificaciones |
| [SQL auxiliar](sql/) | Pruebas, ajustes e importación |
| [Inicialización MySQL](mysql/init/) y [PostgreSQL](postgres/init/) | Esquemas iniciales y roles |

Para validar la configuración, ejecuta `docker compose --env-file .env config --quiet` desde esta carpeta. La matriz de cuentas y roles se encuentra en la [Práctica 02](../Practica02/readme.md).
