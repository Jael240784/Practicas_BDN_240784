-- Plantilla para un db_test nuevo (MySQL 8.4). No contiene contrasenas reales.
-- Ejecutar como root o administrador con CREATE USER, CREATE ROLE y GRANT OPTION.
-- Si db_test ya tiene datos, haz un respaldo y compara primero la estructura.
USE `db_test`;

CREATE TABLE IF NOT EXISTS `tb_users` (
  `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NOT NULL,
  `nick` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `last_login` DATETIME NULL DEFAULT NULL,
  `status` BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`), UNIQUE KEY `uq_tb_users_email` (`email`),
  UNIQUE KEY `uq_tb_users_nick` (`nick`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tb_products` (
  `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `SKU` VARCHAR(50) NOT NULL,
  `name` VARCHAR(250) NOT NULL,
  `description` TEXT,
  `current_price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `current_stock` INT UNSIGNED NOT NULL DEFAULT 0,
  `status` BIT(1) NOT NULL DEFAULT b'1',
  `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`), UNIQUE KEY `uq_tb_products_sku` (`SKU`),
  CONSTRAINT `chk_tb_products_price` CHECK (`current_price` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tbc_categories` (
  `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`ID`), UNIQUE KEY `uq_tbc_categories_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tbd_products_categories` (
  `product_ID` BIGINT UNSIGNED NOT NULL,
  `category_ID` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`product_ID`,`category_ID`),
  CONSTRAINT `fk_pcat_product` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_pcat_category` FOREIGN KEY (`category_ID`) REFERENCES `tbc_categories` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tb_logs` (
  `ID` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `table_name` VARCHAR(100) NOT NULL,
  `table_operation` ENUM('Create','Read','Update','Delete') NOT NULL,
  `db_user` VARCHAR(100) NOT NULL,
  `operation_description` TEXT NOT NULL,
  `operation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` BIT(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`), KEY `idx_tb_logs_date` (`operation_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `usuarios` (
  `usuario` VARCHAR(64) NOT NULL PRIMARY KEY,
  `rol` VARCHAR(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `usuarios` (`usuario`,`rol`) VALUES
 ('adrian.gonzalez','super_admin'),('marco.ramirez','admin'),('luis.david','support'),
 ('bryan.javier','saler'),('ivan.ojeda','saler'),('ivan.macin','unregistered')
ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);

-- Estas filas ilustran la app; password_hash no sirve para iniciar sesion.
INSERT INTO `tb_users` (`email`,`nick`,`password`) VALUES
 ('adrian.gonzalez@cityreport.local','adrian.gonzalez','demo-hash-not-for-login'),
 ('marco.ramirez@cityreport.local','marco.ramirez','demo-hash-not-for-login'),
 ('luis.david@cityreport.local','luis.david','demo-hash-not-for-login'),
 ('bryan.javier@cityreport.local','bryan.javier','demo-hash-not-for-login'),
 ('ivan.ojeda@cityreport.local','ivan.ojeda','demo-hash-not-for-login'),
 ('ivan.macin@cityreport.local','ivan.macin','demo-hash-not-for-login')
ON DUPLICATE KEY UPDATE `nick`=VALUES(`nick`);

INSERT INTO `tbc_categories` (`name`) VALUES ('Accesorios'),('Ropa')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);
INSERT INTO `tb_products` (`SKU`,`name`,`description`,`current_price`,`current_stock`) VALUES
 ('DEMO-240784-001','Producto de demostracion','Fila de ejemplo para validar el esquema',199.90,10),
 ('DEMO-240784-002','Producto de prueba','Fila de ejemplo para validar consultas',249.00,5)
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);
INSERT IGNORE INTO `tbd_products_categories` (`product_ID`,`category_ID`)
SELECT p.`ID`,c.`ID` FROM `tb_products` p CROSS JOIN `tbc_categories` c
WHERE p.`SKU`='DEMO-240784-001' AND c.`name`='Accesorios';

DROP TRIGGER IF EXISTS `trg_users_insert`;
DROP TRIGGER IF EXISTS `trg_users_update`;
DROP TRIGGER IF EXISTS `trg_users_delete`;
DROP TRIGGER IF EXISTS `trg_products_insert`;
DROP TRIGGER IF EXISTS `trg_products_update`;
DROP TRIGGER IF EXISTS `trg_products_delete`;
DELIMITER $$
CREATE TRIGGER `trg_users_insert` AFTER INSERT ON `tb_users` FOR EACH ROW
BEGIN
  INSERT INTO `tb_logs` (`table_name`,`table_operation`,`db_user`,`operation_description`)
  VALUES ('tb_users','Create',USER(),CONCAT('Usuario creado. ID=',NEW.ID,', email=',NEW.email,', nick=',NEW.nick));
END$$
CREATE TRIGGER `trg_users_update` AFTER UPDATE ON `tb_users` FOR EACH ROW
BEGIN
  INSERT INTO `tb_logs` (`table_name`,`table_operation`,`db_user`,`operation_description`)
  VALUES ('tb_users','Update',USER(),CONCAT('Usuario actualizado. ID=',NEW.ID,', email=',NEW.email,', nick=',NEW.nick));
END$$
CREATE TRIGGER `trg_users_delete` AFTER DELETE ON `tb_users` FOR EACH ROW
BEGIN
  INSERT INTO `tb_logs` (`table_name`,`table_operation`,`db_user`,`operation_description`)
  VALUES ('tb_users','Delete',USER(),CONCAT('Usuario eliminado. ID=',OLD.ID,', email=',OLD.email,', nick=',OLD.nick));
END$$
CREATE TRIGGER `trg_products_insert` AFTER INSERT ON `tb_products` FOR EACH ROW
BEGIN
  INSERT INTO `tb_logs` (`table_name`,`table_operation`,`db_user`,`operation_description`)
  VALUES ('tb_products','Create',USER(),CONCAT('Producto creado. ID=',NEW.ID,', SKU=',NEW.SKU,', nombre=',NEW.name));
END$$
CREATE TRIGGER `trg_products_update` AFTER UPDATE ON `tb_products` FOR EACH ROW
BEGIN
  INSERT INTO `tb_logs` (`table_name`,`table_operation`,`db_user`,`operation_description`)
  VALUES ('tb_products','Update',USER(),CONCAT('Producto actualizado. ID=',NEW.ID,', SKU=',NEW.SKU,', nombre=',NEW.name));
END$$
CREATE TRIGGER `trg_products_delete` AFTER DELETE ON `tb_products` FOR EACH ROW
BEGIN
  INSERT INTO `tb_logs` (`table_name`,`table_operation`,`db_user`,`operation_description`)
  VALUES ('tb_products','Delete',USER(),CONCAT('Producto eliminado. ID=',OLD.ID,', SKU=',OLD.SKU,', nombre=',OLD.name));
END$$
DELIMITER ;

CREATE OR REPLACE VIEW `vw_trazabilidad_usuarios` AS
SELECT u.`nick`,u.`email`,l.`db_user` AS `inserted_by`,
       COALESCE(GROUP_CONCAT(DISTINCT re.`FROM_USER` ORDER BY re.`FROM_USER` SEPARATOR ', '),'Sin rol') AS `roles`,
       l.`operation_description`,l.`operation_date`
FROM `tb_users` u
JOIN `tb_logs` l ON l.`operation_description` LIKE CONCAT('%email=',u.`email`,'%')
                AND l.`operation_description` LIKE CONCAT('%nick=',u.`nick`,'%')
LEFT JOIN `mysql`.`role_edges` re ON re.`TO_USER`=SUBSTRING_INDEX(l.`db_user`,'@',1)
WHERE l.`table_name`='tb_users' AND l.`table_operation`='Create'
GROUP BY u.`nick`,u.`email`,l.`db_user`,l.`operation_description`,l.`operation_date`;

CREATE OR REPLACE VIEW `vw_trazabilidad_productos` AS
SELECT p.`ID` AS `id`,p.`name`,p.`description`,l.`db_user` AS `inserted_by`,
       COALESCE(GROUP_CONCAT(DISTINCT re.`FROM_USER` ORDER BY re.`FROM_USER` SEPARATOR ', '),'Sin rol') AS `roles`,
       l.`operation_description`,l.`operation_date`
FROM `tb_products` p
JOIN `tb_logs` l ON l.`operation_description` LIKE CONCAT('%ID=',p.`ID`,',%')
LEFT JOIN `mysql`.`role_edges` re ON re.`TO_USER`=SUBSTRING_INDEX(l.`db_user`,'@',1)
WHERE l.`table_name`='tb_products' AND l.`table_operation`='Create'
GROUP BY p.`ID`,p.`name`,p.`description`,l.`db_user`,l.`operation_description`,l.`operation_date`;

CREATE OR REPLACE VIEW `vw_total_products_by_category` AS
SELECT c.`ID` AS `category_id`,c.`name` AS `category_name`,COUNT(pc.`product_ID`) AS `total_products`
FROM `tbc_categories` c
LEFT JOIN `tbd_products_categories` pc ON pc.`category_ID`=c.`ID`
GROUP BY c.`ID`,c.`name`;

CREATE ROLE IF NOT EXISTS 'superadmin','admin','seller','buyer','support','common','not_registered';
GRANT ALL PRIVILEGES ON *.* TO 'superadmin';
GRANT ALL PRIVILEGES ON `db_test`.* TO 'admin';
GRANT SELECT,INSERT,UPDATE ON `db_test`.`tb_users` TO 'support';
GRANT SELECT,UPDATE ON `db_test`.`tb_products` TO 'support';
GRANT SELECT ON `db_test`.`tbc_categories`,`db_test`.`vw_trazabilidad_usuarios`,
  `db_test`.`vw_trazabilidad_productos` TO 'support';
GRANT SELECT,INSERT,UPDATE ON `db_test`.`tb_products` TO 'seller';
GRANT SELECT ON `db_test`.`tbc_categories`,`db_test`.`tb_products`,
  `db_test`.`vw_total_products_by_category` TO 'seller','buyer','common';
GRANT SELECT ON `db_test`.`usuarios` TO 'superadmin','admin','support','seller','buyer','common';

CREATE USER IF NOT EXISTS 'adrian.gonzalez'@'%' IDENTIFIED BY 'CAMBIAR_PASSWORD_ADRIAN_GONZALEZ';
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'CAMBIAR_PASSWORD_MARCO_RAMIREZ';
CREATE USER IF NOT EXISTS 'luis.david'@'%' IDENTIFIED BY 'CAMBIAR_PASSWORD_LUIS_DAVID';
CREATE USER IF NOT EXISTS 'bryan.javier'@'%' IDENTIFIED BY 'CAMBIAR_PASSWORD_BRYAN_JAVIER';
CREATE USER IF NOT EXISTS 'ivan.ojeda'@'%' IDENTIFIED BY 'CAMBIAR_PASSWORD_IVAN_OJEDA';
CREATE USER IF NOT EXISTS 'ivan.macin'@'%' IDENTIFIED BY 'CAMBIAR_PASSWORD_IVAN_MACIN';
GRANT 'superadmin' TO 'adrian.gonzalez'@'%';
GRANT 'admin' TO 'marco.ramirez'@'%';
GRANT 'support' TO 'luis.david'@'%';
GRANT 'seller' TO 'bryan.javier'@'%','ivan.ojeda'@'%';
GRANT 'not_registered' TO 'ivan.macin'@'%';
SET DEFAULT ROLE 'superadmin' TO 'adrian.gonzalez'@'%';
SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';
SET DEFAULT ROLE 'support' TO 'luis.david'@'%';
SET DEFAULT ROLE 'seller' TO 'bryan.javier'@'%','ivan.ojeda'@'%';
SET DEFAULT ROLE 'not_registered' TO 'ivan.macin'@'%';

-- Verifica despues de ejecutar: SELECT * FROM usuarios ORDER BY usuario;
-- SELECT * FROM vw_trazabilidad_productos ORDER BY operation_date DESC LIMIT 20;
-- SHOW GRANTS FOR 'luis.david'@'%';
