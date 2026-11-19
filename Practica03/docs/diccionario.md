# Diccionario de datos de Adrián González

MySQL · db_test · 25 tablas · 223 columnas · 39 claves foráneas.

[Abrir el MERE](mere.html)

## tb_buyer_orders

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| buyer_ID | bigint unsigned | NO | — | MUL | — | tb_users.id |
| seller_ID | bigint unsigned | NO | — | MUL | — | tb_users.id |
| subtotal | decimal(12,2) | NO | 0.00 | — | — | — |
| shipping_cost | decimal(12,2) | NO | 0.00 | — | — | — |
| fulfillment_status | enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned') | NO | Pending | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tb_cancellations

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| buyer_order_ID | int unsigned | NO | — | MUL | — | tb_buyer_orders.ID |
| user_ID | bigint unsigned | NO | — | MUL | — | tb_users.id |
| cancellation_reason | varchar(500) | NO | — | — | — | — |
| cancellation_status | enum('Requested','Approved','Rejected','Completed') | NO | Requested | — | — | — |
| requested_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| resolved_date | datetime | YES | — | — | — | — |
| resolution_notes | text | YES | — | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tb_carts

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| user_ID | bigint unsigned | NO | — | UNI | — | tb_users.id |
| status | bit(1) | YES | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tb_logs

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| id | bigint unsigned | NO | — | PRI | auto_increment | — |
| table_name | varchar(64) | NO | — | — | — | — |
| operation | enum('Create','Read','Update','Delete') | NO | — | — | — | — |
| db_user | varchar(100) | NO | — | — | — | — |
| description | text | NO | — | — | — | — |
| operation_date | timestamp | NO | CURRENT_TIMESTAMP | MUL | DEFAULT_GENERATED | — |
| operation_status | tinyint(1) | NO | 1 | — | — | — |

## tb_payment_methods

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| order_ID | int unsigned | NO | — | MUL | — | tb_buyer_orders.ID |
| user_ID | bigint unsigned | NO | — | MUL | — | tb_users.id |
| payment_method_type_ID | int unsigned | NO | — | MUL | — | tbc_payment_methods_types.ID |
| payment_reference | varchar(150) | YES | — | — | — | — |
| amount | decimal(12,2) | NO | — | — | — | — |
| currency | char(3) | NO | MXN | — | — | — |
| payment_status | enum('Pending','Authorized','Paid','Failed','Cancelled','Refunded') | NO | Pending | — | — | — |
| payment_date | datetime | YES | — | — | — | — |
| notes | text | YES | — | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tb_payment_transactions

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| payment_ID | int unsigned | NO | — | MUL | — | tb_payments.ID |
| event_type | enum('Created','Authorized','Captured','Failed','Refunded','PartiallyRefunded') | NO | — | — | — | — |
| amount | decimal(12,2) | NO | — | — | — | — |
| event_reference | varchar(150) | YES | — | — | — | — |
| remarks | text | YES | — | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |

## tb_payments

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| order_ID | int unsigned | NO | — | MUL | — | tb_buyer_orders.ID |
| amount | decimal(12,2) | NO | — | — | — | — |
| currency | char(3) | NO | MXN | — | — | — |
| payment_method | enum('Card','SPEI','Transfer','Cash') | NO | — | — | — | — |
| provider | varchar(50) | YES | — | MUL | — | — |
| provider_reference | varchar(150) | YES | — | — | — | — |
| payment_status | enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded') | NO | Pending | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| paid_date | datetime | YES | — | — | — | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tb_people

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| id | bigint unsigned | NO | — | PRI | auto_increment | — |
| user_id | bigint unsigned | NO | — | UNI | — | tb_users.id |
| given_names | varchar(150) | NO | — | — | — | — |
| paternal_surname | varchar(150) | YES | — | — | — | — |
| maternal_surname | varchar(150) | YES | — | — | — | — |
| birth_date | date | YES | — | — | — | — |
| gender_code | varchar(16) | YES | — | — | — | — |
| country_code | char(2) | YES | — | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |

