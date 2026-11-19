USE db_test;
START TRANSACTION;
CALL sp_generate_practica03_users('test1',500,'M','US',18,80,100);
CALL sp_generate_practica03_users('test2',2000,NULL,NULL,19,35,100);
CALL sp_generate_practica03_users('test3',5000,NULL,NULL,18,80,80);
COMMIT;
