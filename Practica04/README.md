# Práctica 04 · Simulación de compras y transacciones

[Inicio del repositorio](../README.md) / **Simulación de compras**

> **Entrega** · Cinco escenarios de compra, resultados por pedido y consultas de auditoría.

**En esta guía** · [Ejecución](#instalación-y-ejecución) · [Resultados](#resultados-comprobados) · [Auditoría](#ruta-de-auditoría)

---

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

Ejecuta las [consultas de verificación](queries/verify_cases.sql) para revisar los pedidos y su trazabilidad.

| Caso | Pedido | Resultado |
|---|---:|---|
| 1. Compra con débito | 2 | Cinco productos, transacción autorizada y entrega |
| 2. Compra a seis cuotas y reposición | 3 | Cinco cuotas autorizadas, una rechazada y reemplazo entregado |
| 3. Cancelación parcial | 5 | Reembolso de $2,807.80 y entrega del saldo del pedido |
| 4. SPEI y recolección | 6 | Intento de entrega fallido y recolección |
| 5. Inventario insuficiente | 7 | Pedido cancelado, cupón reactivado y sin cobro |

[Consultas de comprobación](queries/verify_cases.sql) · [Diccionario MySQL](../Practica03/docs/diccionario.md)

## Scripts por escenario

| Caso | Instalación | Ejecución |
|---|---|---|
| Compra con débito | [Procedimiento](scripts/01_case1.sql) y [roles](scripts/02_case1_roles.sql) | [Caso 1](scripts/03_run_case1.sql) |
| Compra a seis cuotas y reposición | [Procedimiento](scripts/04_case2.sql) | [Caso 2](scripts/05_run_case2.sql) |
| Cancelación parcial | [Procedimiento](scripts/06_case3.sql) | [Caso 3](scripts/07_run_case3.sql) |
| SPEI y recolección | [Procedimiento](scripts/08_case4.sql) | [Caso 4](scripts/09_run_case4.sql) |
| Inventario insuficiente | [Procedimiento](scripts/10_case5.sql) | [Caso 5](scripts/11_run_case5.sql) |

En la revisión de evidencias, usa el identificador de pedido para relacionar el resultado con su [consulta de validación](queries/verify_cases.sql). El [índice de evidencias](docs/README.md) distingue el pedido oficial del Caso 3 de su ejecución anterior.

## Qué demuestra cada caso

### 1. Débito y entrega · Pedido 2

La prueba conecta el registro de cuenta y perfil con una compra de cinco productos. Comprueba la orden y sus líneas antes de cotejar el pago, la autorización y el estado de entrega.

### 2. Crédito y reposición · Pedido 3

La prueba registra seis intentos de pago. Comprueba cinco autorizaciones y un rechazo, y coteja los registros de devolución y envío para seguir la reposición.

### 3. Cancelación parcial · Pedido 5

La cancelación afecta una parte de la orden. Comprueba el importe del reembolso en `tb_refunds`, su vínculo con `tb_cancellations` y el estado del envío para los artículos restantes.

### 4. SPEI y recolección · Pedido 6

Comprueba el registro del pago y el seguimiento del envío. La resolución del caso documenta el paso de un intento de entrega fallido a la recolección.

### 5. Inventario insuficiente · Pedido 7

Comprueba el estado final de la orden y del método asociado al cupón. Contrasta ambos con la ausencia de un cobro para el pedido.

## Ruta de auditoría

| Evidencia | Tablas |
|---|---|
| Orden y productos | `tb_buyer_orders`, `tbd_order_items` |
| Pago y eventos | `tb_payments`, `tb_payment_transactions` |
| Entrega y devolución | `tb_shipments`, `tb_returns` |
| Cancelación y reembolso | `tb_cancellations`, `tb_refunds` |
| Actor de la operación | `tb_logs`, filtrada por la conexión `AppWeb` |

[Explorar el atlas publicado](https://jael240784.github.io/Practicas_BDN_240784/) · [Regresar a la portada](../README.md)
