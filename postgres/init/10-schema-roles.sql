Y™Áäx±º±◊úï™ﬁw≠Ö '≤€¨zW≠~äÎy´,ä	⁄nWØj∏önW¨Y™Áäx}º±◊úï™ﬁw≠Ö '≤€¨zW≠~äÎy´,ä	⁄nWØj∏önW¨-- Plantilla p√∫blica. Sustituye los marcadores antes de ejecutar. No contiene contrase√±as reales.
\connect db_test
CREATE TABLE IF NOT EXISTS public.tb_users (
  id BIGSERIAL PRIMARY KEY, email VARCHAR(160) NOT NULL UNIQUE, nickname VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL DEFAULT 'demo-hash-not-for-login', rol VARCHAR(32) NOT NULL DEFAULT 'unregistered',
  created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS public.tb_products (
  id BIGSERIAL PRIMARY KEY, name VARCHAR(140) NOT NULL, description TEXT, price NUMERIC(10,2) NOT NULL CHECK(price>=0),
  stock INTEGER NOT NULL DEFAULT 0 CHECK(stock>=0), seller_nickname VARCHAR(100) NOT NULL, created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS public.tbc_categories (id BIGSERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL UNIQUE);
CREATE TABLE IF NOT EXISTS public.tbd_products_categories (
  product_id BIGINT NOT NULL REFERENCES public.tb_products(id) ON DELETE CASCADE,
  category_id BIGINT NOT NULL REFERENCES public.tbc_categories(id) ON DELETE CASCADE,
  PRIMARY KEY(product_id,category_id)
);
CREATE TABLE IF NOT EXISTS public.tb_logs (
  id BIGSERIAL PRIMARY KEY, table_name VARCHAR(64) NOT NULL, operation VARCHAR(10) NOT NULL CHECK(operation IN ('Create','Read','Update','Delete')),
  db_user VARCHAR(100) NOT NULL, description TEXT NOT NULL, operation_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  operation_status BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE INDEX IF NOT EXISTS idx_tb_logs_date ON public.tb_logs(operation_date);
CREATE TABLE IF NOT EXISTS public.usuarios (usuario VARCHAR(64) PRIMARY KEY, rol VARCHAR(32) NOT NULL);
INSERT INTO public.usuarios(usuario,rol) VALUES ('adrian.gonzalez','super_admin') ON CONFLICT(usuario) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.tb_users(email,nickname,password_hash,rol) VALUES ('adrian.gonzalez@cityreport.local','adrian.gonzalez','demo-hash-not-for-login','super_admin') ON CONFLICT(nickname) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.usuarios(usuario,rol) VALUES ('marco.ramirez','admin') ON CONFLICT(usuario) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.tb_users(email,nickname,password_hash,rol) VALUES ('marco.ramirez@cityreport.local','marco.ramirez','demo-hash-not-for-login','admin') ON CONFLICT(nickname) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.usuarios(usuario,rol) VALUES ('luis.david','support') ON CONFLICT(usuario) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.tb_users(email,nickname,password_hash,rol) VALUES ('luis.david@cityreport.local','luis.david','demo-hash-not-for-login','support') ON CONFLICT(nickname) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.usuarios(usuario,rol) VALUES ('bryan.javier','saler') ON CONFLICT(usuario) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.tb_users(email,nickname,password_hash,rol) VALUES ('bryan.javier@cityreport.local','bryan.javier','demo-hash-not-for-login','saler') ON CONFLICT(nickname) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.usuarios(usuario,rol) VALUES ('ivan.ojeda','saler') ON CONFLICT(usuario) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.tb_users(email,nickname,password_hash,rol) VALUES ('ivan.ojeda@cityreport.local','ivan.ojeda','demo-hash-not-for-login','saler') ON CONFLICT(nickname) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.usuarios(usuario,rol) VALUES ('ivan.macin','unregistered') ON CONFLICT(usuario) DO UPDATE SET rol=EXCLUDED.rol;
INSERT INTO public.tb_users(email,nickname,password_hash,rol) VALUES ('ivan.macin@cityreport.local','ivan.macin','demo-hash-not-for-login','unregistered') ON CONFLICT(nickname) DO UPDATE SET rol=EXCLUDED.rol;

INSERT INTO public.tbc_categories(name) VALUES ('Accesorios'),('Ropa') ON CONFLICT(name) DO NOTHING;
INSERT INTO public.tb_products(name,description,price,stock,seller_nickname) VALUES
('Producto de demostraci√≥n','Registro de ejemplo para validar la conexi√≥n',199.90,10,'bryan.javier'),
('Producto de prueba','Registro de ejemplo para validar consultas',249.00,5,'ivan.ojeda');
CREATE OR REPLACE FUNCTION public.trg_log_row() RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path=pg_catalog,public AS $$
DECLARE op text; rowid text; rowname text;
BEGIN
  op := CASE WHEN TG_OP='INSERT' THEN 'Create' WHEN TG_OP='UPDATE' THEN 'Update' ELSE 'Delete' END;
  IF TG_TABLE_NAME='tb_users' THEN
    rowid := CASE WHEN TG_OP='DELETE' THEN OLD.id::text ELSE NEW.id::text END;
    rowname := CASE WHEN TG_OP='DELETE' THEN OLD.nickname ELSE NEW.nickname END;
  ELSE
    rowid := CASE WHEN TG_OP='DELETE' THEN OLD.id::text ELSE NEW.id::text END;
    rowname := CASE WHEN TG_OP='DELETE' THEN OLD.name ELSE NEW.name END;
  END IF;
  INSERT INTO public.tb_logs(table_name,operation,db_user,description)
  VALUES(TG_TABLE_NAME,op,session_user,format('%s en %s id=%s nombre=%s',op,TG_TABLE_NAME,rowid,rowname));
  IF TG_OP='DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
END; $$;
DROP TRIGGER IF EXISTS trg_users_log ON public.tb_users;
CREATE TRIGGER trg_users_log AFTER INSERT OR UPDATE OR DELETE ON public.tb_users FOR EACH ROW EXECUTE FUNCTION public.trg_log_row();
DROP TRIGGER IF EXISTS trg_products_log ON public.tb_products;
CREATE TRIGGER trg_products_log AFTER INSERT OR UPDATE OR DELETE ON public.tb_products FOR EACH ROW EXECUTE FUNCTION public.trg_log_row();
CREATE OR REPLACE VIEW public.vw_trazabilidad_usuarios AS
  SELECT id,table_name,operation,db_user,description,operation_date,operation_status FROM public.tb_logs WHERE table_name='tb_users';
CREATE OR REPLACE VIEW public.vw_trazabilidad_productos AS
  SELECT id,table_name,operation,db_user,description,operation_date,operation_status FROM public.tb_logs WHERE table_name='tb_products';
DO $$ BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='superadmin') THEN CREATE ROLE superadmin NOLOGIN; END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='admin') THEN CREATE ROLE admin NOLOGIN; END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='seller') THEN CREATE ROLE seller NOLOGIN; END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='buyer') THEN CREATE ROLE buyer NOLOGIN; END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='support') THEN CREATE ROLE support NOLOGIN; END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='common') THEN CREATE ROLE common NOLOGIN; END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='not_registered') THEN CREATE ROLE not_registered NOLOGIN; END IF;
END $$;

