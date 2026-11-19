# Práctica 04 · Procesos de simulación de compra

Adrián González · 240784

La práctica usa el esquema MySQL `db_test` del VPS. Los casos se ejecutan desde un cliente TCP con la cuenta `AppWeb` y los roles definidos en MySQL.

| Carpeta | Contenido |
|---|---|
| [scripts](scripts/) | Procedimientos y ejecución de cada caso |
| [queries](queries/) | Consultas para revisar los pedidos y su auditoría |
| [docs](docs/) | Evidencias y referencia al diccionario |
| [backups](backups/) | Ubicación y alcance de los respaldos |

## Instalación y ejecución

Aplica primero las migraciones de la Práctica 03. Instala los procedimientos del caso con una cuenta administradora. Los scripts `*_run_case*.sql` ejecutan el flujo como `AppWeb` en una transacción. Los folios oficiales corresponden a ejecuciones ya guardadas. Usa un folio nuevo para una nueva demostración.

## Resultados comprobados

| Caso | Pedido | Resultado |
|---|---:|---|
| 1. Compra con débito | 2 | Cinco productos, transacción autorizada y entrega |
| 2. Compra a seis cuotas y reposición | 3 | Cinco cuotas autorizadas, una rechazada y reemplazo entregado |
| 3. Cancelación parcial | 5 | Reembolso de $2,807.80 y entrega del saldo del pedido |
| 4. SPEI y recolección | 6 | Intento de entrega fallido y recolección |
| 5. Inventario insuficiente | 7 | Pedido cancelado, cupón reactivado y sin cobro |

[Consultas de comprobación](queries/verify_cases.sql) · [Diccionario MySQL](../Practica03/docs/diccionario.md)
