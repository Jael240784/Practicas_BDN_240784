# Práctica 02 · Conexiones remotas a bases de datos relacionales

## Descripción

Configura las cuentas, roles y privilegios de la base de datos del proyecto. La matriz de cuentas aparece en esta guía para que las demás prácticas puedan enlazarla.

## Usuarios remotos y roles

| Cuenta | Rol |
|---|---|
| `adrian.gonzalez` | `super_admin` |
| `marco.ramirez` | `admin` |
| `luis.david` | `support` |
| `bryan.javier` | `saler` |
| `ivan.ojeda` | `saler` |
| `ivan.macin` | `unregistered` |

`AppWeb` usa `user_not_registered` y `buyer` para los flujos de la Práctica 04. Las cuentas de los motores y las de los paneles web se administran por separado.

## Estructura y verificación

| Carpeta | Contenido |
|---|---|
| [scripts](scripts/) | Configuración de cuentas y privilegios |
| [queries](queries/) | Consultas de verificación |
| [backups](backups/) | Respaldos históricos |
| [seeds](seeds/) | Lote de productos de prueba |

Consulta el [Compose y las evidencias del VPS](../README.md#infraestructura-y-evidencias) para identificar el destino de la conexión.
