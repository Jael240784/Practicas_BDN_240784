-- Script de práctica de Jael 240784. Incluye las credenciales solicitadas; mantener privado.
USE `db_test`;
CREATE TABLE IF NOT EXISTS `tb_users` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(160) NOT NULL,
  `nickname` VARCHAR(100) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL DEFAULT 'demo-hash-not-for-login',
  `rol` VARCHAR(32) NOT NULL DEFAULT 'unregistered',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`), UNIQUE KEY `uq_tb_users_email` (`email`), UNIQUE KEY `uq_tb_users_nickname` (`nickname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `tb_products` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(140) NOT NULL,
  `description` TEXT,
  `price` DECIMAL(10,2) NOT NULL,
  `stock` INT NOT NULL DEFAULT 0,
  `seller_nickname` VARCHAR(100) NOT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`), CONSTRAINT `chk_products_price` CHECK (`price` >= 0), CONSTRAINT `chk_products_stock` CHECK (`stock` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `tbc_categories` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`), UNIQUE KEY `uq_categories_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `tbd_products_categories` (
  `product_id` BIGINT UNSIGNED NOT NULL,
  `category_id` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`product_id`,`category_id`),
  CONSTRAINT `fk_pcat_product` FOREIGN KEY (`product_id`) REFERENCES `tb_products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pcat_category` FOREIGN KEY (`category_id`) REFERENCES `tbc_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `tb_logs` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `table_name` VARCHAR(64) NOT NULL,
  `operation` ENUM('Create','Read','Update','Delete') NOT NULL,
  `db_user` VARCHAR(100) NOT NULL,
  `description` TEXT NOT NULL,
  `operation_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`id`), KEY `idx_tb_logs_date` (`operation_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE IF NOT EXISTS `usuarios` (`usuario` VARCHAR(64) NOT NULL PRIMARY KEY, `rol` VARCHAR(32) NOT NULL);
INSERT INTO `usuarios` (`usuario`,`rol`) VALUES ('adrian.gonzalez','super_admin') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `tb_users` (`email`,`nickname`,`password_hash`,`rol`) VALUES ('adrian.gonzalez@cityreport.local','adrian.gonzalez','demo-hash-not-for-login','super_admin') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `usuarios` (`usuario`,`rol`) VALUES ('marco.ramirez','admin') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `tb_users` (`email`,`nickname`,`password_hash`,`rol`) VALUES ('marco.ramirez@cityreport.local','marco.ramirez','demo-hash-not-for-login','admin') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `usuarios` (`usuario`,`rol`) VALUES ('luis.david','support') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `tb_users` (`email`,`nickname`,`password_hash`,`rol`) VALUES ('luis.david@cityreport.local','luis.david','demo-hash-not-for-login','support') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `usuarios` (`usuario`,`rol`) VALUES ('bryan.javier','saler') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `tb_users` (`email`,`nickname`,`password_hash`,`rol`) VALUES ('bryan.javier@cityreport.local','bryan.javier','demo-hash-not-for-login','saler') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `usuarios` (`usuario`,`rol`) VALUES ('ivan.ojeda','saler') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `tb_users` (`email`,`nickname`,`password_hash`,`rol`) VALUES ('ivan.ojeda@cityreport.local','ivan.ojeda','demo-hash-not-for-login','saler') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `usuarios` (`usuario`,`rol`) VALUES ('ivan.macin','unregistered') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
INSERT INTO `tb_users` (`email`,`nickname`,`password_hash`,`rol`) VALUES ('ivan.macin@cityreport.local','ivan.macin','demo-hash-not-for-login','unregistered') ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);

INSERT INTO `tbc_categories` (`name`) VALUES ('Accesorios'),('Ropa') ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);
INSERT INTO `tb_products` (`name`,`description`,`price`,`stock`,`seller_nickname`) VALUES
('Producto de demostración','Registro de ejemplo para validar la conexión',199.90,10,'bryan.javier'),
('Producto de prueba','Registro de ejemplo para validar consultas',249.00,5,'ivan.ojeda');
DROP TRIGGER IF EXISTS `trg_users_insert`;
DROP TRIGGER IF EXISTS `trg_users_update`;
DROP TRIGGER IF EXISTS `trg_users_delete`;
DROP TRIGGER IF EXISTS `trg_products_insert`;
DROP TRIGGER IF EXISTS `trg_products_update`;
DROP TRIGGER IF EXISTS `trg_products_delete`;
DELIMITER $$
CREATE TRIGGER `trg_users_insert` AFTER INSERT ON `tb_users` FOR EACH ROW
BEGIN INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_users','Create',USER(),CONCAT('Alta de usuario id=',NEW.id,', nickname=',NEW.nickname)); END$$
CREATE TRIGGER `trg_users_update` AFTER UPDATE ON `tb_users` FOR EACH ROW
BEGIN INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_users','Update',USER(),CONCAT('Actualización de usuario id=',NEW.id,', nickname=',NEW.nickname)); END$$
CREATE TRIGGER `trg_users_delete` AFTER DELETE ON `tb_users` FOR EACH ROW
BEGIN INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_users','Delete',USER(),CONCAT('Baja de usuario id=',OLD.id,', nickname=',OLD.nickname)); END$$
CREATE TRIGGER `trg_products_insert` AFTER INSERT ON `tb_products` FOR EACH ROW
BEGIN INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_products','Create',USER(),CONCAT('Alta de producto id=',NEW.id,', nombre=',NEW.name)); END$$
CREATE TRIGGER `trg_products_update` AFTER UPDATE ON `tb_products` FOR EACH ROW
BEGIN INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_products','Update',USER(),CONCAT('Actualización de producto id=',NEW.id,', nombre=',NEW.name)); END$$
CREATE TRIGGER `trg_products_delete` AFTER DELETE ON `tb_products` FOR EACH ROW
BEGIN INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_products','Delete',USER(),CONCAT('Baja de producto id=',OLD.id,', nombre=',OLD.name)); END$$
DELIMITER ;
CREATE OR REPLACE VIEW `vw_trazabilidad_usuarios` AS
  SELECT id, table_name, operation, db_user, description, operation_date, operation_status FROM tb_logs WHERE table_name='tb_users';
