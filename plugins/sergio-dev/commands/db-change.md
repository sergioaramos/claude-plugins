---
description: Propone una migración de base de datos leyendo primero el esquema real. MariaDB/MySQL y PostgreSQL. Reversible, documentada y revisada por db-migration-safety.
argument-hint: <cambio solicitado>
---

Vas a proponer un cambio de base de datos **leyendo primero el esquema real**. No inventes estructura.

Cambio solicitado:
$ARGUMENTS

## 1. Esquema real
Busca el snapshot del esquema donde diga el `CLAUDE.md` (`db/schema.sql`, `migraciones/`, `esquema/`, `specs/<feature>/schema.sql`). Si no existe, detente y pide al usuario que lo genere:
- PostgreSQL: `pg_dump --schema-only "$DATABASE_URL" > db/schema.sql`
- MariaDB/MySQL: `mysqldump --no-data --routines --triggers -h HOST -u USER -p BD > db/schema.sql`
Identifica tablas, columnas, tipos, PK/FK, índices, convenciones de nombres y de timestamps, soft-delete, multi-tenant (columna de tenant, prefijos de BD por cliente).

## 2. Propuesta
Respeta las convenciones del esquema. Columnas nuevas en tablas con datos: `NULL` o `DEFAULT`. Señala qué código consume esas tablas.
Motor:
- **MariaDB/MySQL**: `ALTER TABLE … ALGORITHM=INPLACE, LOCK=NONE` cuando el motor lo permita; para tablas grandes, `pt-online-schema-change` o ventana de mantenimiento. Cuidado con `utf8mb4` y collations mezcladas.
- **PostgreSQL**: `CREATE INDEX CONCURRENTLY`, `ADD COLUMN` sin default volátil, `NOT VALID` + `VALIDATE CONSTRAINT` para FKs en caliente.
- **Multi-tenant por BD** (una BD por cliente): la migración debe ser idempotente y ejecutable en bucle sobre todas las BDs; incluye el script del bucle.

## 3. Migración up y down
Usa la herramienta de migraciones del proyecto; si no hay, SQL plano versionado en `migraciones/<NNN>-<slug>.up.sql` y `.down.sql`.

## 4. Documentación
`db/cambios/<NNN>-<slug>.md`: qué y por qué (enlace a la spec), DDL up/down, impacto, riesgos, rollback, query de verificación.

## 5. Revisión obligatoria
Pasa la migración por el agente `db-migration-safety`. Para DROP, columnas eliminadas o cambios de tipo con pérdida: backup verificado y **confirmación explícita** antes de ejecutar nada. Nunca ejecutes contra una BD sin confirmación.
