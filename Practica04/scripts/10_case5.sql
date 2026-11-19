USE db_test;
INSERT INTO tbc_payment_methods_types(code,description) SELECT 'gift_coupon','Cupón de regalo simulado'
WHERE NOT EXISTS(SELECT 1 FROM tbc_payment_methods_types WHERE code='gift_coupon');
DROP PROCEDURE IF EXISTS sp_practica04_case5;
DELIMITER $$
CREATE PROCEDURE sp_practica04_case5(IN p_key VARCHAR(24)) SQL SECURITY DEFINER
BEGIN
 DECLARE buyer BIGINT UNSIGNED;
 DECLARE seller BIGINT UNSIGNED;
 DECLARE cart INT UNSIGNED;
 DECLARE ord INT UNSIGNED;
 DECLARE addr BIGINT UNSIGNED;
 DECLARE method_type INT UNSIGNED;
 DECLARE method_id BIGINT UNSIGNED;
 DECLARE total DECIMAL(12,2);
 DECLARE actor_key VARCHAR(48);
 IF SUBSTRING_INDEX(USER(),'@',1)<>'AppWeb' OR p_key IS NULL OR NOT REGEXP_LIKE(p_key,'^[a-z0-9-]{1,24}$','c') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Conexión o folio inválido';
 END IF;
 SELECT id INTO buyer FROM tb_users WHERE status=b'1' AND nickname LIKE 'p03-test2-%' AND NOT EXISTS(SELECT 1 FROM tb_carts c WHERE c.user_ID=tb_users.id) ORDER BY id LIMIT 1 FOR UPDATE;
 IF buyer IS NULL OR EXISTS(SELECT 1 FROM tb_payment_methods WHERE payment_reference=CONCAT('C5-',p_key)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Comprador no disponible o folio ya ejecutado';
 END IF;
 SELECT v.user_ID INTO seller
 FROM tbd_products_users_providers v JOIN tb_products p ON p.id=v.product_ID

 WHERE p.status=1 AND v.status=b'1' AND v.avalaible_date<=CURRENT_TIMESTAMP AND p.price>0 AND p.stock>=1
 GROUP BY v.user_ID HAVING COUNT(*)>=1 ORDER BY v.user_ID LIMIT 1;
 IF seller IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sin producto disponible'; END IF;
 INSERT INTO tb_carts(user_ID) VALUES(buyer);
 SET cart=LAST_INSERT_ID();
 INSERT INTO tbd_carts_items(cart_ID,provider_ID,product_ID,quantity)
 SELECT cart,seller,x.id,1
 FROM (SELECT p.id FROM tb_products p JOIN tbd_products_users_providers v ON v.product_ID=p.id
  WHERE v.user_ID=seller AND v.status=b'1' AND v.avalaible_date<=CURRENT_TIMESTAMP AND p.status=1 AND p.price>0 AND p.stock>=1
  ORDER BY RAND() LIMIT 1) x;
 IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Se requiere un producto'; END IF;
 SELECT SUM(p.price*i.quantity) INTO total FROM tbd_carts_items i JOIN tb_products p ON p.id=i.product_ID WHERE i.cart_ID=cart;
 INSERT INTO tb_buyer_orders(buyer_ID,seller_ID,subtotal) VALUES(buyer,seller,total);
 SET ord=LAST_INSERT_ID();
 INSERT INTO tbd_order_items(seller_order_ID,product_ID,product_name,quantity,unit_price)
 SELECT ord,p.id,p.name,i.quantity,p.price FROM tbd_carts_items i JOIN tb_products p ON p.id=i.product_ID WHERE i.cart_ID=cart;
 INSERT INTO tb_user_addresses(user_ID,address_label,recipient_name,recipient_phone,delivery_instructions)
 VALUES(buyer,'Destino de prueba','Comprador Simulado','5550000000','Entrega simulada en Puebla, México');
 SET addr=LAST_INSERT_ID();
 SELECT ID INTO method_type FROM tbc_payment_methods_types WHERE code='gift_coupon' AND status=b'1';
 IF method_type IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Catálogo de digital SPIN no disponible'; END IF;
 INSERT INTO tbd_user_payment_methods(user_ID,payment_method_type_ID,provider,provider_method_ref,label,last_four)
 VALUES(buyer,method_type,'BDN_SIMULATOR',CONCAT('99990000',LPAD(buyer,8,'0')),'Cupón simulado','0000');
 SET method_id=LAST_INSERT_ID();
 UPDATE tbd_user_payment_methods SET last_four=RIGHT(provider_method_ref,4) WHERE ID=method_id;
 INSERT INTO tb_payment_methods(order_ID,user_ID,payment_method_type_ID,payment_reference,amount,payment_status)
 VALUES(ord,buyer,method_type,CONCAT('C5-',p_key),total,'Pending');
 UPDATE tbd_user_payment_methods SET status=b'0' WHERE ID=method_id;
 SAVEPOINT before_inventory_simulation;
 UPDATE tb_products p JOIN tbd_carts_items i ON i.product_ID=p.id AND i.cart_ID=cart SET p.stock=0;
 IF NOT EXISTS(SELECT 1 FROM tb_products p JOIN tbd_carts_items i ON i.product_ID=p.id
  WHERE i.cart_ID=cart AND p.stock<i.quantity) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='No se reprodujo el agotamiento';
 END IF;
 ROLLBACK TO SAVEPOINT before_inventory_simulation;
 RELEASE SAVEPOINT before_inventory_simulation;
 INSERT INTO tb_cancellations(buyer_order_ID,user_ID,cancellation_reason,cancellation_status,resolved_date)
 VALUES(ord,buyer,'Inventario insuficiente simulado','Completed',NOW());
 INSERT INTO tbd_cancellation_items(cancellation_ID,order_item_ID,quantity,unit_amount)
 SELECT LAST_INSERT_ID(),ID,quantity,unit_price FROM tbd_order_items WHERE seller_order_ID=ord;
 UPDATE tb_buyer_orders SET fulfillment_status='Canceled' WHERE ID=ord;
 UPDATE tb_carts SET status=b'0' WHERE ID=cart;
 UPDATE tb_payment_methods SET payment_status='Cancelled' WHERE payment_reference=CONCAT('C5-',p_key);
 UPDATE tbd_user_payment_methods SET status=b'1' WHERE ID=method_id;
 INSERT INTO tb_logs(table_name,operation,db_user,description)
 VALUES('tb_buyer_orders','Update',USER(),JSON_OBJECT('order_id',ord,'event','insufficient_stock','coupon_id',method_id,'coupon_restored',1));
 SELECT ord AS order_id,method_id AS coupon_id,total AS attempted_total;
END$$
DELIMITER ;
GRANT EXECUTE ON PROCEDURE db_test.sp_practica04_case5 TO 'buyer'@'%';
