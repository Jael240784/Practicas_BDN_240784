# Práctica individual · Base de Datos en la Nube

**Estudiante:** Jael Adrián González Cruz · **Matrícula:** 240784 · **Grupo:** 7A
**Programa:** Ingeniería en Tecnologías de la Información e Innovación Digital
**Docente:** M.T.I. Marco Antonio Ramírez Hernández

Esta entrega reúne el reporte técnico, la configuración Docker Compose del VPS, plantillas SQL sin contraseñas reales y evidencia de pruebas para PostgreSQL y MySQL.

## Entregables

- [Reporte de la Unidad 1](Reporte_Unidad1_240784.pdf)
- [`docker-compose.yml`](docker-compose.yml) y [`.env.example`](.env.example)
- [Plantilla PostgreSQL](sql/postgresql.sql) y [plantilla MySQL](sql/mysql.sql)
- [Pruebas PostgreSQL](sql/pruebas_postgresql.sql) y [pruebas MySQL](sql/pruebas_mysql.sql)
- [Capturas y transcripciones](evidencias/)

## Servicios documentados en el VPS

| Servicio | Dirección | Puerto del contenedor |
|---|---|---:|
| PostgreSQL 18.6 | `cityreport.com.mx:40784` | 5432 |
| MySQL 8.4 | `cityreport.com.mx:40785` | 3306 |
| phpMyAdmin | `http://cityreport.com.mx:40786` | 80 |
| pgAdmin | `http://cityreport.com.mx:40787` | 80 |

DNS apunta `cityreport.com.mx` a `177.7.61.91`; el puerto se añade en la URL o cliente y no forma parte del registro DNS. Configura el firewall para permitir solo las fuentes autorizadas cuando sea posible.

## Despliegue

En una copia de este proyecto dentro del VPS, crea un archivo privado `.env` a partir de la plantilla, reemplaza todos los marcadores por claves únicas y robustas, y luego valida y arranca:

```bash
cp .env.example .env
chmod 600 .env
${EDITOR:-nano} .env
docker compose config --quiet
docker compose up -d
docker compose ps
docker compose logs --tail=100 postgres mysql pgadmin phpmyadmin
```

Carga cada plantilla solo en una base vacía y usando una cuenta administradora. Primero copia el SQL a un directorio privado e introduce allí las contraseñas reales en los marcadores `CAMBIAR_PASSWORD_*`; no guardes esos cambios en Git.

```bash
install -d -m 700 privado
cp sql/postgresql.sql privado/postgresql.sql
cp sql/mysql.sql privado/mysql.sql
chmod 600 privado/*.sql
```

Ejecuta los archivos privados con el cliente de cada motor desde el VPS o desde un cliente autorizado. `postgresql.sql` y `mysql.sql` crean tablas de demostración, roles, cuentas, triggers y vistas; revisa primero las sentencias `CREATE USER` y los permisos. Las contraseñas que sigan como marcadores no son credenciales válidas.

Los archivos `sql/pruebas_postgresql.sql` y `sql/pruebas_mysql.sql` contienen diez operaciones ilustrativas con transacción y `ROLLBACK`. Ejecuta PostgreSQL desde el cliente externo con:

```bash
psql "host=cityreport.com.mx port=40784 dbname=db_test user=adrian.gonzalez" -W -v ON_ERROR_STOP=1 -f sql/pruebas_postgresql.sql
```

Para MySQL, entra con una cuenta autorizada para las operaciones y ejecuta el archivo desde el cliente:

```bash
mysql -h cityreport.com.mx -P 40785 -u adrian.gonzalez -p db_test
SOURCE sql/pruebas_mysql.sql;
```

Escribe la contraseña cuando el cliente la solicite. No la agregues a la línea de comandos ni a capturas. Las operaciones se revierten al final; conserva las transcripciones de tu propia ejecución.

## Conexión y persistencia

PostgreSQL y MySQL aceptan conexiones remotas por los puertos TCP 40784 y 40785. Usa el host `cityreport.com.mx`, la base `db_test` y la cuenta correspondiente. En los paneles web, pgAdmin administra PostgreSQL y phpMyAdmin administra MySQL; sus URL usan 40787 y 40786 respectivamente.

Los volúmenes Compose conservan los datos al recrear contenedores. `docker compose down` conserva los volúmenes; `docker compose down -v` los elimina permanentemente.

## Evidencia y alcance del cotejo

Las capturas terminales y los archivos `.txt` registran diez operaciones demostrativas en PostgreSQL local, PostgreSQL VPS y MySQL VPS. Las operaciones de prueba terminaron con `ROLLBACK`. El cotejo oficial enumera diez casos de clase, pero no proporciona sus enunciados en la lista recibida; compara las demostraciones con las instrucciones que haya dado el docente antes de afirmar que esos casos están aprobados. El alumno debe añadir su conclusión personal y recopilar cualquier evidencia faltante de cuentas del sistema operativo, privilegios y firewall.

La rama `Manual_VPS_BDs_Relacionales` parte de `main`, de modo que se visualiza separada de `Practica03`. El historial registra el commit de entrega y su fusión no fast-forward a `main`.

## Seguridad de Git

El repositorio es público. `.env`, `privado/`, llaves privadas y scripts de inicialización con credenciales reales se excluyen mediante `.gitignore`. No subas contraseñas de GitHub, SSH ni bases de datos. La contraseña de GitHub debe administrarse con Git Credential Manager y cambiarse si se compartió en una conversación.
