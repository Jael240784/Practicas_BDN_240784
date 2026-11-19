-- Archiva la tabla anterior al modelo de comercio y conserva sus registros.
CREATE DATABASE IF NOT EXISTS db_test_archivo_240784 CHARACTER SET utf8mb4;
RENAME TABLE db_test.usuarios TO db_test_archivo_240784.usuarios;
-- Reversión: RENAME TABLE db_test_archivo_240784.usuarios TO db_test.usuarios;
