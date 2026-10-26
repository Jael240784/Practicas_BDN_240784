-- Consultas compatibles con el esquema db_test desplegado en el Compose de Jael.
-- db_user registra quien ejecutó la operación; seller_nickname indica el vendedor asociado.
USE db_test;

-- 1. Objetos disponibles.
SHOW FULL TABLES;
SHOW TRIGGERS FROM db_test;

-- 2. Cuentas de la aplicación y etiquetas de Jael.
SELECT usuario, rol FROM usuarios
ORDER BY FIELD(rol,'super_admin','admin','support','saler','unregistered'), usuario;
SELECT nickname, rol FROM tb_users
ORDER BY FIELD(rol,'super_admin','admin','support','saler','unregistered'), nickname;

-- 3. Productos por vendedor asociado.
SELECT seller_nickname, COUNT(*) AS productos
FROM tb_products GROUP BY seller_nickname ORDER BY seller_nickname;
SELECT id, name, seller_nickname, price, stock, created_at
FROM tb_products ORDER BY id;

-- 4. Trazabilidad real.
SELECT id, db_user, operation, description, operation_date, operation_status
FROM vw_trazabilidad_productos ORDER BY operation_date DESC, id DESC LIMIT 100;
SELECT id, db_user, operation, description, operation_date, operation_status
FROM vw_trazabilidad_usuarios ORDER BY operation_date DESC, id DESC LIMIT 100;

-- 5. Relaciones producto-categoría.
SELECT c.id AS category_id, c.name AS categoria, COUNT(pc.product_id) AS productos
FROM tbc_categories AS c
LEFT JOIN tbd_products_categories AS pc ON pc.category_id = c.id
GROUP BY c.id, c.name ORDER BY c.id;

-- 6. Procedimientos instalados; puede devolver cero filas.
SHOW PROCEDURE STATUS WHERE Db = 'db_test';

-- 7. Roles concedidos y rol predeterminado.
SELECT FROM_USER AS rol, TO_USER AS usuario, TO_HOST AS host
FROM mysql.role_edges
WHERE TO_USER IN ('adrian.gonzalez','marco.ramirez','luis.david','bryan.javier','ivan.ojeda','ivan.macin')
ORDER BY TO_USER, FROM_USER;
SELECT USER, HOST, DEFAULT_ROLE_USER AS rol_predeterminado, DEFAULT_ROLE_HOST AS host_rol
FROM mysql.default_roles
WHERE USER IN ('adrian.gonzalez','marco.ramirez','luis.david','bryan.javier','ivan.ojeda','ivan.macin')
ORDER BY USER;

-- 8. Privilegios efectivos; requiere una cuenta administradora.
SHOW GRANTS FOR 'adrian.gonzalez'@'%';
SHOW GRANTS FOR 'marco.ramirez'@'%';
SHOW GRANTS FOR 'luis.david'@'%';
SHOW GRANTS FOR 'bryan.javier'@'%';
SHOW GRANTS FOR 'ivan.ojeda'@'%';
SHOW GRANTS FOR 'ivan.macin'@'%';

-- Alias de roles requeridos por la lista y vista de resumen.
SELECT * FROM vw_total_products_by_category ORDER BY category_id;
