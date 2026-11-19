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

## Orden de preparación

| Etapa | Archivos | Qué revisar |
|---|---|---|
| Perfiles y comercio | [Perfiles](scripts/01_people.sql) y [esquema](scripts/02_commerce_schema.sql) | Tablas, relaciones y estructura base de pedidos y pagos. |
| Organización de datos | [Categorías](scripts/03_trace_categories.sql), [archivo histórico](scripts/04_archive_legacy_users.sql) y [actividad](scripts/05_account_activity.sql) | Cobertura y trazabilidad de los datos existentes. |
| Carga por lotes | [Generador](scripts/05_generate_users.sql) y [ejecución de lotes](scripts/06_run_user_batches.sql) | Cuentas creadas, perfiles asociados y actividad registrada. |
| Inventario y catálogo | [Evento de inventario](scripts/07_inventory_event.sql), [proveedores](scripts/08_link_product_providers.sql) y [cobertura](scripts/09_category_coverage.sql) | Auditoría de inventario y asociaciones del catálogo. |

Ejecuta la [consulta de comprobación](queries/verify_user_batches.sql) después de la carga. Usa el [índice de diagramas](docs/index.html) para ubicar el dominio y el [diccionario](docs/diccionario.md) para consultar campos y restricciones.

## Lectura del modelo

- [Identidad y auditoría](https://jael240784.github.io/Practicas_BDN_240784/identidad.html) reúne cuentas, personas y registro de operaciones.
- [Catálogo](https://jael240784.github.io/Practicas_BDN_240784/catalogo.html) muestra las asociaciones de productos, categorías y proveedores.
- [Compra](https://jael240784.github.io/Practicas_BDN_240784/compra.html) sigue el carrito, los pedidos y sus líneas. [Pagos](https://jael240784.github.io/Practicas_BDN_240784/pagos.html) detalla sus métodos y transacciones.

En el [diccionario interactivo](https://jael240784.github.io/Practicas_BDN_240784/diccionario.html), busca por tabla, columna o tipo. Revisa la nulabilidad y los valores predeterminados antes de consultar la referencia de una columna.

[Regresar a la portada](../README.md) · [Continuar con la simulación de compras](../Practica04/README.md)