GRANT CONNECT ON DATABASE db_test TO superadmin,admin,seller,buyer,support,common,not_registered;
GRANT USAGE ON SCHEMA public TO superadmin,admin,seller,buyer,support,common,not_registered;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO superadmin,admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO superadmin,admin;
GRANT SELECT,INSERT,UPDATE ON public.tb_users TO support;
GRANT SELECT,UPDATE ON public.tb_products TO support;
GRANT SELECT ON public.tbc_categories,public.vw_trazabilidad_usuarios,public.vw_trazabilidad_productos TO support;
GRANT SELECT,INSERT,UPDATE ON public.tb_products TO seller;
GRANT SELECT ON public.tbc_categories,public.tb_products TO buyer,common;
DO $$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='adrian.gonzalez') THEN CREATE ROLE "adrian.gonzalez" LOGIN PASSWORD 'CAMBIAR_PASSWORD_ADRIAN_GONZALEZ' ; ELSE ALTER ROLE "adrian.gonzalez" WITH LOGIN PASSWORD 'CAMBIAR_PASSWORD_ADRIAN_GONZALEZ'; END IF; END $$;
GRANT superadmin TO "adrian.gonzalez";
ALTER ROLE "adrian.gonzalez" SET role TO 'superadmin';
DO $$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='marco.ramirez') THEN CREATE ROLE "marco.ramirez" LOGIN PASSWORD 'CAMBIAR_PASSWORD_MARCO_RAMIREZ' ; ELSE ALTER ROLE "marco.ramirez" WITH LOGIN PASSWORD 'CAMBIAR_PASSWORD_MARCO_RAMIREZ'; END IF; END $$;
GRANT admin TO "marco.ramirez";
ALTER ROLE "marco.ramirez" SET role TO 'admin';
DO $$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='luis.david') THEN CREATE ROLE "luis.david" LOGIN PASSWORD 'CAMBIAR_PASSWORD_LUIS_DAVID' ; ELSE ALTER ROLE "luis.david" WITH LOGIN PASSWORD 'CAMBIAR_PASSWORD_LUIS_DAVID'; END IF; END $$;
GRANT support TO "luis.david";
ALTER ROLE "luis.david" SET role TO 'support';
DO $$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='bryan.javier') THEN CREATE ROLE "bryan.javier" LOGIN PASSWORD 'CAMBIAR_PASSWORD_BRYAN_JAVIER' ; ELSE ALTER ROLE "bryan.javier" WITH LOGIN PASSWORD 'CAMBIAR_PASSWORD_BRYAN_JAVIER'; END IF; END $$;
GRANT seller TO "bryan.javier";
ALTER ROLE "bryan.javier" SET role TO 'seller';
DO $$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='ivan.ojeda') THEN CREATE ROLE "ivan.ojeda" LOGIN PASSWORD 'CAMBIAR_PASSWORD_IVAN_OJEDA' ; ELSE ALTER ROLE "ivan.ojeda" WITH LOGIN PASSWORD 'CAMBIAR_PASSWORD_IVAN_OJEDA'; END IF; END $$;
GRANT seller TO "ivan.ojeda";
ALTER ROLE "ivan.ojeda" SET role TO 'seller';
DO $$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='ivan.macin') THEN CREATE ROLE "ivan.macin" LOGIN PASSWORD 'CAMBIAR_PASSWORD_IVAN_MACIN' ; ELSE ALTER ROLE "ivan.macin" WITH LOGIN PASSWORD 'CAMBIAR_PASSWORD_IVAN_MACIN'; END IF; END $$;
GRANT not_registered TO "ivan.macin";
ALTER ROLE "ivan.macin" SET role TO 'not_registered';
GRANT SELECT ON public.usuarios TO superadmin,admin,support,seller,buyer,common;

