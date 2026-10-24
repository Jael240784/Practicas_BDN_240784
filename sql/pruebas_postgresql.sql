-- Diez operaciones de demostracion, reversibles, para un db_test con el esquema de postgresql.sql.
-- Ejecutar con una cuenta autorizada. Estos ejemplos no sustituyen casos oficiales que entregue el docente.
BEGIN;
SELECT usuario,rol FROM public.usuarios ORDER BY usuario; -- 01
INSERT INTO public.tb_users(email,nick,password) VALUES
 ('prueba.usuario@cityreport.local','prueba.usuario','demo-temporal-no-login'); -- 02
INSERT INTO public.usuarios(usuario,rol) VALUES ('prueba.usuario','common')
ON CONFLICT(usuario) DO UPDATE SET rol=EXCLUDED.rol;
UPDATE public.usuarios SET rol='support' WHERE usuario='prueba.usuario'; -- 03
SELECT nick,email,inserted_by,roles,operation_description,operation_date
FROM public.vw_trazabilidad_usuarios WHERE nick='prueba.usuario'; -- 04
DELETE FROM public.tb_users WHERE nick='prueba.usuario';
DELETE FROM public.usuarios WHERE usuario='prueba.usuario'; -- 05
SELECT id,sku,name,current_price,current_stock FROM public.tb_products ORDER BY id; -- 06
INSERT INTO public.tb_products(sku,name,description,current_price,current_stock)
VALUES ('TEMP-240784-001','Producto temporal SQL','Prueba reversible',99.99,2); -- 07
UPDATE public.tb_products SET current_price=109.99 WHERE sku='TEMP-240784-001'; -- 08
SELECT id,name,inserted_by,roles,operation_description,operation_date
FROM public.vw_trazabilidad_productos WHERE name='Producto temporal SQL'; -- 09
DELETE FROM public.tb_products WHERE sku='TEMP-240784-001'; -- 10
SELECT id,table_name,table_operation,db_user,operation_description,operation_date
FROM public.tb_logs ORDER BY id DESC LIMIT 20;
ROLLBACK;
