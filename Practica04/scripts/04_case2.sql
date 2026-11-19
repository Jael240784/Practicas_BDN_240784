USE db_test;
INSERT INTO tbc_payment_methods_types(code,description)
SELECT 'credit_card','Tarjeta de crédito simulada'
WHERE NOT EXISTS(SELECT 1 FROM tbc_payment_methods_types WHERE code='credit_card');
DROP PROCEDURE IF EXISTS sp_practica04_case2;
DELIMITER $$
CREATE PROCEDURE sp_practica04_case2(IN p_key VARCHAR(24)) SQL SECURITY DEFINER
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
 DECLARE installment INT DEFAULT 1;
 DECLARE cents BIGINT;
 DECLARE amount DECIMAL(12,2);
 DECLARE item INT UNSIGNED;
 DECLARE claim INT UNSIGNED;
 DECLARE due DATETIME;
 IF SUBSTRING_INDEX(USER(),'@',1)<>'AppWeb' OR p_key IS NULL OR NOT REGEXP_LIKE(p_key,'^[a-z0-9-]{1,24}$','c') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Conexión o folio inválido';
 END IF;
 SELECT v.user_ID INTO seller
 FROM tbd_products_users_providers v JOIN tb_products p ON p.id=v.product_ID
 WHERE p.status=1 AND v.status=b'1' AND v.avalaible_date<=CURRENT_TIMESTAMP AND p.stock>=5
 GROUP BY v.user_ID HAVING COUNT(*)>=10 ORDER BY v.user_ID LIMIT 1;
 IF seller IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sin vendedor con diez productos disponibles'; END IF;
 SELECT u.id INTO buyer FROM tb_users u JOIN tb_people p ON p.user_id=u.id
 WHERE u.status=b'1' AND u.nickname LIKE 'p03-test2-%' ORDER BY u.id LIMIT 1 FOR UPDATE;
 IF buyer IS NULL OR seller IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Comprador o vendedor no disponible'; END IF;
 IF EXISTS(SELECT 1 FROM tb_payments WHERE provider='BDN_SIMULATOR' AND provider_reference=CONCAT('C2-',p_key,'-1')) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Caso ya ejecutado';
 END IF;
 INSERT INTO tb_carts(user_ID) VALUES(buyer);
 SET cart=LAST_INSERT_ID();
 INSERT INTO tbd_carts_items(cart_ID,provider_ID,product_ID,quantity)
 SELECT cart,seller,x.id,1+FLOOR(RAND()*5)
 FROM (SELECT p.id FROM tb_products p JOIN tbd_products_users_providers v ON v.product_ID=p.id
  WHERE v.user_ID=seller AND v.status=b'1' AND v.avalaible_date<=CURRENT_TIMESTAMP AND p.status=1 AND p.stock>=5
  ORDER BY RAND() LIMIT 10) x;
 IF ROW_COUNT()<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Se requieren diez productos'; END IF;
 SELECT SUM(p.price*i.quantity) INTO total FROM tbd_carts_items i JOIN tb_products p ON p.id=i.product_ID WHERE i.cart_ID=cart;
 INSERT INTO tb_buyer_orders(buyer_ID,seller_ID,subtotal) VALUES(buyer,seller,total);
 SET ord=LAST_INSERT_ID();
 INSERT INTO tbd_order_items(seller_order_ID,product_ID,product_name,quantity,unit_price)
 SELECT ord,p.id,p.name,i.quantity,p.price FROM tbd_carts_items i JOIN tb_products p ON p.id=i.product_ID WHERE i.cart_ID=cart;
 INSERT INTO tb_user_addresses(user_ID,address_label,recipient_name,recipient_phone,delivery_instructions)
 VALUES(buyer,'Trabajo de prueba','Comprador Simulado','5550000000','Oficina ficticia en Puebla, México');
 SET addr=LAST_INSERT_ID();
 SELECT ID INTO method_type FROM tbc_payment_methods_types WHERE code='credit_card' AND status=b'1';
 IF method_type IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Catálogo de crédito no disponible'; END IF;
 INSERT INTO tbd_user_payment_methods(user_ID,payment_method_type_ID,provider,provider_method_ref,label,last_four)
 VALUES(buyer,method_type,'BDN_SIMULATOR',CONCAT('99990000',LPAD(buyer,8,'0')),'Crédito simulado','0000');
 SET method_id=LAST_INSERT_ID();
 UPDATE tbd_user_payment_methods SET last_four=RIGHT(provider_method_ref,4) WHERE ID=method_id;
 UPDATE tb_users SET rol='buyer' WHERE id=buyer;
 SET cents=ROUND(total*100);
 WHILE installment<=6 DO
  SET amount=((cents DIV 6)+IF(installment=6,MOD(cents,6),0))/100;
  SET due=DATE_ADD(NOW(),INTERVAL (installment-1) MONTH);
  INSERT INTO tb_payments(order_ID,amount,payment_method,provider,provider_reference,payment_status,creation_date,paid_date)
  VALUES(ord,amount,'Card','BDN_SIMULATOR',CONCAT('C2-',p_key,'-',installment),
   IF(installment=6,'Failed','Paid'),due,IF(installment=6,NULL,due));
  SET payment=LAST_INSERT_ID();
  INSERT INTO tb_payment_transactions(payment_ID,event_type,amount,event_reference,remarks,creation_date)
  VALUES(payment,IF(installment=6,'Failed','Authorized'),amount,CONCAT('C2-TX-',ord,'-',installment),
   IF(installment=6,'Límite excedido de crédito',NULL),due);
  SET installment=installment+1;
 END WHILE;
 INSERT INTO tb_payment_methods(order_ID,user_ID,payment_method_type_ID,payment_reference,amount,payment_status)
 VALUES(ord,buyer,method_type,CONCAT('BDN-CREDIT-',method_id),total,'Authorized');
 UPDATE tb_products p JOIN tbd_carts_items i ON i.product_ID=p.id AND i.cart_ID=cart
 SET p.stock=p.stock-i.quantity WHERE p.stock>=i.quantity AND p.status=1;
 IF ROW_COUNT()<>10 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Inventario insuficiente'; END IF;
 UPDATE tb_carts SET status=b'0' WHERE ID=cart;
 UPDATE tb_buyer_orders SET fulfillment_status='Accepted' WHERE ID=ord;
 UPDATE tb_buyer_orders SET fulfillment_status='Preparing' WHERE ID=ord;
 INSERT INTO tb_shipments(buyer_order_ID,address_ID,carrier,tracking_number,shipment_status)
 VALUES(ord,addr,'BDN simulado',CONCAT('BDN-C2-',ord),'Preparing');
 UPDATE tb_shipments SET shipment_status='Shipped',shipped_date=CURRENT_TIMESTAMP WHERE buyer_order_ID=ord;
 UPDATE tb_buyer_orders SET fulfillment_status='Sent' WHERE ID=ord;
 UPDATE tb_shipments SET shipment_status='Delivered',delivered_date=CURRENT_TIMESTAMP WHERE buyer_order_ID=ord;
 UPDATE tb_buyer_orders SET fulfillment_status='Delivered' WHERE ID=ord;
 SELECT MIN(ID) INTO item FROM tbd_order_items WHERE seller_order_ID=ord;
 INSERT INTO tb_returns(buyer_order_ID,order_item_ID,user_ID,quantity,return_reason)
 VALUES(ord,item,buyer,1,'Producto dañado');
 SET claim=LAST_INSERT_ID();
 INSERT INTO tbd_return_items(return_ID,order_item_ID,quantity,unit_amount,item_condition)
 SELECT claim,ID,1,unit_price,'Damaged' FROM tbd_order_items WHERE ID=item;
 UPDATE tb_returns SET return_status='Authorized' WHERE ID=claim;
 UPDATE tb_returns SET return_status='Received',received_date=NOW() WHERE ID=claim;
 UPDATE tb_products p JOIN tbd_order_items i ON i.product_ID=p.id
 SET p.stock=p.stock-1 WHERE i.ID=item AND p.stock>=1 AND p.status=1;
 IF ROW_COUNT()<>1 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sin stock para reenvío'; END IF;
 INSERT INTO tb_shipments(buyer_order_ID,address_ID,carrier,tracking_number,shipment_status)
 VALUES(ord,addr,'BDN reposición simulada',CONCAT('BDN-C2-RE-',claim),'Preparing');
 UPDATE tb_shipments SET shipment_status='Shipped',shipped_date=NOW() WHERE tracking_number=CONCAT('BDN-C2-RE-',claim);
 UPDATE tb_shipments SET shipment_status='Delivered',delivered_date=NOW() WHERE tracking_number=CONCAT('BDN-C2-RE-',claim);
 UPDATE tb_returns SET return_status='Completed',resolved_date=NOW(),resolution_notes='Reemplazo entregado' WHERE ID=claim;
 SELECT buyer AS buyer_id,ord AS order_id,claim AS return_id,total AS order_total;
END$$
DELIMITER ;
GRANT EXECUTE ON PROCEDURE db_test.sp_practica04_case2 TO 'buyer'@'%';
