---
description: Paso 4 de spec-driven. Implementa la siguiente tarea de tasks.md (una por invocación), con su test en verde. Usa --all para encadenar.
argument-hint: [Tn | --all | notas]
---

Implementa tareas de `specs/<NNN>-<slug>/tasks.md`.

Argumentos:
$ARGUMENTS

## Alcance por invocación
- Sin argumentos: **solo la primera tarea sin marcar**. Al terminarla, marca `- [x]`, reporta en 3 líneas y para. Esto mantiene el contexto corto y la cuota bajo control.
- `Tn`: esa tarea.
- `--all`: encadena tareas hasta terminar el bloque actual o hasta un fallo. Nunca más de un bloque por invocación.

## Reglas
1. Trabaja en una rama (`feature/<id>-<slug>` o la convención del CLAUDE.md). Nunca push directo a main/master/production.
2. Ciclo TDD: el test de la tarea en rojo → implementación mínima → verde → refactor. Corre solo los tests de la tarea, no la suite entera (eso es del último bloque).
3. Respeta spec, plan y `CLAUDE.md`. Si lo que hay que hacer se desvía de la spec, **detente y avisa**; si la spec estaba equivocada, se corrige la spec primero.
4. Sin secretos en código: variables de entorno.
5. Lee solo los archivos que la tarea toca. No "entiendas el repo" antes de empezar.
6. Al cerrar un bloque lógico: `test-runner` para la suite del módulo y `code-reviewer` (o el revisor específico del workspace) sobre el diff.

Cuando todas las tareas estén marcadas y la suite en verde, el siguiente paso es `/ship`.
