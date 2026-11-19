-- Roles de compatibilidad con la lista de cotejo; se mantienen las etiquetas originales de Jael.
USE db_test;
CREATE ROLE IF NOT EXISTS 'superadmin','seller','buyer','common','not_registered';
CREATE OR REPLACE VIEW db_test.vw_total_products_by_category AS
 SELECT c.id AS category_id,c.name AS category_name,COUNT(pc.product_id) AS product_count
 FROM db_test.tbc_categories AS c LEFT JOIN db_test.tbd_products_categories AS pc ON pc.category_id=c.id
 GROUP BY c.id,c.name;
GRANT ALL PRIVILEGES ON *.* TO 'superadmin';
GRANT SELECT,INSERT,UPDATE ON db_test.tb_products TO 'seller';
GRANT SELECT ON db_test.tbc_categories TO 'seller';
GRANT SELECT ON db_test.tb_products TO 'buyer','common';
GRANT SELECT ON db_test.tbc_categories TO 'buyer','common';
GRANT SELECT ON db_test.vw_total_products_by_category TO 'buyer','common','seller';
GRANT 'superadmin' TO 'adrian.gonzalez'@'%';
GRANT 'seller' TO 'bryan.javier'@'%','ivan.ojeda'@'%';
GRANT 'not_registered' TO 'ivan.macin'@'%';
SET DEFAULT ROLE 'super_admin','superadmin' TO 'adrian.gonzalez'@'%';
SET DEFAULT ROLE 'saler','seller' TO 'bryan.javier'@'%';
SET DEFAULT ROLE 'saler','seller' TO 'ivan.ojeda'@'%';
SET DEFAULT ROLE 'unregistered','not_registered' TO 'ivan.macin'@'%';
