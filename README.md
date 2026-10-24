# Manual de instalación de PostgreSQL · Local y VPS

**Universidad Tecnológica de Xicotepec de Juárez**  
**Estudiante:** Jael Adrián González Cruz · **Matrícula:** 240784 · **Grupo:** 7A  
**Programa:** Ingeniería en Tecnologías de la Información e Innovación Digital  
**Asignatura:** Bases de Datos en la Nube · **Docente:** M.T.I. Marco Antonio Ramírez Hernández

Guía de instalación, configuración y verificación de PostgreSQL con Docker Compose en el equipo local compartido y en el VPS individual. Incluye pgAdmin, MySQL y phpMyAdmin en el VPS, roles, vistas, respaldos y pruebas reversibles.

## Manual completo

[**Abrir o descargar el PDF**](Manual_PostgreSQL_Local_y_VPS_240784.pdf)

## Acceso actual

| Servicio | Acceso | Red/puerto del contenedor |
|---|---|---|
| PostgreSQL VPS | Solo desde la red Docker; pgAdmin usa `postgres` | `postgres:5432` |
| MySQL VPS | Solo desde la red Docker; phpMyAdmin usa `mysql` | `mysql:3306` |
| phpMyAdmin | http://cityreport.com.mx:40784 | `80/tcp` |
| pgAdmin | http://cityreport.com.mx:40785 | `80/tcp` |
| PostgreSQL local | `127.0.0.1:5432` | `5432/tcp` |
| pgAdmin local | `http://localhost:8080` | `80/tcp` |

Los puertos públicos `40784` y `40785` corresponden a los paneles web. Los motores de base de datos no publican puertos SQL al host. El VPS permite actualmente el acceso web desde cualquier IP; limita el origen de esas reglas a IP confiables para uso continuo.

> Las credenciales y secretos se omiten del repositorio. Las capturas de pruebas SQL del VPS identifican la configuración anterior al cambio de puertos; el panel y el despliegue descritos reflejan la configuración actual.

---

**Bases de Datos en la Nube · Unidad 1 · 2026**