## tb_products

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| id | bigint unsigned | NO | — | PRI | auto_increment | — |
| name | varchar(140) | NO | — | — | — | — |
| description | text | YES | — | — | — | — |
| price | decimal(10,2) | NO | — | — | — | — |
| stock | int | NO | 0 | — | — | — |
| seller_nickname | varchar(100) | NO | — | — | — | — |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| sku | varchar(80) | NO | — | UNI | — | — |
| status | tinyint(1) | NO | 1 | — | — | — |
| last_update | datetime | YES | — | — | — | — |

## tb_refunds

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| payment_ID | int unsigned | NO | — | MUL | — | tb_payments.ID |
| cancellation_ID | int unsigned | YES | — | MUL | — | tb_cancellations.ID |
| return_ID | int unsigned | YES | — | MUL | — | tb_returns.ID |
| amount | decimal(12,2) | NO | — | — | — | — |
| currency | char(3) | NO | MXN | — | — | — |
| refund_reason | varchar(500) | NO | — | — | — | — |
| refund_status | enum('Requested','Approved','Processing','Completed','Rejected','Failed') | NO | Requested | — | — | — |
| provider_reference | varchar(150) | YES | — | — | — | — |
| requested_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| processed_date | datetime | YES | — | — | — | — |
| resolution_notes | text | YES | — | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tb_returns

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| buyer_order_ID | int unsigned | NO | — | MUL | — | tb_buyer_orders.ID |
| order_item_ID | int unsigned | NO | — | MUL | — | tbd_order_items.ID |
| user_ID | bigint unsigned | NO | — | MUL | — | tb_users.id |
| quantity | int unsigned | NO | 1 | — | — | — |
| return_reason | varchar(500) | NO | — | — | — | — |
| return_status | enum('Requested','Authorized','Rejected','InTransit','Received','Inspected','Completed') | NO | Requested | — | — | — |
| requested_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| received_date | datetime | YES | — | — | — | — |
| resolved_date | datetime | YES | — | — | — | — |
| resolution_notes | text | YES | — | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tb_shipments

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| buyer_order_ID | int unsigned | NO | — | MUL | — | tb_buyer_orders.ID |
| address_ID | bigint unsigned | NO | — | MUL | — | tb_user_addresses.ID |
| carrier | varchar(100) | YES | — | MUL | — | — |
| tracking_number | varchar(150) | YES | — | — | — | — |
| shipping_cost | decimal(12,2) | NO | 0.00 | — | — | — |
| shipment_status | enum('Pending','Preparing','Shipped','InTransit','Delivered','Failed','Returned') | NO | Pending | — | — | — |
| shipped_date | datetime | YES | — | — | — | — |
| estimated_delivery_date | datetime | YES | — | — | — | — |
| delivered_date | datetime | YES | — | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tb_user_addresses

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | bigint unsigned | NO | — | PRI | auto_increment | — |
| user_ID | bigint unsigned | NO | — | MUL | — | tb_users.id |
| address_label | varchar(100) | NO | — | — | — | — |
| recipient_name | varchar(150) | YES | — | — | — | — |
| recipient_phone | varchar(25) | YES | — | — | — | — |
| delivery_instructions | varchar(500) | YES | — | — | — | — |
| latitude | decimal(10,7) | YES | — | — | — | — |
| longitude | decimal(10,7) | YES | — | — | — | — |
| is_default | tinyint(1) | NO | 0 | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tb_users

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| id | bigint unsigned | NO | — | PRI | auto_increment | — |
| email | varchar(160) | NO | — | UNI | — | — |
| nickname | varchar(100) | NO | — | UNI | — | — |
| password_hash | varchar(255) | NO | demo-hash-not-for-login | — | — | — |
| rol | varchar(32) | NO | unregistered | — | — | — |
| created_at | timestamp | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| status | bit(1) | NO | b'1' | — | — | — |

## tbc_categories

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| id | bigint unsigned | NO | — | PRI | auto_increment | — |
| name | varchar(100) | NO | — | UNI | — | — |
| description | text | YES | — | — | — | — |
| parent_category_id | bigint unsigned | YES | — | MUL | — | tbc_categories.id |
| status | tinyint(1) | NO | 1 | — | — | — |
| created_at | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | — | — |

