---
description: Paso 1 de spec-driven. Crea la especificación (QUÉ y POR QUÉ) con requisitos EARS, criterios en Gherkin y matriz de trazabilidad; cierra con las preguntas de clarificación. No escribe código.
argument-hint: <idea, feature o referencia a issue/ticket>
---

Vas a crear una **especificación**. NO escribas código ni hables de stack, archivos o librerías: eso es del `/plan`.

Idea / feature / referencia del usuario:
$ARGUMENTS

## 0. Contexto mínimo
- Lee el `CLAUDE.md` del proyecto (ya está cargado). No explores el repo entero: solo lo que la feature toca.
- Si el usuario cita un issue o ticket (`#123`, `AB#123`), léelo con la herramienta que indique el CLAUDE.md (gh CLI, MCP) y úsalo como base. Anota la referencia en la cabecera de la spec.
- Si el usuario pasa archivos (enunciado, levantamiento, notas), léelos completos: son la fuente.
- Si `specs/` ya tiene una spec del mismo tema, extiéndela en vez de crear otra.

## 1. Escribe `specs/<NNN>-<slug>/spec.md`
`NNN` = siguiente número libre en `specs/`. Secciones, en este orden:
1. **Cabecera:** fecha, estado (`borrador`) e issue o ticket si hay.
2. **Resumen** (1-2 frases) y **Por qué** (problema, valor, para quién).
3. **Actores** (incluye sistemas externos y procesos automáticos si los hay).
4. **Glosario:** estados, tipos y términos del dominio que los requisitos usan. Un término, un significado.
5. **Requisitos funcionales** (`FR-n`) en EARS. Ver §2.
6. **Requisitos no funcionales** (`NFR-n`) en tabla. Ver §3.
7. **Criterios de aceptación** (`AC-n`) en Gherkin. Ver §4.
8. **Matriz de trazabilidad.** Ver §5.
9. **Fuera de alcance.**
10. **Preguntas abiertas.** Ver §6.

## 2. Requisitos funcionales en EARS (estricto)
Cada `FR-n` usa **exactamente uno** de estos patrones:

| Patrón | Plantilla | Úsalo para |
|---|---|---|
| Ubicuo | El sistema DEBE <respuesta>. | Lo que se cumple siempre |
| Por evento | CUANDO <disparador>, el sistema DEBE <respuesta>. | Una reacción a algo que ocurre |
| Por estado | MIENTRAS <estado>, el sistema DEBE <respuesta>. | Lo que aplica mientras se da una condición que dura |
| No deseado | SI <condición no deseada>, ENTONCES el sistema DEBE <respuesta>. | Errores, validaciones fallidas, conflictos |
| Opcional | DONDE <la funcionalidad X esté incluida>, el sistema DEBE <respuesta>. | **Solo** funcionalidades configurables o de una variante del producto. Nunca para estados |
| Complejo | MIENTRAS <estado>, CUANDO <disparador>, el sistema DEBE <respuesta>. | Un disparador que solo aplica en cierto estado |

Reglas, todas obligatorias:
- **Una afirmación por requisito:** un solo "DEBE" y una sola respuesta. Si aparece "y además", "también" o un segundo "DEBE", pártelo en dos FR.
- **En positivo:** nada de "NO DEBE" ni "NUNCA DEBE". Reformula lo prohibido como la respuesta del sistema ("DEBE rechazar…", "DEBE permitir … únicamente a …").
- **Verificable:** sin palabras vagas ("rápido", "fácil", "adecuado", "amigable", "etc.", "y/o"). Cifras y límites explícitos, con sus bordes (¿"entre 5 y 17" incluye el 17?).
- **Sujeto:** siempre "el sistema". El actor humano va en el disparador o la condición.
- **Sin solución técnica:** el requisito dice qué pasa, no cómo se implementa.
- **Suposiciones marcadas:** toda decisión que no venga de la fuente lleva `[NECESITA ACLARACIÓN: Qn]`.
- Numeración correlativa y sin huecos, agrupada por bloques funcionales con subtítulo.

Ejemplos:
- ❌ "El sistema DEBE pasarla a PREAPROBADA. El analista NO DEBE poder aprobar directamente." (dos afirmaciones, una en negativo)
- ✅ FR-a: "CUANDO el analista apruebe un COMPUTADOR, el sistema DEBE pasarlo a PREAPROBADA."
- ✅ FR-b: "El sistema DEBE reservar a los coordinadores la aprobación final de los computadores."
- ❌ "DONDE la solicitud esté RADICADA, el sistema DEBE permitir desistir." (DONDE no es para estados)
- ✅ "MIENTRAS una solicitud esté RADICADA, el sistema DEBE permitir al afiliado desistir de ella."

