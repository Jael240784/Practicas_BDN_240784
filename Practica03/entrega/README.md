# Entrega del manual · Jael González · 240784

Incluye el manual integrado de instalación y configuración local y en VPS para PostgreSQL y MySQL, junto con capturas reales de las verificaciones ejecutadas.

## Evidencia disponible

- `Manual_Instalacion_Bases_Datos_240784.pdf`: guía con el proceso local y VPS, DNS, servicios, roles, vistas, trazabilidad y lista de cotejo.
- `evidencias/07_postgresql_local_terminal.png`: PostgreSQL 18.6 local, conexión a `db_test` y diez operaciones de comprobación revertidas.
- `evidencias/08_postgresql_vps_terminal.png`: PostgreSQL VPS y diez operaciones de comprobación revertidas.
- `evidencias/09_mysql_vps_terminal.png`: MySQL VPS y diez operaciones de comprobación revertidas.

Las pruebas usaron filas temporales dentro de transacciones y terminaron con `ROLLBACK`; no dejaron registros de prueba persistentes. Los resultados de texto se incluyen en `evidencias/`.

## Estado y límites documentados

PostgreSQL local fue instalado y verificado. En este equipo no quedó disponible Docker Desktop/WSL, así que el Compose local y sus paneles no se presentan como ejecutados. Los servicios Compose del VPS se documentan por separado. La cuenta de base de datos utilizada para revisar MySQL no tiene permiso para consultar los metadatos globales de membresías y grants; el manual señala esta limitación. La lista de cotejo pide diez casos oficiales específicos que no venían en los archivos suministrados, por lo que esos casos no se declaran aprobados por inferencia.

## Seguridad

No contiene `.env`, claves privadas, dumps de bases de datos ni scripts de inicialización desplegados con contraseñas. El archivo superior `Practica03/README.md` conserva las consultas originales del repositorio; revísalas por separado antes de publicar si han recibido cambios locales.
