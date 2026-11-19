-- Consultas de verificación para pgAdmin (solo lectura).
-- Conecta primero al servidor local 127.0.0.1:40784 y a la base db_test.

SELECT current_database() AS base,
       current_user AS usuario_conectado,
       inet_server_addr() AS direccion,
       inet_server_port() AS puerto,
       version() AS version_postgresql;

SELECT 'tb_users' AS tabla, count(*) AS filas FROM public.tb_users
UNION ALL SELECT 'tb_products', count(*) FROM public.tb_products
UNION ALL SELECT 'tbc_categories', count(*) FROM public.tbc_categories
UNION ALL SELECT 'tb_logs', count(*) FROM public.tb_logs
ORDER BY tabla;

SELECT table_name AS vista
FROM information_schema.views
WHERE table_schema = 'public'
ORDER BY table_name;

SELECT nickname, rol
FROM public.tb_users
ORDER BY nickname;

SELECT id, name, price, stock, seller_nickname
FROM public.tb_products
ORDER BY id;

SELECT seller_nickname, COUNT(*) AS productos
FROM public.tb_products
GROUP BY seller_nickname
ORDER BY seller_nickname;

SELECT COUNT(*) AS productos_con_sku,
       COUNT(*) FILTER (WHERE status) AS activos,
       COUNT(*) FILTER (WHERE NOT status) AS inactivos
FROM public.tb_products;
