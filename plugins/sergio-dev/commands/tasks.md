---
description: Paso 3 de spec-driven. Descompone el plan en tareas pequeñas y verificables, con los tests como primeras tareas de cada bloque (TDD embebido).
argument-hint: [notas]
---

Lee `specs/<NNN>-<slug>/plan.md` y `spec.md` y genera `specs/<NNN>-<slug>/tasks.md`.

Contexto del usuario:
$ARGUMENTS

Reglas:
1. Tareas **pequeñas** (menos de un commit cada una), ordenadas por dependencia. Marca `[P]` las que pueden ir en paralelo.
2. Cada tarea es verificable: `- [ ] Tn: <acción> — _Hecha cuando: <criterio>_ (ref: FR-x / AC-y)`.
3. **TDD embebido**: cada bloque funcional empieza con la tarea de escribir su test (mapeado a un `AC-n`) y termina con la de ponerlo en verde. No hay paso aparte de "tests primero": está aquí.
4. Bloques típicos: **Datos → Backend → Frontend → Integración → Verificación → Entrega**. Adáptalos al stack; omite los que no apliquen.
5. Último bloque siempre: suite completa (agente `test-runner`), revisión (agente `code-reviewer` o el específico del workspace) y `/ship`.
6. Trazabilidad: todo `AC-n` de la spec debe aparecer en al menos una tarea. Si alguno no aparece, es un hueco: repórtalo.

Tracker (opcional): si el proyecto usa issues o un board (según el CLAUDE.md), muestra exactamente qué crearías y **pide confirmación** antes de escribir nada. Si el usuario dice no, `tasks.md` es el seguimiento.

Cierra en español: número de tareas, bloques, y que el siguiente paso es `/implement`.
