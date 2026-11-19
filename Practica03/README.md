# Práctica 03 · Manipulación de datos en conexiones remotas

## Descripción

La práctica amplía el esquema MySQL `db_test` a 25 tablas, 72 triggers y 25 vistas. Incluye la carga de 7,500 cuentas y perfiles, la clasificación de productos y la auditoría de inventario.

## Estructura

| Carpeta | Contenido |
|---|---|
| [scripts](scripts/) | Migraciones, procedimiento de carga, evento y catálogo |
| [queries](queries/) | Comprobación de los lotes |
| [docs](docs/) | Diccionario y diagramas de Archify |

## Procedimientos y automatización

El procedimiento general de [generación de usuarios](scripts/05_generate_users.sql) admite cantidad, género, país, rango de edad y porcentaje de actividad. El [evento de inventario](scripts/07_inventory_event.sql) registra un resumen diario en la bitácora.

## Consultas y documentación

[Verificar lotes](queries/verify_user_batches.sql) · [Diccionario](docs/diccionario.md) · [Diagramas](docs/index.html) · [Cuentas y roles](../Practica02/readme.md#usuarios-remotos-y-roles)
