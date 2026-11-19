-- Ejecutar en la instancia MySQL de Adrián con acceso SELECT. Guardar el único valor JSON como conteos.json.
START TRANSACTION WITH CONSISTENT SNAPSHOT, READ ONLY;
SELECT JSON_OBJECT('capturado_utc', DATE_FORMAT(UTC_TIMESTAMP(), '%Y-%m-%d %H:%i:%s'), 'filas', JSON_OBJECTAGG(tabla, filas))
FROM (
SELECT 'tb_buyer_orders' AS tabla, COUNT(*) AS filas FROM db_test.`tb_buyer_orders`
UNION ALL
SELECT 'tb_cancellations' AS tabla, COUNT(*) AS filas FROM db_test.`tb_cancellations`
UNION ALL
SELECT 'tb_carts' AS tabla, COUNT(*) AS filas FROM db_test.`tb_carts`
UNION ALL
SELECT 'tb_logs' AS tabla, COUNT(*) AS filas FROM db_test.`tb_logs`
UNION ALL
SELECT 'tb_payment_methods' AS tabla, COUNT(*) AS filas FROM db_test.`tb_payment_methods`
UNION ALL
SELECT 'tb_payment_transactions' AS tabla, COUNT(*) AS filas FROM db_test.`tb_payment_transactions`
UNION ALL
SELECT 'tb_payments' AS tabla, COUNT(*) AS filas FROM db_test.`tb_payments`
UNION ALL
SELECT 'tb_people' AS tabla, COUNT(*) AS filas FROM db_test.`tb_people`
UNION ALL
SELECT 'tb_products' AS tabla, COUNT(*) AS filas FROM db_test.`tb_products`
UNION ALL
SELECT 'tb_refunds' AS tabla, COUNT(*) AS filas FROM db_test.`tb_refunds`
UNION ALL
SELECT 'tb_returns' AS tabla, COUNT(*) AS filas FROM db_test.`tb_returns`
UNION ALL
SELECT 'tb_shipments' AS tabla, COUNT(*) AS filas FROM db_test.`tb_shipments`
UNION ALL
SELECT 'tb_user_addresses' AS tabla, COUNT(*) AS filas FROM db_test.`tb_user_addresses`
UNION ALL
SELECT 'tb_users' AS tabla, COUNT(*) AS filas FROM db_test.`tb_users`
UNION ALL
SELECT 'tbc_categories' AS tabla, COUNT(*) AS filas FROM db_test.`tbc_categories`
UNION ALL
SELECT 'tbc_payment_methods_types' AS tabla, COUNT(*) AS filas FROM db_test.`tbc_payment_methods_types`
UNION ALL
SELECT 'tbd_address_components' AS tabla, COUNT(*) AS filas FROM db_test.`tbd_address_components`
UNION ALL
SELECT 'tbd_cancellation_items' AS tabla, COUNT(*) AS filas FROM db_test.`tbd_cancellation_items`
UNION ALL
SELECT 'tbd_carts_items' AS tabla, COUNT(*) AS filas FROM db_test.`tbd_carts_items`
UNION ALL
SELECT 'tbd_order_items' AS tabla, COUNT(*) AS filas FROM db_test.`tbd_order_items`
UNION ALL
SELECT 'tbd_products_categories' AS tabla, COUNT(*) AS filas FROM db_test.`tbd_products_categories`
UNION ALL
SELECT 'tbd_products_users_providers' AS tabla, COUNT(*) AS filas FROM db_test.`tbd_products_users_providers`
UNION ALL
SELECT 'tbd_return_items' AS tabla, COUNT(*) AS filas FROM db_test.`tbd_return_items`
UNION ALL
SELECT 'tbd_user_payment_methods' AS tabla, COUNT(*) AS filas FROM db_test.`tbd_user_payment_methods`
UNION ALL
SELECT 'tbd_users_wishlist_products' AS tabla, COUNT(*) AS filas FROM db_test.`tbd_users_wishlist_products`
) AS conteos;
COMMIT;