## tbc_payment_methods_types

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| code | varchar(30) | NO | — | UNI | — | — |
| description | text | NO | — | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tbd_address_components

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | bigint unsigned | NO | — | PRI | auto_increment | — |
| address_ID | bigint unsigned | NO | — | MUL | — | tb_user_addresses.ID, tbd_address_components.address_ID |
| value | varchar(255) | NO | — | — | — | — |
| component_type | varchar(50) | NO | — | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| address_sup_ID | bigint unsigned | YES | — | — | — | tbd_address_components.ID |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tbd_cancellation_items

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| cancellation_ID | int unsigned | NO | — | MUL | — | tb_cancellations.ID |
| order_item_ID | int unsigned | NO | — | MUL | — | tbd_order_items.ID |
| quantity | int unsigned | NO | 1 | — | — | — |
| unit_amount | decimal(12,2) | NO | 0.00 | — | — | — |
| item_reason | varchar(500) | YES | — | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tbd_carts_items

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| cart_ID | int unsigned | NO | — | PRI | — | tb_carts.ID |
| provider_ID | bigint unsigned | NO | — | PRI | — | tbd_products_users_providers.user_ID |
| product_ID | bigint unsigned | NO | — | PRI | — | tbd_products_users_providers.product_ID |
| quantity | int | NO | — | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |

## tbd_order_items

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| seller_order_ID | int unsigned | NO | — | MUL | — | tb_buyer_orders.ID |
| product_ID | bigint unsigned | NO | — | MUL | — | tb_products.id |
| product_name | varchar(255) | NO | — | — | — | — |
| quantity | int unsigned | NO | — | — | — | — |
| unit_price | decimal(12,2) | NO | — | — | — | — |
| subtotal | decimal(12,2) | YES | — | — | STORED GENERATED | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |

## tbd_products_categories

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| product_id | bigint unsigned | NO | — | PRI | — | tb_products.id |
| category_id | bigint unsigned | NO | — | PRI | — | tbc_categories.id |
| status | tinyint(1) | NO | 1 | — | — | — |
| created_at | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | — | — |

## tbd_products_users_providers

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| user_ID | bigint unsigned | NO | — | PRI | — | tb_users.id |
| product_ID | bigint unsigned | NO | — | PRI | — | tb_products.id |
| type_ownership | enum('Owner','Reseller','Distributor') | YES | — | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| avalaible_date | datetime | NO | — | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED on update CURRENT_TIMESTAMP | — |

## tbd_return_items

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | int unsigned | NO | — | PRI | auto_increment | — |
| return_ID | int unsigned | NO | — | MUL | — | tb_returns.ID |
| order_item_ID | int unsigned | NO | — | MUL | — | tbd_order_items.ID |
| quantity | int unsigned | NO | 1 | — | — | — |
| unit_amount | decimal(12,2) | NO | 0.00 | — | — | — |
| item_reason | varchar(500) | YES | — | — | — | — |
| item_condition | enum('Unknown','New','Opened','Damaged') | NO | Unknown | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tbd_user_payment_methods

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| ID | bigint unsigned | NO | — | PRI | auto_increment | — |
| user_ID | bigint unsigned | NO | — | MUL | — | tb_users.id |
| payment_method_type_ID | int unsigned | NO | — | MUL | — | tbc_payment_methods_types.ID |
| provider | varchar(60) | NO | — | MUL | — | — |
| provider_method_ref | varchar(255) | NO | — | — | — | — |
| label | varchar(100) | YES | — | — | — | — |
| last_four | char(4) | YES | — | — | — | — |
| is_default | tinyint | NO | 0 | — | — | — |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | YES | — | — | on update CURRENT_TIMESTAMP | — |

## tbd_users_wishlist_products

| Columna | Tipo | Admite NULL | Valor predeterminado | Clave | Detalle | Referencias |
|---|---|---|---|---|---|---|
| user_ID | bigint unsigned | NO | — | PRI | — | tb_users.id |
| product_ID | bigint unsigned | NO | — | PRI | — | tb_products.id |
| status | bit(1) | NO | b'1' | — | — | — |
| creation_date | datetime | NO | CURRENT_TIMESTAMP | — | DEFAULT_GENERATED | — |
| last_update | datetime | NO | — | — | on update CURRENT_TIMESTAMP | — |
