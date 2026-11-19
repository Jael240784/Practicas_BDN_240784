USE db_test;
CREATE ROLE IF NOT EXISTS 'user_not_registered'@'%', 'buyer'@'%';
DROP PROCEDURE IF EXISTS sp_practica04_case1_prepare;
DELIMITER $$
CREATE PROCEDURE sp_practica04_case1_prepare(IN p_key VARCHAR(24)) SQL SECURITY DEFINER
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
 IF SUBSTRING_INDEX(USER(),'@',1)<>'AppWeb' THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Se requiere la conexión AppWeb';
 END IF;
 IF p_key IS NULL OR NOT REGEXP_LIKE(p_key,'^[a-z0-9-]{1,24}$','c') THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Folio de prueba inválido';
 END IF;
 SET actor_key=CONCAT('p04-c1-',p_key);
 IF EXISTS(SELECT 1 FROM tb_users WHERE nickname=actor_key) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='El folio de prueba ya existe';
 END IF;
 SELECT v.user_ID INTO seller
 FROM tbd_products_users_providers v JOIN tb_products p ON p.id=v.product_ID
 WHERE p.status=1 AND v.status=b'1' AND v.avalaible_date<=CURRENT_TIMESTAMP AND p.stock>=5
 GROUP BY v.user_ID HAVING COUNT(*)>=5 ORDER BY v.user_ID LIMIT 1;
 IF seller IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Sin vendedor con cinco productos disponibles'; END IF;
 INSERT INTO tb_users(email,nickname,rol) VALUES(CONCAT(actor_key,'@example.invalid'),actor_key,'unregistered');
 SET buyer=LAST_INSERT_ID();
 INSERT INTO tb_people(user_id,given_names,paternal_surname,country_code) VALUES(buyer,'Comprador','Simulado','MX');
 INSERT INTO tb_carts(user_ID) VALUES(buyer);
 SET cart=LAST_INSERT_ID();
 INSERT INTO tbd_carts_items(cart_ID,provider_ID,product_ID,quantity)
 SELECT cart,seller,x.id,ROW_NUMBER() OVER(ORDER BY x.id)
 FROM (SELECT p.id FROM tb_products p JOIN tbd_products_users_providers v ON v.product_ID=p.id
  WHERE v.user_ID=seller AND v.status=b'1' AND v.avalaible_date<=CURRENT_TIMESTAMP AND p.status=1 AND p.stock>=5
  ORDER BY RAND() LIMIT 5) x;
 IF ROW_COUNT()<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Se requieren cinco productos'; END IF;
 SELECT SUM(p.price*i.quantity) INTO total FROM tbd_carts_items i JOIN tb_products p ON p.id=i.product_ID WHERE i.cart_ID=cart;
 INSERT INTO tb_buyer_orders(buyer_ID,seller_ID,subtotal) VALUES(buyer,seller,total);
 SET ord=LAST_INSERT_ID();
 INSERT INTO tbd_order_items(seller_order_ID,product_ID,product_name,quantity,unit_price)
 SELECT ord,p.id,p.name,i.quantity,p.price FROM tbd_carts_items i JOIN tb_products p ON p.id=i.product_ID WHERE i.cart_ID=cart;
 INSERT INTO tb_user_addresses(user_ID,address_label,recipient_name,recipient_phone,delivery_instructions)
 VALUES(buyer,'Casa de prueba','Comprador Simulado','5550000000','Domicilio ficticio en Puebla, México');
 SET addr=LAST_INSERT_ID();
