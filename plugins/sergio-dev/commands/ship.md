---
description: Paso 5 de spec-driven. Verificación final, checklist de despliegue según el stack, PR y plan de rollback. Nunca despliega a producción sin confirmación.
argument-hint: [entorno destino, notas]
---

Prepara la **entrega** de la feature implementada. NO despliegues a producción sin confirmación explícita.

Contexto:
$ARGUMENTS

1. **Verificación final**: suite completa con `test-runner`; revisión con `code-reviewer` y, si aplica, `security-reviewer` o el revisor del workspace. Si algo está rojo, detente.
2. **Trazabilidad**: cada `AC-n` de `spec.md` tiene un test en verde. Lista los que no.
3. **Checklist por stack** (usa la sección de despliegue del `CLAUDE.md` del workspace; si no existe, propón una y sugiere añadirla):
   - migraciones aplicadas y reversibles; variables de entorno en el destino, no en el repo;
   - build limpio sin artefactos versionados (`dist/`, `node_modules/`);
   - contratos con otros servicios intactos;
   - si el proyecto va directo a prod sin CI, doble revisión y prueba en staging.
4. **PR**: rama y commits listos, descripción con qué / por qué / cómo se probó / enlace a la spec. Créalo con la CLI del proveedor (`gh pr create`, `az repos pr create`) tras verificar la autenticación. Si la CLI falla, deja las instrucciones y para. **El merge lo decide el usuario.**
5. **Rollback** en 3 líneas: revert del PR, down de la migración, redeploy anterior.
6. Anota al final de `tasks.md`: fecha, qué se entregó, pendientes.

Cierra en español, conciso. El siguiente paso es `/cerrar`.
