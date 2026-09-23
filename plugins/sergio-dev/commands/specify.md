---
description: Paso 1 de spec-driven. Crea la especificación (QUÉ y POR QUÉ) en EARS y cierra con las preguntas de clarificación. No escribe código.
argument-hint: <idea, feature o referencia a issue/ticket>
---

Vas a crear una **especificación**. NO escribas código ni hables de stack, archivos o librerías: eso es del `/plan`.

Idea / feature / referencia del usuario:
$ARGUMENTS

## 0. Contexto mínimo
- Lee el `CLAUDE.md` del proyecto (ya está cargado). No explores el repo entero: solo lo que la feature toca.
- Si el usuario cita un issue o ticket (`#123`, `AB#123`), léelo con la herramienta que indique el CLAUDE.md (gh CLI, MCP) y úsalo como base. Anota la referencia en la cabecera de la spec.
- Si `specs/` ya tiene una spec del mismo tema, extiéndela en vez de crear otra.

## 1. Escribe `specs/<NNN>-<slug>/spec.md`
`NNN` = siguiente número libre en `specs/`. Estructura:
- **Cabecera**: fecha, estado (`borrador`), issue/ticket si hay.
- **Resumen** (1-2 frases) y **Por qué** (problema, valor, para quién).
- **Actores**.
- **Requisitos funcionales** en **EARS**, numerados `FR-n`:
  - Ubicuo: "El sistema DEBE …" · Evento: "CUANDO …, el sistema DEBE …" · Estado: "MIENTRAS …, el sistema DEBE …" · Condicional: "SI …, ENTONCES el sistema DEBE …" · Opcional: "DONDE …, el sistema DEBE …".
- **Requisitos no funcionales** (`NFR-n`): rendimiento, seguridad, accesibilidad, solo los que apliquen.
- **Criterios de aceptación** en Gherkin (`AC-n`: Given/When/Then), verificables. Cada FR debe tener al menos un AC.
- **Fuera de alcance**.
- **Preguntas abiertas**: ver paso 2.

## 2. Clarificación (obligatoria)
Toda suposición se marca en el texto como `[NECESITA ACLARACIÓN: …]`. Al final de la spec, lista esas preguntas **numeradas** con tu respuesta propuesta por defecto para cada una. Hazlas al usuario en el chat. La spec no pasa a `aprobada` hasta que estén respondidas; cuando el usuario responda, edita la spec, quita las marcas y cambia el estado.

## 3. Cierre
Resume en español en 5 líneas y di que el siguiente paso es `/plan`. Si la feature es pequeña (un archivo, un bug, un ajuste de UI), sugiere `/quick` en vez de seguir el flujo completo.
