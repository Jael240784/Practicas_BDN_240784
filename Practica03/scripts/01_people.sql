USE db_test;
CREATE TABLE IF NOT EXISTS tb_people (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL UNIQUE,
  given_names VARCHAR(150) NOT NULL,
  paternal_surname VARCHAR(150) NULL,
  maternal_surname VARCHAR(150) NULL,
  birth_date DATE NULL,
  gender_code VARCHAR(16) NULL,
  country_code CHAR(2) NULL,
  status BIT(1) NOT NULL DEFAULT b'1',
  CONSTRAINT fk_tb_people_user FOREIGN KEY (user_id) REFERENCES tb_users(id),
  CONSTRAINT ck_tb_people_given_names CHECK (CHAR_LENGTH(TRIM(given_names)) > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TRIGGER IF NOT EXISTS trg_people_insert AFTER INSERT ON tb_people FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description)
  VALUES ('tb_people','Create',USER(),JSON_OBJECT('person_id',NEW.id,'user_id',NEW.user_id));
CREATE TRIGGER IF NOT EXISTS trg_people_update AFTER UPDATE ON tb_people FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description)
  VALUES ('tb_people','Update',USER(),JSON_OBJECT('person_id',NEW.id,'user_id',NEW.user_id,'status_before',OLD.status+0,'status_after',NEW.status+0));
CREATE TRIGGER IF NOT EXISTS trg_people_delete AFTER DELETE ON tb_people FOR EACH ROW
  INSERT INTO tb_logs(table_name,operation,db_user,description)
  VALUES ('tb_people','Delete',USER(),JSON_OBJECT('person_id',OLD.id,'user_id',OLD.user_id));
CREATE OR REPLACE SQL SECURITY INVOKER VIEW vw_trazabilidad_personas AS
  SELECT id,db_user,operation,description,operation_date,operation_status
  FROM tb_logs WHERE table_name='tb_people';
