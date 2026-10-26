-- Diez pruebas de demostración para tb_users, tb_products y sus vistas.
-- Ejecutarlas con la cuenta de administración desde un cliente externo.
-- Abrir previamente la base db_test desde pgAdmin o psql.
SELECT nickname,rol FROM tb_users ORDER BY nickname; -- 01
INSERT INTO tb_users(email,nickname,rol) VALUES ('prueba.usuario@cityreport.local','prueba.usuario','unregistered'); -- 02
UPDATE tb_users SET rol='support' WHERE nickname='prueba.usuario'; -- 03
SELECT * FROM vw_trazabilidad_usuarios ORDER BY operation_date DESC LIMIT 10; -- 04
DELETE FROM tb_users WHERE nickname='prueba.usuario'; -- 05
SELECT id,name,price,stock,seller_nickname FROM tb_products ORDER BY id; -- 06
INSERT INTO tb_products(name,description,price,stock,seller_nickname) VALUES ('Producto prueba SQL','Prueba de inserción',99.99,2,'bryan.javier'); -- 07
UPDATE tb_products SET price=109.99 WHERE name='Producto prueba SQL'; -- 08
SELECT * FROM vw_trazabilidad_productos ORDER BY operation_date DESC LIMIT 10; -- 09
DELETE FROM tb_products WHERE name='Producto prueba SQL'; -- 10
SELECT id,table_name,operation,db_user,description,operation_date FROM tb_logs ORDER BY id DESC LIMIT 20;
