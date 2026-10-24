# Práctica individual · Bases de datos en la nube

**Estudiante:** Jael Adrián González Cruz · **Matrícula:** 240784 · **Grupo:** 7A
**Programa:** Ingeniería en Tecnologías de la Información e Innovación Digital
**Docente:** M.T.I. Marco Antonio Ramírez Hernández

Este proyecto reúne el manual de PostgreSQL local y el despliegue individual del VPS. Para cubrir el instrumento de Unidad 1, el proyecto Docker Compose del VPS incluye PostgreSQL, MySQL, pgAdmin y phpMyAdmin. PostgreSQL local se documenta como instalación nativa de Windows; no se afirma que Docker local haya sido ejecutado.

## Entregables

- [Reporte técnico](Reporte_Unidad1_240784.pdf)
- [`docker-compose.yml`](docker-compose.yml) y [`.env.example`](.env.example)
- [Esquemas y roles PostgreSQL](sql/postgresql.sql) y [MySQL](sql/mysql.sql)
- [Pruebas SQL de demostración PostgreSQL](sql/pruebas_postgresql.sql) y [MySQL](sql/pruebas_mysql.sql)
- [Capturas de paneles y registro de evidencias](evidencias/)

## Puertos y enlaces

| Servicio | Acceso | Puerto interno | Protocolo |
|---|---|---:|---|
| PostgreSQL | `cityreport.com.mx:40784` | 5432 | TCP/SQL |
| MySQL | `cityreport.com.mx:40785` | 3306 | TCP/SQL |
| phpMyAdmin | `http://cityreport.com.mx:40786` | 80 | HTTP/web |
| pgAdmin | `http://cityreport.com.mx:40787` | 80 | HTTP/web |

El registro DNS A de `cityreport.com.mx` apunta a `177.7.61.91`; los puertos se indican en los clientes o URLs y no forman parte del registro DNS.

## Preparar y desplegar en el VPS

Usa `/home/Gonzalez` como raíz del proyecto. Crea `.env` desde la plantilla, sustituye todos los marcadores por secretos únicos y conserva el archivo privado:

```bash
cd /home/Gonzalez
cp .env.example .env
chmod 600 .env
nano .env
docker compose config --quiet
docker compose up -d
docker compose ps
docker compose logs --tail=100 postgres mysql pgadmin phpmyadmin
```

El proyecto usa volúmenes nombrados. `docker compose down` conserva esos datos; `docker compose down -v` los elimina. No ejecutes el último comando para resolver problemas de contraseñas.

## Aplicar los esquemas

Los archivos SQL son plantillas para una base `db_test` nueva. Antes de usarlos sobre una base con datos, genera un respaldo y compara las columnas existentes. Los marcadores `CAMBIAR_PASSWORD_*` deben reemplazarse localmente; no publiques esas sustituciones.

PostgreSQL: el usuario administrador inicial de Compose puede ejecutar el script:

```bash
docker compose cp sql/postgresql.sql postgres:/tmp/postgresql.sql
docker compose exec postgres sh -lc 'psql -U "$POSTGRES_USER" -d db_test -v ON_ERROR_STOP=1 -f /tmp/postgresql.sql'
```

MySQL: usa root dentro del contenedor para crear roles y cuentas. `MYSQL_ADMIN_USER` solo recibe permisos sobre la base y no puede administrar cuentas globales:

```bash
docker compose cp sql/mysql.sql mysql:/tmp/mysql.sql
docker compose exec mysql mysql -uroot -p db_test
```

En el prompt de MySQL escribe la contraseña root de `.env` cuando la solicite y ejecuta:

```sql
SOURCE /tmp/mysql.sql;
```

Las pruebas `sql/pruebas_*.sql` son demostraciones reversibles y terminan con `ROLLBACK`. No sustituyen los diez casos específicos que proporcione el docente; reemplázalas o complétalas con esos enunciados y guarda una captura real por prueba.

## Revisión de este manual · 24 de octubre de 2026

- Hostinger informa que el VPS `177.7.61.91` está encendido con Debian 13, plan KVM 2, 2 vCPU, 8 GB de RAM y disco de 100 GB.
- Desde esta PC se resolvió `cityreport.com.mx` a `177.7.61.91` y se comprobó respuesta TCP en `40784`, `40785`, `40786` y `40787`. Esto confirma alcance de puertos, no autenticación de base ni estado `healthy` de contenedores.
- El administrador de Docker de Hostinger no entrega el listado de proyectos para este sistema operativo; la conexión SSH por llave configurada fue rechazada. Por ello, el `docker compose ps`, los logs y una conexión SQL autenticada del VPS deben recapturarse desde una sesión autorizada.
- En esta PC no está instalado Docker CLI ni se detectó un servicio PostgreSQL. La guía incluye los pasos locales, pero la ejecución local se debe demostrar en el equipo que se utilizará para la entrega.
- Las capturas de pgAdmin y phpMyAdmin incluidas en el reporte son las imágenes aportadas en la versión anterior del documento. Las transcripciones de `evidencias/06_pruebas_*.txt` no son salidas crudas de los clientes SQL ni reemplazan capturas de consultas reproducibles.
- Las imágenes `evidencias/07_postgresql_local_terminal.png`, `08_postgresql_vps_terminal.png` y `09_mysql_vps_terminal.png` son resúmenes visuales, no capturas de sesiones crudas verificadas. No deben presentarse como evidencia de ejecución.

## Estado de Git y entrega

`main` contiene el merge histórico de Práctica 02. `Practica03` parte de `main` y sigue sin fusionarse. En GitHub existe una sola rama Manual, que se desprende del commit de documentación común anterior al merge de P02; por eso aparece como línea independiente y no incluye todavía esa integración. Esta revisión quedó comprometida localmente, pero no se pudo publicar en GitHub: las credenciales conectadas no tienen permiso de escritura para el repositorio. No se fusionó ni reescribió ninguna rama en esta revisión. El bundle `.git/manual-local-70aa754-backup.bundle` conserva una copia del historial previo de Manual. La lista de verificación pide fusionar el manual a `main` y un repositorio privado; ambos puntos siguen pendientes.

## Seguridad

No subas `.env`, respaldos con datos, llaves privadas ni contraseñas reales. El repositorio remoto es público; las credenciales deben entregarse solo mediante un canal autorizado y separado del repositorio.