CREATE OR REPLACE VIEW `vw_trazabilidad_productos` AS
  SELECT id, table_name, operation, db_user, description, operation_date, operation_status FROM tb_logs WHERE table_name='tb_products';
CREATE OR REPLACE VIEW `vw_total_products_by_category` AS
  SELECT c.id AS category_id, c.name AS category_name, COUNT(pc.product_id) AS product_count
  FROM tbc_categories AS c LEFT JOIN tbd_products_categories AS pc ON pc.category_id=c.id
  GROUP BY c.id, c.name;

CREATE ROLE IF NOT EXISTS 'super_admin','admin','support','saler','unregistered',
  'superadmin','seller','buyer','common','not_registered';
GRANT ALL PRIVILEGES ON *.* TO 'super_admin';
GRANT ALL PRIVILEGES ON *.* TO 'superadmin';
GRANT ALL PRIVILEGES ON db_test.* TO 'admin';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_users TO 'support';
GRANT SELECT, UPDATE ON db_test.tb_products TO 'support';
GRANT SELECT ON db_test.tbc_categories TO 'support';
GRANT SELECT ON db_test.vw_trazabilidad_usuarios TO 'support';
GRANT SELECT ON db_test.vw_trazabilidad_productos TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'saler','seller';
GRANT SELECT ON db_test.tbc_categories TO 'saler','seller';
GRANT SELECT ON db_test.tb_products TO 'buyer','common';
GRANT SELECT ON db_test.tbc_categories TO 'buyer','common';
GRANT SELECT ON db_test.vw_total_products_by_category TO 'buyer','common','seller';

CREATE USER IF NOT EXISTS 'adrian.gonzalez'@'%' IDENTIFIED BY '240784';
ALTER USER 'adrian.gonzalez'@'%' IDENTIFIED BY '240784';
GRANT 'super_admin','superadmin' TO 'adrian.gonzalez'@'%';
SET DEFAULT ROLE 'super_admin','superadmin' TO 'adrian.gonzalez'@'%';
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
ALTER USER 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123';
GRANT 'admin' TO 'marco.ramirez'@'%';
SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';
CREATE USER IF NOT EXISTS 'luis.david'@'%' IDENTIFIED BY '240666';
ALTER USER 'luis.david'@'%' IDENTIFIED BY '240666';
GRANT 'support' TO 'luis.david'@'%';
SET DEFAULT ROLE 'support' TO 'luis.david'@'%';
CREATE USER IF NOT EXISTS 'bryan.javier'@'%' IDENTIFIED BY '240000';
ALTER USER 'bryan.javier'@'%' IDENTIFIED BY '240000';
GRANT 'saler','seller' TO 'bryan.javier'@'%';
SET DEFAULT ROLE 'saler','seller' TO 'bryan.javier'@'%';
CREATE USER IF NOT EXISTS 'ivan.ojeda'@'%' IDENTIFIED BY '240136';
ALTER USER 'ivan.ojeda'@'%' IDENTIFIED BY '240136';
GRANT 'saler','seller' TO 'ivan.ojeda'@'%';
SET DEFAULT ROLE 'saler','seller' TO 'ivan.ojeda'@'%';
CREATE USER IF NOT EXISTS 'ivan.macin'@'%' IDENTIFIED BY '240793';
ALTER USER 'ivan.macin'@'%' IDENTIFIED BY '240793';
GRANT 'unregistered','not_registered' TO 'ivan.macin'@'%';
SET DEFAULT ROLE 'unregistered','not_registered' TO 'ivan.macin'@'%';

FLUSH PRIVILEGES;
-- Validacion: SELECT usuario, rol FROM usuarios ORDER BY usuario;
-- Validacion: SELECT * FROM vw_trazabilidad_productos ORDER BY operation_date DESC LIMIT 10;
