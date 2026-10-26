YªçŠx±¼±×œ•ªÞw­…Ê'²Û¬zW­~Šëy«,Š	ÚnW¯j¸šnW¬YªçŠx}¼±×œ•ªÞw­…Ê'²Û¬zW­~Šëy«,Š	ÚnW¯j¸šnW¬# PrÃ¡ctica individual Â· Bases de Datos en la Nube

**Estudiante:** Jael AdriÃ¡n GonzÃ¡lez Cruz Â· **MatrÃ­cula:** 240784 Â· **Grupo:** 7A  
**Asignatura:** Bases de Datos en la Nube Â· **Programa:** IngenierÃ­a en TecnologÃ­as de la InformaciÃ³n e InnovaciÃ³n Digital

Reporte tÃ©cnico de PostgreSQL en laboratorio local compartido y despliegue individual en VPS con PostgreSQL 18.6, MySQL 8.4, pgAdmin y phpMyAdmin.

## Entregables de la lista

- [`Reporte_Unidad1_240784.pdf`](Reporte_Unidad1_240784.pdf): reporte con portada, Ã­ndice, objetivo, procedimientos, capturas, resultados, conclusiones y matriz de cobertura de los 56 indicadores.
- [`docker-compose.yml`](docker-compose.yml): PostgreSQL, MySQL, pgAdmin y phpMyAdmin con volÃºmenes persistentes y red propia. Conserva el nombre Compose `gonzalez240784` para enlazar los volÃºmenes del despliegue existente.
- [`.env.example`](.env.example): plantilla de variables. CÃ³piala como `.env` y reemplaza los marcadores por secretos antes de desplegar. `.env` estÃ¡ excluido de Git.
- [`sql/postgresql.sql`](sql/postgresql.sql) y [`sql/mysql.sql`](sql/mysql.sql): esquemas, siete roles de negocio, cuentas de ejemplo, privilegios, triggers y vistas. Los marcadores de contraseÃ±a deben reemplazarse localmente antes de inicializar. No se guardan contraseÃ±as reales en GitHub.
- `postgres/init/` y `mysql/init/`: scripts para inicializar los motores. Docker los ejecuta solo al crear por primera vez el volumen de datos correspondiente.

## Puertos actuales

| Servicio web | URL | ConexiÃ³n interna al motor |
|---|---|---|
| phpMyAdmin | <http://cityreport.com.mx:40784> | `mysql:3306` |
| pgAdmin | <http://cityreport.com.mx:40785> | `postgres:5432` |

Los puertos externos `40784` y `40785` estÃ¡n asignados a los paneles web. MySQL `3306` y PostgreSQL `5432` permanecen dentro de la red Docker, sin publicaciÃ³n directa a Internet. En pgAdmin alojado en el VPS, registra el servidor como `postgres`, puerto `5432`, base `db_test`.

**Diferencia con la lista de verificaciÃ³n:** sus indicadores 13â€“18 piden que `40784` y `40785` sean puertos SQL para PostgreSQL y MySQL y que se pruebe el acceso desde un cliente externo. La configuraciÃ³n actual reserva esos mismos nÃºmeros para HTTP de phpMyAdmin y pgAdmin. El reporte registra esa incompatibilidad; los puntos de acceso SQL externo no se presentan como cumplidos. Cambiar esos puertos requiere mover los paneles a otros puertos y actualizar sus URL.

## Despliegue

1. Copia `.env.example` a `.env` y define contraseÃ±as Ãºnicas.
2. Sustituye en los scripts SQL los marcadores de contraseÃ±a de las cuentas de prÃ¡ctica. Conserva los archivos editados con secretos fuera de Git.
3. Valida y levanta los servicios:

   ```sh
   docker compose --env-file .env config --quiet
   docker compose --env-file .env up -d
   docker compose ps
   docker compose logs --tail=50 postgres mysql
   ```

4. Abre los paneles indicados arriba. Los scripts de `postgres/init` y `mysql/init` solo se ejecutan si el volumen respectivo estÃ¡ vacÃ­o. No uses `docker compose down -v`: elimina los datos persistidos.

## Evidencia

- `evidencias/local_compartido/`: capturas del laboratorio local compartido.
- `evidencias/local_actual/`: verificaciÃ³n local de `db_test` y operaciones temporales revertidas con `ROLLBACK`.
- `evidencias/vps_actual/`: capturas de phpMyAdmin con la base y pgAdmin conectado al PostgreSQL del VPS.
- `sql/consultas_verificacion_postgresql.sql`: consultas de lectura para revisar la conexiÃ³n, objetos y trazabilidad.

Las capturas locales documentan el laboratorio compartido; las de VPS corresponden a la instancia individual. No se incluyen `.env`, contraseÃ±as privadas ni claves de acceso.

## Alcance comprobado

El reporte separa lo demostrado de lo pendiente. La evidencia VPS documenta las interfaces web y una conexiÃ³n pgAdmin desde el propio servicio del VPS. No hay una captura actual de `docker compose ps`/logs del VPS ni una conexiÃ³n SQL desde un cliente externo en los puertos 40784/40785. La lista solicita esas verificaciones y se deberÃ¡n completar al resolver el conflicto de puertos.
