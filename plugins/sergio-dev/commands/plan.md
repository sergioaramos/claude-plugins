---
description: Paso 2 de spec-driven. Convierte la spec aprobada en el plan técnico (CÓMO) y cierra con la tabla de consistencia spec ↔ plan.
argument-hint: [ruta a la spec o notas adicionales]
---

Lee `specs/<NNN>-<slug>/spec.md` (la más reciente o la que indique el usuario) y produce el **plan técnico**. No escribas código de producción.

Contexto del usuario:
$ARGUMENTS

Reglas:
1. Si la spec tiene `[NECESITA ACLARACIÓN]` sin resolver, detente y pídelas.
2. Respeta el `CLAUDE.md` del proyecto (stack, convenciones, gotchas). Lee solo los archivos que el cambio toca; nombra los que vas a modificar.
3. Toda decisión con alternativas reales lleva un mini-ADR: opción elegida, descartadas, por qué, consecuencias.

Escribe `specs/<NNN>-<slug>/plan.md`:
- **Decisiones técnicas** (mini-ADRs).
- **Arquitectura del cambio**: componentes, flujo de datos, contratos/APIs afectados y quién los consume.
- **Modelo de datos / migraciones** si aplica. Si hay DDL, marca si es destructivo: eso pasa por `/db-change` y el agente `db-migration-safety`.
- **Cambios por archivo/módulo** (alto nivel).
- **Estrategia de pruebas**: qué se prueba, con qué runner, y qué casos borde.
- **Riesgos y mitigaciones**. **Rollback**.

## Análisis de consistencia (obligatorio, cierra el plan)
Tabla `requisito → decisión del plan → prueba prevista` con TODOS los `FR-n`, `NFR-n` y `AC-n` de la spec. Cualquier fila vacía es un hueco: o lo resuelves en el plan o lo devuelves a la spec como pregunta. Sin esta tabla el plan no está terminado.

Cierra con un resumen en español de 5 líneas y di que el siguiente paso es `/tasks`.
