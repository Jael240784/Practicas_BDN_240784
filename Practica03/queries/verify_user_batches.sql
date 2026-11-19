USE db_test;
SELECT SUBSTRING_INDEX(u.nickname,'-',2) AS lote,
       COUNT(*) AS cuentas, COUNT(p.id) AS perfiles,
       SUM(u.status+0) AS cuentas_activas,
       SUM(u.status<>p.status) AS estados_distintos,
       SUM(p.status+0) AS perfiles_activos,
       SUM(1-p.status) AS perfiles_inactivos,
       MIN(TIMESTAMPDIFF(YEAR,p.birth_date,CURRENT_DATE)) AS edad_minima,
       MAX(TIMESTAMPDIFF(YEAR,p.birth_date,CURRENT_DATE)) AS edad_maxima,
       GROUP_CONCAT(DISTINCT p.country_code ORDER BY p.country_code) AS paises,
       GROUP_CONCAT(DISTINCT p.gender_code ORDER BY p.gender_code) AS generos
FROM tb_users u LEFT JOIN tb_people p ON p.user_id=u.id
WHERE REGEXP_LIKE(u.nickname,'^p03-test[123]-[0-9]{5}$','c')
GROUP BY lote;
SELECT db_user,COUNT(*) AS altas_de_personas
FROM tb_logs
WHERE table_name='tb_people' AND operation='Create'
GROUP BY db_user;
