-- DDL adaptado del respaldo 1811 de la referencia de Natalia.
-- Conserva las tablas y los datos existentes de 240784.
USE db_test;

CREATE TABLE IF NOT EXISTS `tb_buyer_orders` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `buyer_ID` bigint unsigned NOT NULL,
  `seller_ID` bigint unsigned NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `shipping_cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `fulfillment_status` enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `fk_seller_orders_seller` (`seller_ID`),
  CONSTRAINT `fk_seller_orders_seller` FOREIGN KEY (`seller_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT fk_adapt_tb_buyer_orders_754 FOREIGN KEY (`buyer_ID`) REFERENCES `tb_users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tb_buyer_orders_insert AFTER INSERT ON tb_buyer_orders FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_buyer_orders','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_buyer_orders_update AFTER UPDATE ON tb_buyer_orders FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_buyer_orders','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_buyer_orders_delete AFTER DELETE ON tb_buyer_orders FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_buyer_orders','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tb_buyer_orders AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tb_buyer_orders';

CREATE TABLE IF NOT EXISTS `tb_carts` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` bigint unsigned NOT NULL,
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_cart_user` (`user_ID`),
  CONSTRAINT `tb_carts_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tb_carts_insert AFTER INSERT ON tb_carts FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_carts','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_carts_update AFTER UPDATE ON tb_carts FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_carts','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_carts_delete AFTER DELETE ON tb_carts FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_carts','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tb_carts AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tb_carts';

