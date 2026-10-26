-- Practica 2: usuarios y roles de Jael240784.
-- Requiere MySQL 8, la base y las tablas originales ya creadas.
-- Conserva exactamente las claves indicadas por Jael; ALTER USER las sincroniza en cuentas existentes.
USE `db_test`;

CREATE USER IF NOT EXISTS 'adrian.gonzalez'@'%' IDENTIFIED BY '240784';
ALTER USER 'adrian.gonzalez'@'%' IDENTIFIED BY '240784';
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
ALTER USER 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
CREATE USER IF NOT EXISTS 'luis.david'@'%' IDENTIFIED BY '240666';
ALTER USER 'luis.david'@'%' IDENTIFIED BY '240666';
CREATE USER IF NOT EXISTS 'bryan.javier'@'%' IDENTIFIED BY '240000';
ALTER USER 'bryan.javier'@'%' IDENTIFIED BY '240000';
CREATE USER IF NOT EXISTS 'ivan.ojeda'@'%' IDENTIFIED BY '240136';
ALTER USER 'ivan.ojeda'@'%' IDENTIFIED BY '240136';
CREATE USER IF NOT EXISTS 'ivan.macin'@'%' IDENTIFIED BY '240793';
ALTER USER 'ivan.macin'@'%' IDENTIFIED BY '240793';

CREATE ROLE IF NOT EXISTS 'super_admin', 'admin', 'support', 'saler', 'unregistered', 'superadmin', 'seller', 'buyer', 'common', 'not_registered';
GRANT ALL PRIVILEGES ON *.* TO 'super_admin';
GRANT ALL PRIVILEGES ON `db_test`.* TO 'admin';
GRANT SELECT, INSERT, UPDATE ON `db_test`.tb_users TO 'support';
GRANT SELECT, UPDATE ON `db_test`.tb_products TO 'support';
GRANT SELECT ON db_test.tbc_categories TO support;
GRANT SELECT ON db_test.vw_trazabilidad_usuarios TO support;
GRANT SELECT ON db_test.vw_trazabilidad_productos TO support;
GRANT SELECT, INSERT, UPDATE ON `db_test`.tb_products TO 'saler';
GRANT SELECT ON db_test.tbc_categories TO 'saler';
GRANT ALL PRIVILEGES ON *.* TO 'superadmin';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'seller';
GRANT SELECT ON db_test.tbc_categories TO 'seller';
GRANT SELECT ON db_test.tb_products, db_test.tbc_categories TO 'buyer', 'common';
CREATE OR REPLACE VIEW db_test.vw_total_products_by_category AS SELECT c.id AS category_id, c.name AS category_name, COUNT(pc.product_id) AS product_count FROM db_test.tbc_categories AS c LEFT JOIN db_test.tbd_products_categories AS pc ON pc.category_id=c.id GROUP BY c.id,c.name;
GRANT SELECT ON db_test.vw_total_products_by_category TO 'buyer', 'common', 'seller';

-- El rol unregistered no recibe privilegios sobre los datos.
GRANT 'super_admin','superadmin' TO 'adrian.gonzalez'@'%';
SET DEFAULT ROLE 'super_admin','superadmin' TO 'adrian.gonzalez'@'%';
GRANT 'admin' TO 'marco.ramirez'@'%';
SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';
GRANT 'support' TO 'luis.david'@'%';
SET DEFAULT ROLE 'support' TO 'luis.david'@'%';
GRANT 'saler','seller' TO 'bryan.javier'@'%';
SET DEFAULT ROLE 'saler','seller' TO 'bryan.javier'@'%';
GRANT 'saler','seller' TO 'ivan.ojeda'@'%';
SET DEFAULT ROLE 'saler','seller' TO 'ivan.ojeda'@'%';
GRANT 'unregistered','not_registered' TO 'ivan.macin'@'%';
SET DEFAULT ROLE 'unregistered','not_registered' TO 'ivan.macin'@'%';

-- Registro de usuarios y roles de la aplicacion.
CREATE TABLE IF NOT EXISTS usuarios (usuario VARCHAR(64) NOT NULL PRIMARY KEY, rol VARCHAR(32) NOT NULL);
INSERT INTO usuarios (usuario, rol) VALUES ('adrian.gonzalez', 'super_admin') ON DUPLICATE KEY UPDATE rol = 'super_admin';
INSERT INTO usuarios (usuario, rol) VALUES ('marco.ramirez', 'admin') ON DUPLICATE KEY UPDATE rol = 'admin';
INSERT INTO usuarios (usuario, rol) VALUES ('luis.david', 'support') ON DUPLICATE KEY UPDATE rol = 'support';
INSERT INTO usuarios (usuario, rol) VALUES ('bryan.javier', 'saler') ON DUPLICATE KEY UPDATE rol = 'saler';
INSERT INTO usuarios (usuario, rol) VALUES ('ivan.ojeda', 'saler') ON DUPLICATE KEY UPDATE rol = 'saler';
INSERT INTO usuarios (usuario, rol) VALUES ('ivan.macin', 'unregistered') ON DUPLICATE KEY UPDATE rol = 'unregistered';

UPDATE tb_users SET rol='super_admin' WHERE nickname='adrian.gonzalez';
UPDATE tb_users SET rol='admin' WHERE nickname='marco.ramirez';
UPDATE tb_users SET rol='support' WHERE nickname='luis.david';
UPDATE tb_users SET rol='saler' WHERE nickname IN ('bryan.javier','ivan.ojeda');
UPDATE tb_users SET rol='unregistered' WHERE nickname='ivan.macin';

SELECT usuario, rol FROM usuarios ORDER BY FIELD(rol,'super_admin','admin','support','saler','unregistered'), usuario;
