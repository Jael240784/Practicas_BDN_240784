# Práctica 02 — Conexiones remotas a bases de datos relacionales

Ejercicio individual de Jael González (240784). Configura cuentas MySQL con roles, verifica privilegios y registra las etiquetas de rol de la aplicación para db_test.

## Usuarios

| Cuenta | Rol MySQL y rol de aplicación |
|---|---|
| adrian.gonzalez | super_admin |
| marco.ramirez | admin |
| luis.david | support |
| bryan.javier | saler |
| ivan.ojeda | saler |
| ivan.macin | unregistered |

## Compatibilidad con la lista de verificación

El script conserva las asignaciones de Jael y define además los nombres `superadmin`, `seller`, `buyer`, `common` y `not_registered`. Son roles compatibles con la lista; no cambian la etiqueta de aplicación `saler` ni la asignación de `ivan.macin`. El lote CSV no tiene campo de vendedor y queda sin importar hasta recibir una asignación explícita.

## Archivos

- scripts/remote_users_privileges_creation.sql crea las cuentas, actualiza las contraseñas con ALTER USER, aplica roles y sincroniza tb_users y usuarios.
- queries/consultas_verificacion.sql valida objetos, propietarios de productos, bitácora, vistas y privilegios en el esquema db_test desplegado.
- backups/ contiene respaldos propios de la práctica. No ejecutes un respaldo sobre producción sin validar su origen y destino.
- seeds/tb_products_5000.csv contiene datos de productos; su vendedor debe definirse antes de importarlo.

Las credenciales reales son las indicadas por Jael y se mantienen en el repositorio privado. No cambies la visibilidad del repositorio ni reasignes eventos históricos. seller_nickname indica el vendedor asociado al producto; db_user en la bitácora indica quién ejecutó la operación.

Desde un cliente administrador de MySQL, ejecuta:

    mysql -h HOST -P 3306 -u ADMIN -p < Practica02/scripts/remote_users_privileges_creation.sql

Luego abre queries/consultas_verificacion.sql en la conexión db_test y conserva capturas de los resultados.