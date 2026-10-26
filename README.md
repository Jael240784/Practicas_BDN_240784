# Práctica individual | Bases de datos en la nube

**Estudiante:** Jael Adrián González Cruz
**Matrícula:** 240784 | **Grupo:** 7A
**Asignatura:** Bases de Datos en la Nube

Reporte de instalación de PostgreSQL en laboratorio local compartido y VPS individual. El VPS contiene además MySQL 8.4, pgAdmin y phpMyAdmin.

## Entregables

- `Reporte_Unidad1_240784.pdf`: portada, índice, procedimientos, capturas de los dos entornos, resultados, conclusión y matriz de cobertura de la lista de verificación.
- `docker-compose.yml`: PostgreSQL, MySQL, pgAdmin y phpMyAdmin, con volúmenes y red Docker persistentes.
- `.env.example`: plantilla sin secretos; copia a `.env` y define claves privadas antes de desplegar.
- `sql/postgresql.sql` y `sql/mysql.sql`: esquema `db_test`, cuentas y roles, permisos, triggers y vistas.
- `sql/importar_productos_5000_postgresql.sql`: carga validada e idempotente del lote CSV en PostgreSQL.
- `postgres/init/` y `mysql/init/`: inicialización automática al crear un volumen de datos vacío.
- `evidencias/`: capturas locales compartidas, validación local actual y paneles VPS.
- `evidencias/vps_actual/importacion_productos_bryan_20261026.txt`: transcripción de la carga y su verificación idempotente.

## Servicios del VPS

| Servicio | URL o destino |
|---|---|
| phpMyAdmin | http://cityreport.com.mx:40784 |
| pgAdmin | http://cityreport.com.mx:40785 |
| MySQL | `mysql:3306`, solo en la red Docker |
| PostgreSQL | `postgres:5432`, solo en la red Docker |

Los puertos 40784 y 40785 están asignados a los paneles web. Por ello no se pueden usar simultáneamente como puertos SQL desde un cliente externo. La lista de verificación pide PostgreSQL en 40784 y MySQL en 40785; ese requisito queda pendiente mientras se conserven las URL de los paneles. El reporte identifica la diferencia y no marca esas conexiones SQL como realizadas.

## Usuarios y roles

Los motores contienen las seis cuentas y contraseñas que indicó Jael. La asignación de la práctica se conserva: adrian.gonzalez como `super_admin`, marco.ramirez como `admin`, luis.david como `support`, bryan.javier e ivan.ojeda como `saler`, e ivan.macin como `unregistered`. Se agregan los nombres `superadmin`, `seller`, `buyer`, `common` y `not_registered` requeridos por la lista como roles compatibles; no sustituyen las etiquetas ni la asignación original de Jael. `buyer` y `common` solo tienen lectura de catálogo; `not_registered` no recibe permisos de datos.

Las cuentas de base de datos son distintas de la cuenta para iniciar sesión en pgAdmin o phpMyAdmin. Las credenciales están en los scripts de práctica por petición del estudiante; conserva privado el repositorio. El archivo `.env` y las claves administrativas del VPS no se publican.

## Despliegue

1. Copia `.env.example` a `.env` y define claves para los servicios.
2. Valida y levanta el Compose:

   ```sh
   docker compose --env-file .env config --quiet
   docker compose --env-file .env up -d
   docker compose ps
   docker compose logs --tail=50 postgres mysql
   ```

3. Abre los paneles de la tabla. En pgAdmin del VPS el servidor de base se registra con host `postgres`, puerto `5432` y base `db_test`; en phpMyAdmin se usa host `mysql`, puerto `3306`.

Los scripts de `postgres/init` y `mysql/init` solo corren con volúmenes vacíos. No uses `docker compose down -v` para una actualización: elimina las bases persistidas.

## Productos y trazabilidad

`tb_products.seller_nickname` identifica al vendedor asignado al producto; `tb_logs.db_user` identifica quién ejecutó una operación. Por indicación de Jael, las 5,000 filas de `Practica02/seeds/tb_products_5000.csv` se importaron en PostgreSQL y quedaron atribuidas a `bryan.javier`. El importador conserva SKU, estado y fechas, valida IDs/SKU y evita duplicados. En el VPS hay 5,001 productos de Bryan (incluida una fila de demostración) y 1 de Iván Ojeda. Para repetir la carga, copiar el CSV al contenedor como `/tmp/tb_products_5000.csv` y ejecutar el script como `jael_admin`.

## Verificación documentada

Las capturas locales corresponden al laboratorio compartido; las capturas VPS corresponden al Compose individual. La matriz del PDF separa resultados comprobados de indicadores pendientes. El contenido de esta rama se integra por separado conforme al flujo Git del repositorio.
