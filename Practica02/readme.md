# Práctica 02 · Conexiones remotas a bases de datos relacionales

[Inicio del repositorio](../README.md) / **Conexiones remotas**

> **Entrega** · Matriz de roles, scripts de acceso, consultas de comprobación y respaldos SQL.

**En esta guía** · [Roles y cuentas](#usuarios-remotos-y-roles) · [Cómo verificar](#cómo-verificar-el-acceso) · [Evidencia](#evidencia-para-la-entrega)

---

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

Consulta el [Compose y las evidencias del VPS](../Unidad01/README.md) para identificar el destino de la conexión.

## Cómo verificar el acceso

1. Identifica la instancia y el motor en la [guía de infraestructura](../Unidad01/README.md).
2. Revisa el [script de usuarios y privilegios](scripts/remote_users_privileges_creation.sql) con una cuenta administradora.
3. Abre una conexión remota con la cuenta asignada y ejecuta las [consultas de verificación](queries/consultas_verificacion.sql). Contrasta la cuenta, los roles y los permisos con la matriz anterior.
4. Consulta los [respaldos](backups/) para revisar el esquema histórico y el [lote de productos](seeds/) para localizar el archivo de prueba.

## Evidencia para la entrega

Registra el motor y la cuenta de conexión, el rol efectivo y las consultas de verificación ejecutadas. Para reconstruir el entorno desde cero, consulta la [Unidad 1](../Unidad01/README.md). Para rastrear operaciones hechas como comprador, usa la [ruta de auditoría de compras](../Practica04/README.md#ruta-de-auditoría).

[Regresar a la portada](../README.md)
