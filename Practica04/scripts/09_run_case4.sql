SET ROLE buyer;
START TRANSACTION;
CALL sp_practica04_case4('oficial-01');
COMMIT;
