#!/usr/bin/env bash
# PreToolUse(Bash): bloquea (exit 2) comandos que no deben correr sin una decisión humana.
# No sustituye los permisos de Claude Code: es una segunda barrera, pensada para modo auto/bypass.
set -u
input="$(cat)"
cmd="$(printf '%s' "$input" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null || true)"
[ -z "$cmd" ] && exit 0
block() { echo "⛔ sergio-dev guard: $1" >&2; echo "   comando: $cmd" >&2; exit 2; }
# rm -rf fuera de rutas de trabajo
if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])rm[[:space:]]+(-[a-zA-Z]*r[a-zA-Z]*f|-[a-zA-Z]*f[a-zA-Z]*r)[[:space:]]'; then
  if printf '%s' "$cmd" | grep -Eq 'rm[[:space:]]+-[a-zA-Z]+[[:space:]]+("?~"?/?|/|\$HOME/?|\*)([[:space:]]|$|")'; then block "rm -rf sobre la home, la raíz o un comodín suelto"; fi
fi
# git destructivo
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+push[[:space:]].*(--force|-f)([[:space:]]|$)' && printf '%s' "$cmd" | grep -Eq '(main|master|production|prod)([[:space:]]|$|:)' && block "force push a una rama protegida"
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+(reset[[:space:]]+--hard|clean[[:space:]]+-[a-zA-Z]*f|branch[[:space:]]+-D[[:space:]])' && block "git destructivo (reset --hard / clean -f / branch -D): pide confirmación"
# infra
printf '%s' "$cmd" | grep -Eq '(^|[[:space:]])terraform[[:space:]]+(apply|destroy)' && block "terraform apply/destroy: se ejecuta con el usuario presente"
printf '%s' "$cmd" | grep -Eq 'docker[[:space:]]+(system[[:space:]]+prune[[:space:]]+.*-a|volume[[:space:]]+rm|volume[[:space:]]+prune)' && block "docker prune/volume rm: puede borrar datos de BD locales"
# bases de datos
printf '%s' "$cmd" | grep -Eiq '(^|[[:space:]"'"'"'])(drop[[:space:]]+(database|table|schema)|truncate[[:space:]]+table)' && block "DROP/TRUNCATE"
# servidores remotos: nada destructivo vía ssh
if printf '%s' "$cmd" | grep -Eq '(^|[[:space:]])ssh[[:space:]]'; then
  printf '%s' "$cmd" | grep -Eiq '(rm[[:space:]]+-|systemctl[[:space:]]+(restart|stop|disable)|service[[:space:]]+[a-z-]+[[:space:]]+(restart|stop)|reboot|shutdown|plesk[[:space:]]+bin|mysql.*-e.*(drop|truncate|delete|update|alter)|docker[[:space:]]+(rm|stop|down|kill)|>[[:space:]]*/)' && block "operación de escritura o reinicio en un servidor remoto: hazla tú o confírmala explícitamente"
fi
exit 0
