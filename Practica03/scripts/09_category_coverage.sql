USE db_test;
DROP TEMPORARY TABLE IF EXISTS tmp_p03_category_gaps;
CREATE TEMPORARY TABLE tmp_p03_category_gaps AS
SELECT c.id,c.name,5-COUNT(DISTINCT p.id) AS missing
FROM tbc_categories c
LEFT JOIN tbd_products_categories pc ON pc.category_id=c.id AND pc.status=1
LEFT JOIN tb_products p ON p.id=pc.product_id
GROUP BY c.id,c.name
HAVING COUNT(DISTINCT p.id)<5;
START TRANSACTION;
INSERT INTO tb_products(sku,name,description,price,stock,status,seller_nickname)
SELECT CONCAT('P03-CAT-',g.id,'-',n.ordinal),
       LEFT(CONCAT(g.name,' - Producto de prueba ',n.ordinal),140),
       'Producto sintético para verificar cobertura de categoría en Práctica 03.',
       100+n.ordinal,10,1,u.nickname
FROM tmp_p03_category_gaps g
JOIN (SELECT 1 AS ordinal UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) n
 ON n.ordinal<=g.missing
JOIN tb_users u ON u.nickname='adrian.gonzalez'
WHERE NOT EXISTS(SELECT 1 FROM tb_products p WHERE p.sku=CONCAT('P03-CAT-',g.id,'-',n.ordinal));
INSERT INTO tbd_products_categories(product_id,category_id)
SELECT p.id,g.id FROM tmp_p03_category_gaps g
JOIN tb_products p ON p.sku LIKE CONCAT('P03-CAT-',g.id,'-%')
WHERE NOT EXISTS(SELECT 1 FROM tbd_products_categories pc WHERE pc.product_id=p.id AND pc.category_id=g.id);
INSERT INTO tbd_products_users_providers(user_ID,product_ID,type_ownership,status,avalaible_date)
SELECT u.id,p.id,'Owner',p.status,p.created_at FROM tb_products p
JOIN tb_users u ON u.nickname=p.seller_nickname
WHERE p.sku REGEXP '^P03-CAT-[0-9]+-[1-5]$'
AND NOT EXISTS(SELECT 1 FROM tbd_products_users_providers x WHERE x.product_ID=p.id AND x.user_ID=u.id);
COMMIT;
DROP TEMPORARY TABLE tmp_p03_category_gaps;

SELECT COUNT(*) AS productos_de_cobertura FROM tb_products WHERE sku REGEXP '^P03-CAT-[0-9]+-[1-5]$';
SELECT COUNT(*) AS categorias_por_debajo_del_minimo FROM (
 SELECT c.id FROM tbc_categories c LEFT JOIN tbd_products_categories pc ON pc.category_id=c.id AND pc.status=1
 GROUP BY c.id HAVING COUNT(DISTINCT pc.product_id)<5
) gaps;
SELECT COUNT(*) AS productos_sin_proveedor FROM tb_products p
WHERE NOT EXISTS(SELECT 1 FROM tbd_products_users_providers x WHERE x.product_ID=p.id);
