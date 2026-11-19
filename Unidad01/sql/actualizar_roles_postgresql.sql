-- Roles de compatibilidad con la lista de cotejo; se mantienen las etiquetas originales de Jael.
DO $$ DECLARE r text; BEGIN
 FOREACH r IN ARRAY ARRAY['superadmin','seller','buyer','common','not_registered'] LOOP
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname=r) THEN EXECUTE format('CREATE ROLE %I NOLOGIN',r); END IF;
 END LOOP;
END $$;
CREATE OR REPLACE VIEW public.vw_total_products_by_category AS
 SELECT c.id AS category_id,c.name AS category_name,COUNT(pc.product_id)::bigint AS product_count
 FROM public.tbc_categories AS c LEFT JOIN public.tbd_products_categories AS pc ON pc.category_id=c.id
 GROUP BY c.id,c.name;
GRANT CONNECT ON DATABASE db_test TO superadmin,seller,buyer,common,not_registered;
GRANT USAGE ON SCHEMA public TO superadmin,seller,buyer,common,not_registered;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO superadmin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO superadmin;
GRANT SELECT,INSERT,UPDATE ON public.tb_products TO seller;
GRANT USAGE,SELECT ON ALL SEQUENCES IN SCHEMA public TO seller;
GRANT SELECT ON public.tbc_categories TO seller,buyer,common;
GRANT SELECT ON public.tb_products,public.vw_total_products_by_category TO buyer,common;
GRANT SELECT ON public.vw_total_products_by_category TO seller;
GRANT SELECT ON public.usuarios TO superadmin,seller,buyer,common;
GRANT superadmin TO "adrian.gonzalez";
GRANT seller TO "bryan.javier","ivan.ojeda";
GRANT not_registered TO "ivan.macin";
