# Manual de instalación · Bases de Datos en la Nube

**Estudiante:** Jael Adrián González Cruz · **Matrícula:** 240784 · **Grupo:** 7A  
**Asignatura:** Bases de Datos en la Nube · **Programa:** Ingeniería en Tecnologías de la Información e Innovación Digital

Este entregable documenta PostgreSQL en el laboratorio local y en el VPS individual, además de MySQL 8.4 y sus paneles web en el VPS. Incluye portada, índice, objetivo, pasos de instalación y configuración, consultas, persistencia, capturas y una matriz de cobertura de la lista de cotejo.

## PDF

[Descargar el manual completo](Manual_PostgreSQL_Local_y_VPS_240784.pdf)

## Entornos documentados

| Entorno / servicio | Dirección o configuración |
|---|---|
| Laboratorio local compartido | PostgreSQL con Docker Compose y pgAdmin |
| Validación local adicional | PostgreSQL 18.6 · `127.0.0.1:40784` · `db_test`; transacción de prueba revertida con `ROLLBACK` |
| PostgreSQL en VPS | pgAdmin web: <http://cityreport.com.mx:40785> · motor `postgres:5432` interno |
| MySQL en VPS | phpMyAdmin web: <http://cityreport.com.mx:40784> · motor `mysql:3306` interno |

Los dos paneles web respondieron HTTP 200 el 26/10/2026. Esa comprobación confirma que cargan sus interfaces, no que se haya autenticado con cada cuenta ni que los puertos SQL sean accesibles desde Internet. No se publican contraseñas ni archivos `.env`.

## Alcance y estado de la evidencia

- Las capturas del laboratorio local son compartidas; las capturas señaladas como VPS corresponden al entorno individual documentado.
- La validación local adicional confirmó seis tablas, dos vistas y operaciones de prueba sobre `db_test`; los cambios de prueba se revirtieron.
- La matriz del PDF distingue los resultados documentados de los puntos pendientes. Los accesos SQL externos a 40784/40785 no están habilitados porque esos puertos corresponden a phpMyAdmin y pgAdmin.
- La fusión con `main` permanece pendiente para conservar separada la rama `Manual_VPS_BDs_Relacionales`.
