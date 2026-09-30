# sergio-dev

Plugin de Claude Code con mi flujo de trabajo **spec-driven en español**, revisores genéricos que corren en modelos económicos, y dos hooks de seguridad.

## Instalar
```bash
claude plugin marketplace add sergioaramos/claude-plugins
claude plugin install sergio-dev@sergio-plugins
```

## El flujo
| Comando | Qué hace | Produce |
|---|---|---|
| `/sergio-dev:specify` | QUÉ y POR QUÉ: requisitos EARS estrictos, criterios en Gherkin (`# language: es`), NFR medibles, matriz FR → AC y autoverificación. Termina con preguntas de clarificación numeradas. | `specs/NNN-slug/spec.md` |
| `/sergio-dev:plan` | CÓMO: mini-ADRs, arquitectura, pruebas, riesgos. Termina con la tabla de consistencia spec ↔ plan. | `plan.md` |
| `/sergio-dev:tasks` | Tareas pequeñas y verificables; el test de cada bloque va primero (TDD embebido). | `tasks.md` |
| `/sergio-dev:implement` | Una tarea por invocación (`--all` para un bloque). Rojo → verde → refactor. | código + tests |
| `/sergio-dev:ship` | Suite completa, revisión, checklist por stack, PR con la CLI, rollback. | PR |
| `/sergio-dev:cerrar` | Vault de contexto al día + retro: qué mejorar en CLAUDE.md, skills o agentes. | notas + propuestas |
| `/sergio-dev:quick` | Cambios pequeños sin plan ni tasks: una nota de 5 líneas y a implementar con test. | `specs/quick/…` |
| `/sergio-dev:db-change` | Migración leyendo el esquema real. MariaDB/MySQL y PostgreSQL, multi-tenant. | `up`/`down` + doc |
| `/sergio-dev:repaso` | Repaso semanal del vault Obsidian. | reporte |

Por qué así y no como Spec Kit o BMAD: mismo número de pasos que mi flujo anterior pero sin los dos que duplicaban lecturas (`clarify` vive en `specify`, `analyze` en `plan`, `tests-first` en `tasks`). `/quick` existe porque un hotfix no debería pagar el flujo completo.

## Agentes
`code-reviewer`, `security-reviewer`, `test-runner`, `db-migration-safety`, `vault-archivist` (Sonnet) y `doc-writer` (Haiku). Cada uno con alcance acotado al diff o módulo indicado: no exploran el repo entero.

## Hooks
- `PreToolUse(Bash)` bloquea: `rm -rf` sobre home/raíz, force push a ramas protegidas, `git reset --hard`, `terraform apply/destroy`, `docker prune/volume rm`, `DROP/TRUNCATE`, y escrituras o reinicios vía `ssh`. Es una segunda barrera además de los permisos normales.
- `PostToolUse(Edit|Write)` pasa `gitleaks` sobre el archivo escrito y avisa si parece haber un secreto.

## Convenciones que asume
- Un `CLAUDE.md` por workspace con stack, ramas y despliegue.
- Specs en `specs/` dentro del repo.
- Un vault de contexto en Markdown para lo que no cabe en un repo (por defecto `~/Documents/Contexto`).

MIT.
