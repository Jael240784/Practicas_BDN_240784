SET ROLE buyer;
START TRANSACTION;
CALL sp_practica04_case3('oficial-02');
COMMIT;
