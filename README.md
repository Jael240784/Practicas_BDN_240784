# Manual de instalación · Bases de Datos en la Nube

**Estudiante:** Jael Adrián González Cruz · **Matrícula:** 240784 · **Grupo:** 7A  
**Asignatura:** Bases de Datos en la Nube · **Programa:** Ingeniería en Tecnologías de la Información e Innovación Digital

Guía de PostgreSQL en laboratorio local compartido y en VPS individual, con MySQL 8.4 y sus paneles web en el VPS. El PDF contiene portada, índice, procedimientos, evidencia visual, pruebas y matriz de cobertura de la lista de cotejo.

## Documento principal

[Descargar el manual completo en PDF](Manual_PostgreSQL_Local_y_VPS_240784.pdf)

## Servicios documentados

| Entorno / servicio | Acceso |
|---|---|
| PostgreSQL local compartido | `127.0.0.1:40784` · base `db_test` · PostgreSQL 18.6 |
| phpMyAdmin del VPS | <http://cityreport.com.mx:40784> · motor `mysql:3306` dentro de Docker |
| pgAdmin del VPS | <http://cityreport.com.mx:40785> · servidor `postgres:5432` dentro de Docker · base `db_test` |

Los puertos `40784` y `40785` son HTTP para los paneles. Los puertos SQL `3306` y `5432` no están publicados para clientes externos. En pgAdmin alojado en el VPS, `postgres:5432` es la dirección interna del servicio. Las claves privadas se mantienen fuera de Git.

## Evidencia y archivos de apoyo

- `evidencias/local_compartido/`: capturas del laboratorio compartido que aparecen en el manual.
- `evidencias/local_actual/`: transcripción de verificación PostgreSQL y consulta de referencia; la transcripción registra pruebas revertidas con `ROLLBACK`.
- `evidencias/vps_actual/`: capturas de phpMyAdmin con `db_test` y pgAdmin conectado al PostgreSQL del VPS.
- `sql/consultas_verificacion_postgresql.sql`: consultas de solo lectura para revisar conexión, tablas, vistas, usuarios y productos en `db_test`.

Las capturas locales representan el equipo compartido. Las capturas del VPS muestran la instancia individual documentada. No se incluyen archivos `.env`, contraseñas ni datos privados de acceso.

## Estado y alcance

La validación local adicional confirmó seis usuarios, dos productos, cuatro tablas consultadas y dos vistas; las operaciones temporales se revirtieron. La matriz incluida en el PDF diferencia evidencia disponible y puntos que no se pudieron verificar, como el acceso SQL directo desde Internet y la autenticación de cada cuenta. La rama `Manual_VPS_BDs_Relacionales` se conserva separada de `main`.
