---
description: Cierra la sesión: actualiza el vault de contexto con decisiones y pendientes, deja el repo limpio y propone mejoras a CLAUDE.md, skills o agentes (retro).
argument-hint: [notas de cierre]
---

Vas a **cerrar la sesión de trabajo**. Notas del usuario:
$ARGUMENTS

1. **Resumen en 5 líneas**: qué se decidió, qué cambió de estado, qué quedó pendiente. Si solo se escribió código, dilo y salta al paso 4.
2. **Vault**: invoca al agente `vault-archivist` con ese resumen para que actualice el vault de contexto (por defecto `~/Documents/Contexto`).
3. **Verifica** que en el vault no haya entrado nada técnico (rutas, comandos) ni credenciales: eso va al `CLAUDE.md` del workspace o a ningún sitio.
4. **Repo limpio**: `git status`. Si hay cambios sin commitear, dilo; no commitees sin confirmación.
5. **Retro (la parte que hace que el sistema mejore)**: responde en 3 puntos como máximo:
   - ¿Qué instrucción faltó o estorbó en el `CLAUDE.md` del workspace o del repo? Propón el diff exacto.
   - ¿Algún comando, skill o agente falló o se quedó corto? Propón el cambio concreto (archivo y líneas).
   - ¿Hubo algo que se repitió a mano dos veces y merece un script, skill o hook?
   Solo propone; el usuario aprueba y entonces aplicas. Si no hay nada, di "sin retro" y no inventes.
6. Lo que bloquee la próxima sesión va al inbox del vault con fecha.