CREATE TABLE IF NOT EXISTS `tb_user_addresses` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` bigint unsigned NOT NULL,
  `address_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `recipient_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `recipient_phone` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `delivery_instructions` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_user_addresses` (`user_ID`),
  CONSTRAINT `fk_addresses_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tb_user_addresses_insert AFTER INSERT ON tb_user_addresses FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_user_addresses','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_user_addresses_update AFTER UPDATE ON tb_user_addresses FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_user_addresses','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_user_addresses_delete AFTER DELETE ON tb_user_addresses FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_user_addresses','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tb_user_addresses AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tb_user_addresses';

CREATE TABLE IF NOT EXISTS `tbc_payment_methods_types` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tbc_payment_methods_types_insert AFTER INSERT ON tbc_payment_methods_types FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbc_payment_methods_types','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbc_payment_methods_types_update AFTER UPDATE ON tbc_payment_methods_types FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbc_payment_methods_types','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbc_payment_methods_types_delete AFTER DELETE ON tbc_payment_methods_types FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbc_payment_methods_types','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tbc_payment_methods_types AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tbc_payment_methods_types';

CREATE TABLE IF NOT EXISTS `tbd_products_users_providers` (
  `user_ID` bigint unsigned NOT NULL,
  `product_ID` bigint unsigned NOT NULL,
  `type_ownership` enum('Owner','Reseller','Distributor') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `avalaible_date` datetime NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_ID`,`product_ID`),
  KEY `fk_products2` (`product_ID`),
  CONSTRAINT `fk_products2` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`),
  CONSTRAINT `fk_user1` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tbd_products_users_providers_insert AFTER INSERT ON tbd_products_users_providers FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_products_users_providers','Create',USER(),JSON_OBJECT('user_ID', NEW.`user_ID`, 'product_ID', NEW.`product_ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_products_users_providers_update AFTER UPDATE ON tbd_products_users_providers FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_products_users_providers','Update',USER(),JSON_OBJECT('user_ID', NEW.`user_ID`, 'product_ID', NEW.`product_ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_products_users_providers_delete AFTER DELETE ON tbd_products_users_providers FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_products_users_providers','Delete',USER(),JSON_OBJECT('user_ID', OLD.`user_ID`, 'product_ID', OLD.`product_ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tbd_products_users_providers AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tbd_products_users_providers';

CREATE TABLE IF NOT EXISTS `tbd_users_wishlist_products` (
  `user_ID` bigint unsigned NOT NULL,
  `product_ID` bigint unsigned NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_ID`,`product_ID`),
  CONSTRAINT fk_adapt_tbd_users_wishlist_products_345 FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`id`),
  CONSTRAINT fk_adapt_tbd_users_wishlist_products_401 FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tbd_users_wishlist_products_insert AFTER INSERT ON tbd_users_wishlist_products FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_users_wishlist_products','Create',USER(),JSON_OBJECT('user_ID', NEW.`user_ID`, 'product_ID', NEW.`product_ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_users_wishlist_products_update AFTER UPDATE ON tbd_users_wishlist_products FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_users_wishlist_products','Update',USER(),JSON_OBJECT('user_ID', NEW.`user_ID`, 'product_ID', NEW.`product_ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_users_wishlist_products_delete AFTER DELETE ON tbd_users_wishlist_products FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_users_wishlist_products','Delete',USER(),JSON_OBJECT('user_ID', OLD.`user_ID`, 'product_ID', OLD.`product_ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tbd_users_wishlist_products AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tbd_users_wishlist_products';

CREATE TABLE IF NOT EXISTS `tb_cancellations` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `buyer_order_ID` int unsigned NOT NULL,
  `user_ID` bigint unsigned NOT NULL,
  `cancellation_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cancellation_status` enum('Requested','Approved','Rejected','Completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Requested',
  `requested_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_date` datetime DEFAULT NULL,
  `resolution_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_cancellation_order` (`buyer_order_ID`),
  KEY `idx_cancellation_user` (`user_ID`),
  CONSTRAINT `fk_cancellations_order` FOREIGN KEY (`buyer_order_ID`) REFERENCES `tb_buyer_orders` (`ID`),
  CONSTRAINT `fk_cancellations_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tb_cancellations_insert AFTER INSERT ON tb_cancellations FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_cancellations','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_cancellations_update AFTER UPDATE ON tb_cancellations FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_cancellations','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_cancellations_delete AFTER DELETE ON tb_cancellations FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_cancellations','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tb_cancellations AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tb_cancellations';

CREATE TABLE IF NOT EXISTS `tb_payment_methods` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `user_ID` bigint unsigned NOT NULL,
  `payment_method_type_ID` int unsigned NOT NULL,
  `payment_reference` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'MXN',
  `payment_status` enum('Pending','Authorized','Paid','Failed','Cancelled','Refunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending',
  `payment_date` datetime DEFAULT NULL,
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_payment_methods_order` (`order_ID`),
  KEY `idx_payment_methods_user` (`user_ID`),
  KEY `idx_payment_methods_type` (`payment_method_type_ID`),
  CONSTRAINT `fk_payment_methods_type` FOREIGN KEY (`payment_method_type_ID`) REFERENCES `tbc_payment_methods_types` (`ID`),
  CONSTRAINT `fk_payment_methods_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT fk_adapt_tb_payment_methods_1281 FOREIGN KEY (`order_ID`) REFERENCES `tb_buyer_orders` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tb_payment_methods_insert AFTER INSERT ON tb_payment_methods FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_payment_methods','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_payment_methods_update AFTER UPDATE ON tb_payment_methods FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_payment_methods','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_payment_methods_delete AFTER DELETE ON tb_payment_methods FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_payment_methods','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tb_payment_methods AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tb_payment_methods';

CREATE TABLE IF NOT EXISTS `tb_payments` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'MXN',
  `payment_method` enum('Card','SPEI','Transfer','Cash') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `provider` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `provider_reference` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `payment_status` enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `paid_date` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_payment_reference` (`provider`,`provider_reference`),
  KEY `fk_payments_buyer_orders` (`order_ID`),
  CONSTRAINT `fk_payments_buyer_orders` FOREIGN KEY (`order_ID`) REFERENCES `tb_buyer_orders` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tb_payments_insert AFTER INSERT ON tb_payments FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_payments','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_payments_update AFTER UPDATE ON tb_payments FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_payments','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_payments_delete AFTER DELETE ON tb_payments FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_payments','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tb_payments AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tb_payments';

CREATE TABLE IF NOT EXISTS `tb_shipments` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `buyer_order_ID` int unsigned NOT NULL,
  `address_ID` bigint unsigned NOT NULL,
  `carrier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `tracking_number` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `shipping_cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `shipment_status` enum('Pending','Preparing','Shipped','InTransit','Delivered','Failed','Returned') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pending',
  `shipped_date` datetime DEFAULT NULL,
  `estimated_delivery_date` datetime DEFAULT NULL,
  `delivered_date` datetime DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_shipment_tracking` (`carrier`,`tracking_number`),
  KEY `idx_shipment_order` (`buyer_order_ID`),
  KEY `idx_shipment_address` (`address_ID`),
  CONSTRAINT `fk_shipments_address` FOREIGN KEY (`address_ID`) REFERENCES `tb_user_addresses` (`ID`),
  CONSTRAINT `fk_shipments_order` FOREIGN KEY (`buyer_order_ID`) REFERENCES `tb_buyer_orders` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tb_shipments_insert AFTER INSERT ON tb_shipments FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_shipments','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_shipments_update AFTER UPDATE ON tb_shipments FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_shipments','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_shipments_delete AFTER DELETE ON tb_shipments FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_shipments','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tb_shipments AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tb_shipments';

CREATE TABLE IF NOT EXISTS `tbd_address_components` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `address_ID` bigint unsigned NOT NULL,
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `component_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `address_sup_ID` bigint unsigned DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_address_component` (`address_ID`,`ID`),
  KEY `idx_address_parent` (`address_ID`,`address_sup_ID`),
  CONSTRAINT `fk_component_address` FOREIGN KEY (`address_ID`) REFERENCES `tb_user_addresses` (`ID`),
  CONSTRAINT `fk_component_parent` FOREIGN KEY (`address_ID`, `address_sup_ID`) REFERENCES `tbd_address_components` (`address_ID`, `ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tbd_address_components_insert AFTER INSERT ON tbd_address_components FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_address_components','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_address_components_update AFTER UPDATE ON tbd_address_components FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_address_components','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_address_components_delete AFTER DELETE ON tbd_address_components FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_address_components','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tbd_address_components AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tbd_address_components';

CREATE TABLE IF NOT EXISTS `tbd_carts_items` (
  `cart_ID` int unsigned NOT NULL,
  `provider_ID` bigint unsigned NOT NULL,
  `product_ID` bigint unsigned NOT NULL,
  `quantity` int NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_ID`,`provider_ID`,`product_ID`),
  CONSTRAINT fk_adapt_tbd_carts_items_309 FOREIGN KEY (`cart_ID`) REFERENCES `tb_carts` (`ID`),
  CONSTRAINT fk_adapt_tbd_carts_items_365 FOREIGN KEY (`provider_ID`,`product_ID`) REFERENCES `tbd_products_users_providers` (`user_ID`,`product_ID`),
  CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tbd_carts_items_insert AFTER INSERT ON tbd_carts_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_carts_items','Create',USER(),JSON_OBJECT('cart_ID', NEW.`cart_ID`, 'provider_ID', NEW.`provider_ID`, 'product_ID', NEW.`product_ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_carts_items_update AFTER UPDATE ON tbd_carts_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_carts_items','Update',USER(),JSON_OBJECT('cart_ID', NEW.`cart_ID`, 'provider_ID', NEW.`provider_ID`, 'product_ID', NEW.`product_ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_carts_items_delete AFTER DELETE ON tbd_carts_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_carts_items','Delete',USER(),JSON_OBJECT('cart_ID', OLD.`cart_ID`, 'provider_ID', OLD.`provider_ID`, 'product_ID', OLD.`product_ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tbd_carts_items AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tbd_carts_items';

CREATE TABLE IF NOT EXISTS `tbd_order_items` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `seller_order_ID` int unsigned NOT NULL,
  `product_ID` bigint unsigned NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `quantity` int unsigned NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) GENERATED ALWAYS AS ((`quantity` * `unit_price`)) STORED,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `seller_order_ID` (`seller_order_ID`),
  KEY `product_ID` (`product_ID`),
  CONSTRAINT `tbd_order_items_ibfk_1` FOREIGN KEY (`seller_order_ID`) REFERENCES `tb_buyer_orders` (`ID`),
  CONSTRAINT fk_adapt_tbd_order_items_697 FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`id`),
  CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tbd_order_items_insert AFTER INSERT ON tbd_order_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_order_items','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_order_items_update AFTER UPDATE ON tbd_order_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_order_items','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_order_items_delete AFTER DELETE ON tbd_order_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_order_items','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tbd_order_items AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tbd_order_items';

CREATE TABLE IF NOT EXISTS `tbd_user_payment_methods` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` bigint unsigned NOT NULL,
  `payment_method_type_ID` int unsigned NOT NULL,
  `provider` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `provider_method_ref` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `last_four` char(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `is_default` tinyint NOT NULL DEFAULT '0',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_provider_method` (`provider`,`provider_method_ref`),
  KEY `user_ID` (`user_ID`),
  KEY `payment_method_type_ID` (`payment_method_type_ID`),
  CONSTRAINT `tbd_user_payment_methods_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT `tbd_user_payment_methods_ibfk_2` FOREIGN KEY (`payment_method_type_ID`) REFERENCES `tbc_payment_methods_types` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tbd_user_payment_methods_insert AFTER INSERT ON tbd_user_payment_methods FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_user_payment_methods','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_user_payment_methods_update AFTER UPDATE ON tbd_user_payment_methods FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_user_payment_methods','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_user_payment_methods_delete AFTER DELETE ON tbd_user_payment_methods FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_user_payment_methods','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tbd_user_payment_methods AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tbd_user_payment_methods';

CREATE TABLE IF NOT EXISTS `tb_payment_transactions` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `payment_ID` int unsigned NOT NULL,
  `event_type` enum('Created','Authorized','Captured','Failed','Refunded','PartiallyRefunded') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `event_reference` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `remarks` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `fk_transactions_payments` (`payment_ID`),
  CONSTRAINT `fk_transactions_payments` FOREIGN KEY (`payment_ID`) REFERENCES `tb_payments` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tb_payment_transactions_insert AFTER INSERT ON tb_payment_transactions FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_payment_transactions','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_payment_transactions_update AFTER UPDATE ON tb_payment_transactions FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_payment_transactions','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_payment_transactions_delete AFTER DELETE ON tb_payment_transactions FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_payment_transactions','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tb_payment_transactions AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tb_payment_transactions';

CREATE TABLE IF NOT EXISTS `tb_returns` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `buyer_order_ID` int unsigned NOT NULL,
  `order_item_ID` int unsigned NOT NULL,
  `user_ID` bigint unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `return_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `return_status` enum('Requested','Authorized','Rejected','InTransit','Received','Inspected','Completed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Requested',
  `requested_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `received_date` datetime DEFAULT NULL,
  `resolved_date` datetime DEFAULT NULL,
  `resolution_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_return_order` (`buyer_order_ID`),
  KEY `idx_return_item` (`order_item_ID`),
  KEY `idx_return_user` (`user_ID`),
  CONSTRAINT `fk_returns_item` FOREIGN KEY (`order_item_ID`) REFERENCES `tbd_order_items` (`ID`),
  CONSTRAINT `fk_returns_order` FOREIGN KEY (`buyer_order_ID`) REFERENCES `tb_buyer_orders` (`ID`),
  CONSTRAINT `fk_returns_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tb_returns_insert AFTER INSERT ON tb_returns FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_returns','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_returns_update AFTER UPDATE ON tb_returns FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_returns','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_returns_delete AFTER DELETE ON tb_returns FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_returns','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tb_returns AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tb_returns';

CREATE TABLE IF NOT EXISTS `tbd_cancellation_items` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `cancellation_ID` int unsigned NOT NULL,
  `order_item_ID` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `unit_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `item_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_cancellation_items_cancellation` (`cancellation_ID`),
  KEY `idx_cancellation_items_order_item` (`order_item_ID`),
  CONSTRAINT `fk_cancellation_items_cancellation` FOREIGN KEY (`cancellation_ID`) REFERENCES `tb_cancellations` (`ID`),
  CONSTRAINT `fk_cancellation_items_order_item` FOREIGN KEY (`order_item_ID`) REFERENCES `tbd_order_items` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tbd_cancellation_items_insert AFTER INSERT ON tbd_cancellation_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_cancellation_items','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_cancellation_items_update AFTER UPDATE ON tbd_cancellation_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_cancellation_items','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_cancellation_items_delete AFTER DELETE ON tbd_cancellation_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_cancellation_items','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tbd_cancellation_items AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tbd_cancellation_items';

CREATE TABLE IF NOT EXISTS `tb_refunds` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `payment_ID` int unsigned NOT NULL,
  `cancellation_ID` int unsigned DEFAULT NULL,
  `return_ID` int unsigned DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'MXN',
  `refund_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `refund_status` enum('Requested','Approved','Processing','Completed','Rejected','Failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Requested',
  `provider_reference` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `requested_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `processed_date` datetime DEFAULT NULL,
  `resolution_notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_refund_payment` (`payment_ID`),
  KEY `idx_refund_cancellation` (`cancellation_ID`),
  KEY `idx_refund_return` (`return_ID`),
  CONSTRAINT `fk_refunds_cancellation` FOREIGN KEY (`cancellation_ID`) REFERENCES `tb_cancellations` (`ID`),
  CONSTRAINT `fk_refunds_payment` FOREIGN KEY (`payment_ID`) REFERENCES `tb_payments` (`ID`),
  CONSTRAINT `fk_refunds_return` FOREIGN KEY (`return_ID`) REFERENCES `tb_returns` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tb_refunds_insert AFTER INSERT ON tb_refunds FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_refunds','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_refunds_update AFTER UPDATE ON tb_refunds FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_refunds','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tb_refunds_delete AFTER DELETE ON tb_refunds FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tb_refunds','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tb_refunds AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tb_refunds';

CREATE TABLE IF NOT EXISTS `tbd_return_items` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `return_ID` int unsigned NOT NULL,
  `order_item_ID` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `unit_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `item_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `item_condition` enum('Unknown','New','Opened','Damaged') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Unknown',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_return_items_return` (`return_ID`),
  KEY `idx_return_items_order_item` (`order_item_ID`),
  CONSTRAINT `fk_return_items_order_item` FOREIGN KEY (`order_item_ID`) REFERENCES `tbd_order_items` (`ID`),
  CONSTRAINT `fk_return_items_return` FOREIGN KEY (`return_ID`) REFERENCES `tb_returns` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TRIGGER IF NOT EXISTS audit_tbd_return_items_insert AFTER INSERT ON tbd_return_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_return_items','Create',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_return_items_update AFTER UPDATE ON tbd_return_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_return_items','Update',USER(),JSON_OBJECT('ID', NEW.`ID`));

CREATE TRIGGER IF NOT EXISTS audit_tbd_return_items_delete AFTER DELETE ON tbd_return_items FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description) VALUES ('tbd_return_items','Delete',USER(),JSON_OBJECT('ID', OLD.`ID`));

CREATE OR REPLACE SQL SECURITY INVOKER VIEW audit_tbd_return_items AS SELECT id,db_user,operation,description,operation_date,operation_status FROM tb_logs WHERE table_name='tbd_return_items';
