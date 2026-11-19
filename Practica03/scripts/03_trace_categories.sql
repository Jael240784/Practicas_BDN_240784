USE db_test;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW vw_trazabilidad_productos_categorias AS
 SELECT id,db_user,operation,description,operation_date,operation_status
 FROM tb_logs WHERE table_name='tbd_products_categories';

CREATE TRIGGER IF NOT EXISTS audit_tbc_categories_insert AFTER INSERT ON tbc_categories FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description)
  VALUES ('tbc_categories','Create',USER(),JSON_OBJECT('id', NEW.id));

CREATE TRIGGER IF NOT EXISTS audit_tbc_categories_update AFTER UPDATE ON tbc_categories FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description)
  VALUES ('tbc_categories','Update',USER(),JSON_OBJECT('id', NEW.id));

CREATE TRIGGER IF NOT EXISTS audit_tbc_categories_delete AFTER DELETE ON tbc_categories FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description)
  VALUES ('tbc_categories','Delete',USER(),JSON_OBJECT('id', OLD.id));

CREATE TRIGGER IF NOT EXISTS audit_tbd_products_categories_insert AFTER INSERT ON tbd_products_categories FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description)
  VALUES ('tbd_products_categories','Create',USER(),JSON_OBJECT('product_id', NEW.product_id, 'category_id', NEW.category_id));

CREATE TRIGGER IF NOT EXISTS audit_tbd_products_categories_update AFTER UPDATE ON tbd_products_categories FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description)
  VALUES ('tbd_products_categories','Update',USER(),JSON_OBJECT('product_id', NEW.product_id, 'category_id', NEW.category_id));

CREATE TRIGGER IF NOT EXISTS audit_tbd_products_categories_delete AFTER DELETE ON tbd_products_categories FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description)
  VALUES ('tbd_products_categories','Delete',USER(),JSON_OBJECT('product_id', OLD.product_id, 'category_id', OLD.category_id));
