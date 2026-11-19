USE db_test;
DROP PROCEDURE IF EXISTS sp_generate_practica03_users;
DELIMITER $$
CREATE PROCEDURE sp_generate_practica03_users(
 IN p_batch VARCHAR(24), IN p_count INT, IN p_gender VARCHAR(16),
 IN p_country CHAR(2), IN p_min_age INT, IN p_max_age INT, IN p_active_percent INT
)
SQL SECURITY INVOKER
BEGIN
 DECLARE i INT DEFAULT 1;
 DECLARE uid BIGINT UNSIGNED;
 DECLARE alias_name VARCHAR(100);
 DECLARE country CHAR(2);
 DECLARE age_years INT;
 DECLARE is_active BIT(1);
 IF p_batch IS NULL OR NOT REGEXP_LIKE(p_batch,'^[a-z0-9-]{1,24}$','c')
    OR p_count IS NULL OR p_count NOT BETWEEN 1 AND 7500
    OR p_min_age IS NULL OR p_max_age IS NULL OR p_min_age NOT BETWEEN 18 AND 100
    OR p_max_age NOT BETWEEN p_min_age AND 100 OR p_active_percent IS NULL
    OR p_active_percent NOT BETWEEN 0 AND 100
    OR (p_country IS NOT NULL AND NOT REGEXP_LIKE(p_country,'^[A-Z]{2}$','c'))
    OR (p_gender IS NOT NULL AND p_gender NOT IN ('M','F')) THEN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Parámetros de generación inválidos';
 END IF;
 WHILE i <= p_count DO
  SET alias_name=CONCAT('p03-',p_batch,'-',LPAD(i,5,'0'));
  SET country=COALESCE(p_country,ELT(1+FLOOR(RAND()*5),'MX','US','CA','CO','AR'));
  SET age_years=p_min_age+FLOOR(RAND()*(p_max_age-p_min_age+1));
  SET is_active=RAND()*100<p_active_percent;
  INSERT INTO tb_users(email,nickname,status)
  VALUES(CONCAT(alias_name,'@example.invalid'),alias_name,is_active);
  SET uid=LAST_INSERT_ID();
  INSERT INTO tb_people(user_id,given_names,paternal_surname,birth_date,gender_code,country_code,status)
  VALUES(uid,IF(p_gender='M','Alex',IF(p_gender='F','Dana',ELT(1+FLOOR(RAND()*3),'Alex','Dana','Sam'))),
   ELT(1+FLOOR(RAND()*4),'Rivera','Morgan','Cruz','Lee'),
   DATE_SUB(CURRENT_DATE,INTERVAL age_years YEAR),
   COALESCE(p_gender,ELT(1+FLOOR(RAND()*2),'M','F')),country,is_active);
  SET i=i+1;
 END WHILE;
END$$
DELIMITER ;
