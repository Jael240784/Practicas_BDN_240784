USE db_test;
CREATE EVENT IF NOT EXISTS ev_p03_inventory_summary
 ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP + INTERVAL 3 SECOND
 ENABLE
 DO INSERT INTO tb_logs(table_name,operation,db_user,description)
 SELECT 'tb_products','Read',CURRENT_USER(),
        JSON_OBJECT('event','ev_p03_inventory_summary','active',COUNT(*),
                    'out_of_stock',COALESCE(SUM(stock<=0),0))
 FROM tb_products WHERE status=1;
