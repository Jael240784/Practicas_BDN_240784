-- Importa el CSV de Practica02/seeds/tb_products_5000.csv en db_test.
-- Copiar previamente el archivo al contenedor PostgreSQL como /tmp/tb_products_5000.csv.
-- La carga es transaccional e idempotente por ID; todos los registros se asignan a Bryan.
-- Ejecutar como jael_admin: psql -v ON_ERROR_STOP=1 -U jael_admin -d db_test -f importar_productos_5000_postgresql.sql

BEGIN;

ALTER TABLE public.tb_products ADD COLUMN IF NOT EXISTS sku VARCHAR(80);
ALTER TABLE public.tb_products ADD COLUMN IF NOT EXISTS status BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE public.tb_products ADD COLUMN IF NOT EXISTS last_update TIMESTAMPTZ;
CREATE UNIQUE INDEX IF NOT EXISTS uq_tb_products_sku ON public.tb_products(sku) WHERE sku IS NOT NULL;

CREATE TEMP TABLE import_products (
  id BIGINT NOT NULL,
  sku VARCHAR(80) NOT NULL,
  name VARCHAR(140) NOT NULL,
  description TEXT NOT NULL,
  current_price NUMERIC(10,2) NOT NULL,
  current_stock INTEGER NOT NULL,
  status SMALLINT NOT NULL,
  creation_date TEXT NOT NULL,
  last_update TEXT NOT NULL
) ON COMMIT DROP;

COPY import_products FROM '/tmp/tb_products_5000.csv'
  WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

DO $$
BEGIN
  IF (SELECT COUNT(*) FROM import_products) <> 5000 THEN
    RAISE EXCEPTION 'Se esperaban exactamente 5000 filas en el CSV';
  END IF;
  IF EXISTS (SELECT 1 FROM import_products GROUP BY id HAVING COUNT(*) > 1)
     OR EXISTS (SELECT 1 FROM import_products GROUP BY sku HAVING COUNT(*) > 1) THEN
    RAISE EXCEPTION 'El CSV contiene IDs o SKU duplicados';
  END IF;
  IF EXISTS (SELECT 1 FROM import_products WHERE status NOT IN (0,1)) THEN
    RAISE EXCEPTION 'El CSV contiene valores de status distintos de 0 o 1';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM import_products s
    JOIN public.tb_products p USING (id)
    WHERE p.sku IS DISTINCT FROM s.sku
       OR p.name IS DISTINCT FROM s.name
       OR p.description IS DISTINCT FROM s.description
       OR p.price IS DISTINCT FROM s.current_price
       OR p.stock IS DISTINCT FROM s.current_stock
       OR p.seller_nickname IS DISTINCT FROM 'bryan.javier'
       OR p.status IS DISTINCT FROM (s.status = 1)
       OR p.created_at IS DISTINCT FROM to_timestamp(s.creation_date,'DD/MM/YYYY HH24:MI')
       OR p.last_update IS DISTINCT FROM to_timestamp(s.last_update,'DD/MM/YYYY HH24:MI')
  ) THEN
    RAISE EXCEPTION 'Hay IDs existentes con datos diferentes; se cancela para evitar sobrescribirlos';
  END IF;
END $$;

INSERT INTO public.tb_products
  (id,sku,name,description,price,stock,seller_nickname,created_at,status,last_update)
SELECT id,sku,name,description,current_price,current_stock,'bryan.javier',
       to_timestamp(creation_date,'DD/MM/YYYY HH24:MI'), status = 1,
       to_timestamp(last_update,'DD/MM/YYYY HH24:MI')
FROM import_products
ON CONFLICT (id) DO NOTHING;

SELECT setval(pg_get_serial_sequence('public.tb_products','id'),
              (SELECT MAX(id) FROM public.tb_products), true);

DO $$
BEGIN
  IF (SELECT COUNT(*) FROM public.tb_products
      WHERE id BETWEEN 8 AND 5007 AND seller_nickname='bryan.javier') <> 5000 THEN
    RAISE EXCEPTION 'La verificación final no encontró los 5000 productos de Bryan';
  END IF;
END $$;

COMMIT;

SELECT COUNT(*) AS productos_bryan_lote
FROM public.tb_products
WHERE id BETWEEN 8 AND 5007 AND seller_nickname='bryan.javier';
SELECT seller_nickname, COUNT(*) AS productos
FROM public.tb_products
GROUP BY seller_nickname
ORDER BY seller_nickname;
