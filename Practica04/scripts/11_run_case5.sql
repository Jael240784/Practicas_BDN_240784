SET ROLE buyer;
START TRANSACTION;
CALL sp_practica04_case5('oficial-01');
COMMIT;