## 3. Requisitos no funcionales
Tabla con tres columnas: `ID | Requisito (medible) | Cómo se verifica`. Solo los que apliquen: rendimiento, capacidad, disponibilidad, costo, seguridad, privacidad, accesibilidad, observabilidad, mantenibilidad.
- Cada NFR lleva una **métrica o un umbral** (p95 < 2 s, 1.500 por hora, WCAG 2.1 AA) y un **método de verificación** (prueba de carga, revisión, auditoría, demostración).
- Las propiedades de arquitectura (desacople, extensibilidad) van aquí, **no** como escenarios Gherkin: no son comportamiento observable por un usuario.

## 4. Criterios de aceptación en Gherkin
- En bloques ` ```gherkin `, con `# language: es` en la primera línea de cada bloque. Palabras clave: `Característica`, `Antecedentes`, `Escenario`, `Esquema del escenario`, `Ejemplos`, `Dado`, `Cuando`, `Entonces`, `Y`, `Pero`.
- Una `Característica` por bloque funcional (el mismo agrupamiento que los FR).
- **Un escenario = un comportamiento.** Exactamente **un** `Cuando` por escenario. Si necesitas "Y cuando… entonces…", son dos escenarios.
- `Dado` pone el contexto, `Cuando` es la única acción o evento, y `Entonces` es un **resultado observable** (estado, mensaje, correo recibido, dato visible). Nada de estados internos invisibles.
- **Declarativo, no guion de interfaz:** "Cuando radica un KIT_ESCOLAR", no "Cuando hace clic en el botón azul".
- **Datos concretos:** fechas reales, cantidades y mensajes exactos. Para los días hábiles, usa fechas de calendario y festivos reales.
- **Límites y variantes con `Esquema del escenario` + `Ejemplos`:** valores justo dentro y justo fuera de cada borde (4, 5, 17, 18), tipos de error y roles.
- Precondiciones comunes de una característica van en `Antecedentes`.
- Concurrencia, cuando el dominio la tiene (dos usuarios sobre el mismo recurso, cupos, unicidad): un escenario explícito con "en el mismo instante".
- Autorización: al menos un escenario en el que la operación prohibida se invoca **directamente en el servidor, sin la interfaz**.
- **Etiquetas:** cada escenario lleva `@AC-n` (correlativo, único) y los `@FR-n` / `@NFR-n` que verifica.

## 5. Matriz de trazabilidad
Tabla `FR → AC`. Reglas:
- Todo `FR-n` tiene al menos un `AC-n` que **realmente lo prueba**; no basta con mencionarlo.
- Todo `AC-n` referencia al menos un `FR-n` o `NFR-n`.
- Todo `NFR-n` tiene su método de verificación en la tabla de NFR.
- Cierra la matriz con una línea de cobertura: `N de N FR cubiertos · N de N NFR con verificación`.

## 6. Clarificación (obligatoria)
Toda suposición se marca en el texto como `[NECESITA ACLARACIÓN: Qn]`. Al final de la spec, lista esas preguntas **numeradas** (`Q1…Qn`), cada una con tu respuesta propuesta por defecto. Hazlas al usuario en el chat, en tabla. La spec no pasa a `aprobada` hasta que estén respondidas; cuando el usuario responda, edita la spec, quita las marcas, ajusta los FR y AC afectados y cambia el estado.

## 7. Autoverificación (antes de cerrar)
Revisa y corrige lo que falle; no entregues la spec con fallas conocidas:
- [ ] Cada FR empieza con uno de los patrones de §2, tiene un solo "DEBE" y no contiene "NO DEBE" ni "NUNCA".
- [ ] Ningún DONDE describe un estado.
- [ ] Cada escenario tiene exactamente un `Cuando` y un `Entonces` observable.
- [ ] Los límites numéricos tienen ejemplos dentro y fuera del borde.
- [ ] La matriz no tiene FR sin escenario ni escenarios sin FR/NFR; la numeración de FR y AC es correlativa y sin duplicados.
- [ ] Todos los NFR son medibles y tienen verificación.

Si hay shell disponible, comprueba los puntos mecánicos con un script (conteo de "DEBE" por FR, `Cuando` por escenario, cobertura de etiquetas) en vez de revisarlos a ojo.

## 8. Cierre
Resume en español en 5 líneas: qué es, conteo de FR/NFR/AC, lo técnicamente difícil y el resultado de la autoverificación. Luego di que el siguiente paso es `/plan`. Si la feature es pequeña (un archivo, un bug, un ajuste de UI), sugiere `/quick` en vez de seguir el flujo completo.
