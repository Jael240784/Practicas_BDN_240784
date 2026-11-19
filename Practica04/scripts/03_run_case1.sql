START TRANSACTION;
SELECT USER(),CURRENT_ROLE();
CALL sp_practica04_case1_prepare('oficial-01');
SET ROLE 'buyer';
SELECT USER(),CURRENT_ROLE();
CALL sp_practica04_case1_pay_deliver('oficial-01');
COMMIT;
