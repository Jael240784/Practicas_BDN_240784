-- Diez operaciones de demostracion, reversibles, para un db_test con el esquema de mysql.sql.
-- Ejecutar con una cuenta autorizada. Estos ejemplos no sustituyen casos oficiales que entregue el docente.
USE `db_test`;
START TRANSACTION;
SELECT `usuario`,`rol` FROM `usuarios` ORDER BY `usuario`; -- 01
INSERT INTO `tb_users` (`email`,`nick`,`password`) VALUES
 ('prueba.usuario@cityreport.local','prueba.usuario','demo-temporal-no-login'); -- 02
INSERT INTO `usuarios` (`usuario`,`rol`) VALUES ('prueba.usuario','common')
ON DUPLICATE KEY UPDATE `rol`=VALUES(`rol`);
UPDATE `usuarios` SET `rol`='support' WHERE `usuario`='prueba.usuario'; -- 03
SELECT `nick`,`email`,`inserted_by`,`roles`,`operation_description`,`operation_date`
FROM `vw_trazabilidad_usuarios` WHERE `nick`='prueba.usuario'; -- 04
DELETE FROM `tb_users` WHERE `nick`='prueba.usuario';
DELETE FROM `usuarios` WHERE `usuario`='prueba.usuario'; -- 05
SELECT `ID`,`SKU`,`name`,`current_price`,`current_stock` FROM `tb_products` ORDER BY `ID`; -- 06
INSERT INTO `tb_products` (`SKU`,`name`,`description`,`current_price`,`current_stock`)
VALUES ('TEMP-240784-001','Producto temporal SQL','Prueba reversible',99.99,2); -- 07
UPDATE `tb_products` SET `current_price`=109.99 WHERE `SKU`='TEMP-240784-001'; -- 08
SELECT `id`,`name`,`inserted_by`,`roles`,`operation_description`,`operation_date`
FROM `vw_trazabilidad_productos` WHERE `name`='Producto temporal SQL'; -- 09
DELETE FROM `tb_products` WHERE `SKU`='TEMP-240784-001'; -- 10
SELECT `ID`,`table_name`,`table_operation`,`db_user`,`operation_description`,`operation_date`
FROM `tb_logs` ORDER BY `ID` DESC LIMIT 20;
ROLLBACK;
