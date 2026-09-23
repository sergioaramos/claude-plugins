---
description: Repaso semanal del vault de contexto (Obsidian): vacía el inbox, detecta notas obsoletas, pendientes viejos y enlaces rotos, y comprueba coherencia con los CLAUDE.md de los workspaces.
argument-hint: [ruta del vault, por defecto ~/Documents/Contexto]
---

Repaso semanal del vault de contexto. No cambies nada sin explicar por qué.

Vault: $ARGUMENTS (por defecto `~/Documents/Contexto`; lee primero su `CLAUDE.md`).

1. **Inbox**: cada línea de `30-inbox/inbox.md` va a la nota que le corresponde o se propone dónde. Borra del inbox lo reubicado. Las preguntas abiertas para el usuario se agrupan al final.
2. **Estados**: notas de clientes, proyectos y áreas con más de 30 días sin `actualizado:` y estado activo → preguntar si siguen vivas o van a `90-archivo/`.
3. **Pendientes**: `- [ ]` abiertos agrupados por nota; señala los que llevan más de un mes sin moverse.
4. **Higiene**: enlaces `[[rotos]]`, notas sin frontmatter, notas huérfanas.
5. **Coherencia entre capas**: lo que dicen los `CLAUDE.md` de los workspaces (`~/Documents/*/CLAUDE.md`) sigue siendo cierto según el vault. Si un cliente cambió de estado y su `CLAUDE.md` no lo refleja, dilo.
6. **Reporte** en este orden y en máximo 15 líneas: qué moviste, qué necesita decisión, qué está podrido.

No hagas commit: el plugin git del vault se encarga.
