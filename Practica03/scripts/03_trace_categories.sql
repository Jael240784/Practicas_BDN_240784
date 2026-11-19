USE db_test;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW vw_trazabilidad_productos_categorias AS
 SELECT id,db_user,operation,description,operation_date,operation_status
 FROM tb_logs WHERE table_name='tbd_products_categories';
