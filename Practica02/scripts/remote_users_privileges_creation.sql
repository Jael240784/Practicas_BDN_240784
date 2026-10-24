-- Practica 2: usuarios y roles de Jael240784.
-- Requiere MySQL 8, la base y las tablas originales ya creadas.
-- Sustituye las contrasenas de ejemplo antes de ejecutar.
USE `db_test`;

CREATE USER IF NOT EXISTS 'adrian.gonzalez'@'%' IDENTIFIED BY 'Cambiar_240784_adrian!';
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'Cambiar_240784_marco!';
CREATE USER IF NOT EXISTS 'luis.david'@'%' IDENTIFIED BY 'Cambiar_240784_luis!';
CREATE USER IF NOT EXISTS 'bryan.javier'@'%' IDENTIFIED BY 'Cambiar_240784_bryan!';
CREATE USER IF NOT EXISTS 'ivan.ojeda'@'%' IDENTIFIED BY 'Cambiar_240784_ivan!';
CREATE USER IF NOT EXISTS 'ivan.macin'@'%' IDENTIFIED BY 'Cambiar_240784_ivan!';

CREATE ROLE IF NOT EXISTS 'super_admin', 'admin', 'support', 'saler', 'unregistered';
GRANT ALL PRIVILEGES ON *.* TO 'super_admin';
GRANT ALL PRIVILEGES ON `db_test`.* TO 'admin';
GRANT SELECT, INSERT, UPDATE ON `db_test`.tb_users TO 'support';
GRANT SELECT, UPDATE ON `db_test`.tb_products TO 'support';
GRANT SELECT, INSERT, UPDATE ON `db_test`.tb_products TO 'saler';

-- El rol unregistered no recibe privilegios sobre los datos.
GRANT 'super_admin' TO 'adrian.gonzalez'@'%';
SET DEFAULT ROLE 'super_admin' TO 'adrian.gonzalez'@'%';
GRANT 'admin' TO 'marco.ramirez'@'%';
SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';
GRANT 'support' TO 'luis.david'@'%';
SET DEFAULT ROLE 'support' TO 'luis.david'@'%';
GRANT 'saler' TO 'bryan.javier'@'%';
SET DEFAULT ROLE 'saler' TO 'bryan.javier'@'%';
GRANT 'saler' TO 'ivan.ojeda'@'%';
SET DEFAULT ROLE 'saler' TO 'ivan.ojeda'@'%';
GRANT 'unregistered' TO 'ivan.macin'@'%';
SET DEFAULT ROLE 'unregistered' TO 'ivan.macin'@'%';

-- Registro de usuarios y roles de la aplicacion.
CREATE TABLE IF NOT EXISTS usuarios (usuario VARCHAR(64) NOT NULL PRIMARY KEY, rol VARCHAR(32) NOT NULL);
INSERT INTO usuarios (usuario, rol) VALUES ('adrian.gonzalez', 'super_admin') ON DUPLICATE KEY UPDATE rol = 'super_admin';
INSERT INTO usuarios (usuario, rol) VALUES ('marco.ramirez', 'admin') ON DUPLICATE KEY UPDATE rol = 'admin';
INSERT INTO usuarios (usuario, rol) VALUES ('luis.david', 'support') ON DUPLICATE KEY UPDATE rol = 'support';
INSERT INTO usuarios (usuario, rol) VALUES ('bryan.javier', 'saler') ON DUPLICATE KEY UPDATE rol = 'saler';
INSERT INTO usuarios (usuario, rol) VALUES ('ivan.ojeda', 'saler') ON DUPLICATE KEY UPDATE rol = 'saler';
INSERT INTO usuarios (usuario, rol) VALUES ('ivan.macin', 'unregistered') ON DUPLICATE KEY UPDATE rol = 'unregistered';

SELECT usuario, rol FROM usuarios ORDER BY usuario;
