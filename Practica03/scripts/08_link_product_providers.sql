USE db_test;
START TRANSACTION;
INSERT INTO tbd_products_users_providers(user_ID,product_ID,type_ownership,status,avalaible_date)
SELECT u.id,p.id,'Owner',p.status,p.created_at
FROM tb_products p JOIN tb_users u ON u.nickname=p.seller_nickname
WHERE NOT EXISTS (
 SELECT 1 FROM tbd_products_users_providers x WHERE x.user_ID=u.id AND x.product_ID=p.id
);
COMMIT;
