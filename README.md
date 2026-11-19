<p align="center"><strong>OPTATIVA I · LABORATORIO DE DATOS</strong></p>
<h1 align="center">Bases de Datos en la Nube</h1>
<p align="center">Jael Adrián González Cruz · 240784 · Grupo 7A</p>
<p align="center"><a href="Practica03/docs/diccionario.md">Diccionario MySQL</a> · <a href="Practica04/queries/verify_cases.sql">Evidencia de compras</a> · <a href="Unidad01/README.md">Infraestructura</a></p>

Ingeniería en Tecnologías de la Información e Innovación Digital
Docente: M.T.I. Marco A. Ramírez Hernández

## Tabla de prácticas

| Práctica | Enunciado | Evidencia en el proyecto |
|---|---|---|
| [Práctica 02 · Conexiones remotas para bases de datos SQL](Practica02/readme.md) | Configurar y comprobar usuarios, roles y privilegios en un servidor SQL. | Matriz de accesos, configuración y consultas de verificación. |
| [Práctica 03 · Manipulación de datos en conexiones remotas](Practica03/README.md) | Integrar relaciones, procedimientos, funciones y eventos en conexiones remotas. | 25 tablas, 72 triggers, 25 vistas y 7,500 cuentas vinculadas a sus perfiles. |
| [Práctica 04 · Simulación de compras y transacciones](Practica04/README.md) | Simular compras y comprobar pagos, devoluciones, cancelaciones, envíos y trazabilidad. | Cinco casos ejecutados con sus pedidos y consultas de auditoría. |

## Explorar el modelo

La [Práctica 03](Practica03/docs/) reúne el diccionario y seis mapas de Archify para identidad, catálogo, compra, pagos, entrega y posventa. El [índice HTML](Practica03/docs/index.html) es la entrada a los archivos estáticos. El [flujo de publicación](.github/workflows/pages.yml) despliega ese directorio desde `main` cuando GitHub Pages está habilitado con GitHub Actions. El plan actual del repositorio privado impide activar Pages.

## Reproducir el laboratorio

La [Unidad 1](Unidad01/README.md) contiene el Compose, el manual, las evidencias y los scripts iniciales. Las prácticas 03 y 04 documentan las migraciones y verificaciones que se aplicaron al esquema MySQL del VPS.
