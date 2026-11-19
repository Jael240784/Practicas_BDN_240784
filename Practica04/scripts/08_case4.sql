USE db_test;
INSERT INTO tbc_payment_methods_types(code,description) SELECT 'spei','Transferencia SPEI simulada'
WHERE NOT EXISTS(SELECT 1 FROM tbc_payment_methods_types WHERE code='spei');
DROP PROCEDURE IF EXISTS sp_practica04_case4;
DELIMITER $$
CREATE PROCEDURE sp_practica04_case4(IN p_key VARCHAR(24)) SQL SECURITY DEFINER
BEGIN
 DECLARE buyer BIGINT UNSIGNED;
 DECLARE seller BIGINT UNSIGNED;
 DECLARE cart INT UNSIGNED;
 DECLARE ord INT UNSIGNED;
 DECLARE addr BIGINT UNSIGNED;
 DECLARE payment INT UNSIGNED;
 DECLARE method_type INT UNSIGNED;
 DECLARE method_id BIGINT UNSIGNED;
 DECLARE total DECIMAL(12,2);
 DECLARE actor_key VARCHAR(48);
 IF SUBSTRING_INDEX(USER(),'@',1)<>'AppWeb' OR p_key IS NULL OR NOT REGEXP_LIKE(p_key,'^[a-z0-9-]{1,24}$','c') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Conexión o folio inválido';
 END IF;
 SELECT id INTO buyer FROM tb_users WHERE status=b'1' AND nickname LIKE 'p03-test2-%' AND NOT EXISTS(SELECT 1 FROM tb_carts c WHERE c.user_ID=tb_users.id) ORDER BY id LIMIT 1 FOR UPDATE;
 IF buyer IS NULL OR EXISTS(SELECT 1 FROM tb_payments WHERE provider='BDN_SIMULATOR' AND provider_reference=CONCAT('C4-',p_key)) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Comprador no disponible o folio ya ejecutado';
 END IF;
 SELECT v.user_ID INTO seller
 FROM tbd_products_users_providers v JOIN tb_products p ON p.id=v.product_ID

 WHERE p.status=1 AND v.status=b'1' AND v.avalaible_date<=CURRENT_TIMESTAMP AND p.price>0 AND p.stock>=3
 GROUP BY v.user_ID HAVING COUNT(*)>=3 ORDER BY v.user_ID LIMIT 1;
 IF seller IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sin tres productos disponibles del mismo proveedor'; END IF;
 INSERT INTO tb_carts(user_ID) VALUES(buyer);
 SET cart=LAST_INSERT_ID();
 INSERT INTO tbd_carts_items(cart_ID,provider_ID,product_ID,quantity)
 SELECT cart,seller,x.id,1+FLOOR(RAND()*3)
 FROM (SELECT p.id FROM tb_products p JOIN tbd_products_users_providers v ON v.product_ID=p.id
  WHERE v.user_ID=seller AND v.status=b'1' AND v.avalaible_date<=CURRENT_TIMESTAMP AND p.status=1 AND p.price>0 AND p.stock>=3
  ORDER BY RAND() LIMIT 3) x;
 IF ROW_COUNT()<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Se requieren tres productos'; END IF;
 SELECT SUM(p.price*i.quantity) INTO total FROM tbd_carts_items i JOIN tb_products p ON p.id=i.product_ID WHERE i.cart_ID=cart;
 INSERT INTO tb_buyer_orders(buyer_ID,seller_ID,subtotal) VALUES(buyer,seller,total);
 SET ord=LAST_INSERT_ID();
 INSERT INTO tbd_order_items(seller_order_ID,product_ID,product_name,quantity,unit_price)
 SELECT ord,p.id,p.name,i.quantity,p.price FROM tbd_carts_items i JOIN tb_products p ON p.id=i.product_ID WHERE i.cart_ID=cart;
 INSERT INTO tb_user_addresses(user_ID,address_label,recipient_name,recipient_phone,delivery_instructions)
 VALUES(buyer,'Punto de recolección de prueba','Comprador Simulado','5550000000','Recolección en punto de prueba en Puebla, México');
 SET addr=LAST_INSERT_ID();
 SELECT ID INTO method_type FROM tbc_payment_methods_types WHERE code='spei' AND status=b'1';
 IF method_type IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Catálogo de digital SPIN no disponible'; END IF;
 INSERT INTO tbd_user_payment_methods(user_ID,payment_method_type_ID,provider,provider_method_ref,label,last_four)
 VALUES(buyer,method_type,'BDN_SIMULATOR',CONCAT('99990000',LPAD(buyer,8,'0')),'SPEI simulado','0000');
 SET method_id=LAST_INSERT_ID();
 UPDATE tbd_user_payment_methods SET last_four=RIGHT(provider_method_ref,4) WHERE ID=method_id;
 UPDATE tb_users SET rol='buyer' WHERE id=buyer;
 INSERT INTO tb_payment_methods(order_ID,user_ID,payment_method_type_ID,payment_reference,amount,payment_status,payment_date)
 VALUES(ord,buyer,method_type,CONCAT('C4-',p_key),total,'Paid',CURRENT_TIMESTAMP);
 INSERT INTO tb_payments(order_ID,amount,payment_method,provider,provider_reference,payment_status,paid_date)
 VALUES(ord,total,'SPEI','BDN_SIMULATOR',CONCAT('C4-',p_key),'Paid',CURRENT_TIMESTAMP);
 SET payment=LAST_INSERT_ID();
 INSERT INTO tb_payment_transactions(payment_ID,event_type,amount,event_reference)
 VALUES(payment,'Authorized',total,CONCAT('BDN-C4-',ord));
 UPDATE tb_products p JOIN tbd_carts_items i ON i.product_ID=p.id AND i.cart_ID=cart
 SET p.stock=p.stock-i.quantity WHERE p.stock>=i.quantity AND p.status=1;
 IF ROW_COUNT()<>3 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Inventario insuficiente'; END IF;
 UPDATE tb_carts SET status=b'0' WHERE ID=cart;
 UPDATE tb_buyer_orders SET fulfillment_status='Accepted' WHERE ID=ord;
 UPDATE tb_buyer_orders SET fulfillment_status='Preparing' WHERE ID=ord;
 INSERT INTO tb_shipments(buyer_order_ID,address_ID,carrier,tracking_number,shipment_status)
 VALUES(ord,addr,'BDN simulado',CONCAT('BDN-C4-',ord),'Preparing');
 UPDATE tb_shipments SET shipment_status='Shipped',shipped_date=CURRENT_TIMESTAMP WHERE buyer_order_ID=ord;
 UPDATE tb_buyer_orders SET fulfillment_status='Sent' WHERE ID=ord;
 UPDATE tb_shipments SET shipment_status='Failed' WHERE buyer_order_ID=ord;
 INSERT INTO tb_logs(table_name,operation,db_user,description)
 VALUES('tb_shipments','Update',USER(),JSON_OBJECT('order_id',ord,'event','recipient_absent','next_step','pickup'));
 UPDATE tb_shipments SET shipment_status='Delivered',delivered_date=CURRENT_TIMESTAMP WHERE buyer_order_ID=ord;
 UPDATE tb_buyer_orders SET fulfillment_status='Delivered' WHERE ID=ord;
 INSERT INTO tb_logs(table_name,operation,db_user,description)
 VALUES('tb_shipments','Update',USER(),JSON_OBJECT('order_id',ord,'event','pickup_completed','address_id',addr));
 SELECT ord AS order_id,seller AS provider_id,total AS paid_total;
END$$
DELIMITER ;
GRANT EXECUTE ON PROCEDURE db_test.sp_practica04_case4 TO 'buyer'@'%';