END$$
DELIMITER ;
DROP PROCEDURE IF EXISTS sp_practica04_case1_pay_deliver;
DELIMITER $$
CREATE PROCEDURE sp_practica04_case1_pay_deliver(IN p_key VARCHAR(24)) SQL SECURITY DEFINER
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
 IF SUBSTRING_INDEX(USER(),'@',1)<>'AppWeb' THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Se requiere la conexión AppWeb';
 END IF;
 SET actor_key=CONCAT('p04-c1-',p_key);
 SELECT u.id,o.ID,o.subtotal,s.ID,c.ID INTO buyer,ord,total,addr,cart
 FROM tb_users u JOIN tb_buyer_orders o ON o.buyer_ID=u.id
 JOIN tb_user_addresses s ON s.user_ID=u.id
 JOIN tb_carts c ON c.user_ID=u.id AND c.status=b'1'
 WHERE u.nickname=actor_key AND u.rol='unregistered' AND o.fulfillment_status='Pending'
 FOR UPDATE;
 IF ord IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Preparación pendiente requerida'; END IF;
 SELECT ID INTO method_type FROM tbc_payment_methods_types WHERE code='debit_card' AND status=b'1';
 IF method_type IS NULL THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Catálogo de débito no disponible'; END IF;
 INSERT INTO tbd_user_payment_methods(user_ID,payment_method_type_ID,provider,provider_method_ref,label,last_four)
 VALUES(buyer,method_type,'BDN_SIMULATOR',CONCAT('99990000',LPAD(buyer,8,'0')),'Débito simulado','0000');
 SET method_id=LAST_INSERT_ID();
 UPDATE tbd_user_payment_methods SET last_four=RIGHT(provider_method_ref,4) WHERE ID=method_id;
 UPDATE tb_users SET rol='buyer' WHERE id=buyer;
 INSERT INTO tb_payment_methods(order_ID,user_ID,payment_method_type_ID,payment_reference,amount,payment_status,payment_date)
 VALUES(ord,buyer,method_type,CONCAT('BDN-DEBIT-',method_id),total,'Paid',CURRENT_TIMESTAMP);
 INSERT INTO tb_payments(order_ID,amount,payment_method,provider,provider_reference,payment_status,paid_date)
 VALUES(ord,total,'Card','BDN_SIMULATOR',CONCAT('BDN-DEBIT-',method_id),'Paid',CURRENT_TIMESTAMP);
 SET payment=LAST_INSERT_ID();
 INSERT INTO tb_payment_transactions(payment_ID,event_type,amount,event_reference)
 VALUES(payment,'Authorized',total,CONCAT('BDN-C1-',ord));
 UPDATE tb_products p JOIN tbd_carts_items i ON i.product_ID=p.id AND i.cart_ID=cart
 SET p.stock=p.stock-i.quantity WHERE p.stock>=i.quantity AND p.status=1;
 IF ROW_COUNT()<>5 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Inventario insuficiente'; END IF;
 UPDATE tb_carts SET status=b'0' WHERE ID=cart;
 UPDATE tb_buyer_orders SET fulfillment_status='Accepted' WHERE ID=ord;
 UPDATE tb_buyer_orders SET fulfillment_status='Preparing' WHERE ID=ord;
 INSERT INTO tb_shipments(buyer_order_ID,address_ID,carrier,tracking_number,shipment_status)
 VALUES(ord,addr,'BDN simulado',CONCAT('BDN-C1-',ord),'Preparing');
 UPDATE tb_shipments SET shipment_status='Shipped',shipped_date=CURRENT_TIMESTAMP WHERE buyer_order_ID=ord;
 UPDATE tb_buyer_orders SET fulfillment_status='Sent' WHERE ID=ord;
 UPDATE tb_shipments SET shipment_status='Delivered',delivered_date=CURRENT_TIMESTAMP WHERE buyer_order_ID=ord;
 UPDATE tb_buyer_orders SET fulfillment_status='Delivered' WHERE ID=ord;
 SELECT buyer AS buyer_id,cart AS cart_id,ord AS order_id,payment AS payment_id,total AS total_paid;
END$$
DELIMITER ;

GRANT EXECUTE ON PROCEDURE db_test.sp_practica04_case1_prepare TO 'user_not_registered'@'%';
GRANT EXECUTE ON PROCEDURE db_test.sp_practica04_case1_pay_deliver TO 'buyer'@'%';
