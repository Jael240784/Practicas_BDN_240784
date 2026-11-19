-- Práctica 04. Ejecutar en db_test con una cuenta que pueda ver todos sus triggers.
-- Esperado: 25 tablas del modelo, 24 tríos completos y 72 triggers en el esquema.
USE db_test;

SELECT COUNT(*) AS triggers_en_db_test
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = DATABASE();

SELECT t.TABLE_NAME,
       COUNT(g.TRIGGER_NAME) AS triggers,
       COUNT(CASE WHEN g.ACTION_TIMING = 'AFTER' AND g.EVENT_MANIPULATION = 'INSERT' THEN 1 END) AS after_insert,
       COUNT(CASE WHEN g.ACTION_TIMING = 'AFTER' AND g.EVENT_MANIPULATION = 'UPDATE' THEN 1 END) AS after_update,
       COUNT(CASE WHEN g.ACTION_TIMING = 'AFTER' AND g.EVENT_MANIPULATION = 'DELETE' THEN 1 END) AS after_delete
FROM information_schema.TABLES AS t
LEFT JOIN information_schema.TRIGGERS AS g
       ON g.EVENT_OBJECT_SCHEMA = t.TABLE_SCHEMA
      AND g.EVENT_OBJECT_TABLE = t.TABLE_NAME
WHERE t.TABLE_SCHEMA = DATABASE()
  AND t.TABLE_TYPE = 'BASE TABLE'
  AND REGEXP_LIKE(t.TABLE_NAME, '^tb[cd]?_')
GROUP BY t.TABLE_NAME
ORDER BY t.TABLE_NAME;
