---
description: Cambio pequeño (bug, ajuste de UI, config) sin el flujo completo. Una nota corta de qué/por qué/criterio y directo a implementar con test.
argument-hint: <qué hay que cambiar>
---

Flujo corto para cambios que caben en un commit o dos. Si al leer el pedido ves que toca más de tres archivos, modelo de datos o un contrato con otro servicio, **para y sugiere `/specify`**.

Pedido:
$ARGUMENTS

1. Escribe `specs/quick/<AAAA-MM-DD>-<slug>.md` (cinco líneas, no más): **Qué**, **Por qué**, **Criterio de aceptación** (un Given/When/Then), **Archivos que toca**, **Riesgo** (bajo/medio).
2. Rama según la convención del `CLAUDE.md`.
3. Test primero si el proyecto tiene runner y el cambio es lógica; si es puramente visual o de config, di por qué no hay test.
4. Implementa. Corre solo los tests afectados.
5. Diff por `code-reviewer` si el riesgo es medio; si es bajo, revisión propia de 5 líneas.
6. Commit con mensaje que referencie la nota. El push y el PR los decide el usuario (`gh pr create` si lo pide).

Cierra en español en 3 líneas. No abras `plan.md` ni `tasks.md`: para eso está el flujo completo.
