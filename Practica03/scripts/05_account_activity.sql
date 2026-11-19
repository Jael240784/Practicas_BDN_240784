USE db_test;
SET @p03_status_ddl = IF(
 EXISTS(SELECT 1 FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='tb_users' AND COLUMN_NAME='status'),
 'DO 0', 'ALTER TABLE tb_users ADD COLUMN status BIT(1) NOT NULL DEFAULT b''1'''
);
PREPARE p03_status_stmt FROM @p03_status_ddl;
EXECUTE p03_status_stmt;
DEALLOCATE PREPARE p03_status_stmt;
