# Bases de Datos en la Nube

**Jael Adrián González Cruz · 240784 · Grupo 7A**

Ingeniería en Tecnologías de la Información e Innovación Digital

**Asignatura** Optativa I · Septiembre–diciembre de 2026

**Docente** M.T.I. Marco A. Ramírez Hernández

## Prácticas y entregables

| Práctica | Objetivo | Evidencia |
|---|---|---|
| [02 · Conexiones remotas](Practica02/readme.md) | Configurar cuentas, roles y permisos para conexiones SQL. | [Matriz de accesos](Practica02/readme.md#usuarios-remotos-y-roles) y [consultas de verificación](Practica02/queries/consultas_verificacion.sql). |
| [03 · Manipulación de datos](Practica03/README.md) | Ampliar el esquema de comercio con relaciones, procedimientos, eventos y datos de prueba. | [Diccionario MySQL](Practica03/docs/diccionario.md), [modelos EER](Practica03/docs/index.html) y [verificación de lotes](Practica03/queries/verify_user_batches.sql). |
| [04 · Simulación de compras](Practica04/README.md) | Ejecutar cinco casos de compra y comprobar pagos, incidencias y trazabilidad. | [Resultados por pedido](Practica04/README.md#resultados-comprobados) y [consultas de auditoría](Practica04/queries/verify_cases.sql). |

## Diccionario y modelo relacional

Consulta el [diccionario en Markdown](Practica03/docs/diccionario.md) desde GitHub. Para usar el visor interactivo, descarga el artefacto **diccionario-mysql** de la última ejecución exitosa de [GitHub Actions](../../actions/workflows/pages.yml), descomprímelo y abre `index.html`.

El repositorio es privado y GitHub Pages requiere un plan compatible. El flujo de publicación está preparado para activarse desde Actions cuando Pages esté habilitado.

## Infraestructura

La [Unidad 1](Unidad01/README.md) reúne el manual de instalación, Docker Compose, los scripts iniciales y las evidencias del laboratorio. Las prácticas 03 y 04 documentan el esquema MySQL del VPS.
