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

- El VPS `177.7.61.91` responde con Debian 13. El proyecto de Jael está en `/home/Gonzalez`, sin carpeta `Gonzalez` anidada.
- `sudo docker compose config --quiet` terminó correctamente. Los cuatro contenedores PostgreSQL, MySQL, pgAdmin y phpMyAdmin están activos; PostgreSQL y MySQL reportan `healthy`. El contenedor PostgreSQL publica `40784:5432`.
- Desde esta PC se autenticó una conexión a PostgreSQL en `cityreport.com.mx:40784`, base `db_test`. Se consultaron roles, membresías, usuarios de aplicación y vistas de trazabilidad. También se ejecutaron diez operaciones demostrativas y se revirtieron con `ROLLBACK`.
- PostgreSQL 18.6 está instalado nativamente en este equipo y responde en `127.0.0.1:40784`. Docker Compose local no está instalado ni se reporta como ejecutado; el manual de instalación se limita a PostgreSQL local y PostgreSQL en el VPS.
- Las capturas en `evidencias/` muestran sesiones y paneles reales. `13_captura_postgresql_local.png` y `14_captura_postgresql_vps.png` son recortes reales de las salidas, preparados para que se lean sin mostrar la ruta del perfil local. `15_pgadmin_servidor_db_test.png` muestra el árbol de pgAdmin ampliado y la base `db_test`. En la tabla del manual, la cuenta `not_registered` aparece con un seudónimo neutral. Las transcripciones `06_pruebas_local_pg.txt` y `06_pruebas_vps_pg.txt` registran las operaciones. Los archivos `10_vps_compose_2026-10-24.txt`, `11_postgres_roles_vps_2026-10-24.txt` y `12_vps_firewall_2026-10-24.txt` conservan las comprobaciones del servidor.
- Los logs de PostgreSQL de las últimas 24 horas no mostraron errores críticos con el filtro usado. UFW está activo; sus reglas actuales permiten `40784` a cualquier IPv4/IPv6. La guía señala cómo restringirlo a una IP autorizada; esta revisión no modificó el firewall.

## Estado de Git y entrega

La rama `Manual_VPS_BDs_Relacionales` se conserva separada de `main` y `Practica03`; esta guía no hace una fusión. Las modificaciones del manual y sus evidencias se registran en esta rama. El repositorio es público, por lo que `.env`, `privado/`, volcados y contraseñas deben permanecer fuera de Git.

## Seguridad

No subas `.env`, respaldos con datos, llaves privadas ni contraseñas reales. El repositorio remoto es público; las credenciales deben entregarse solo mediante un canal autorizado y separado del repositorio.
