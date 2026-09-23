#!/usr/bin/env bash
# PostToolUse(Edit|Write): si gitleaks está instalado, escanea el archivo recién escrito y avisa (no bloquea).
set -u
command -v gitleaks >/dev/null 2>&1 || exit 0
f="$(cat | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d.get("tool_input",{}).get("file_path",""))' 2>/dev/null || true)"
[ -z "$f" ] || [ ! -f "$f" ] && exit 0
case "$f" in *.env|*.env.*|*credenciales*|*secret*) ;; esac
out="$(gitleaks detect --no-git --source "$f" --redact --no-banner --exit-code 3 2>/dev/null)"; rc=$?
if [ "$rc" -eq 3 ]; then
  echo "⚠️ sergio-dev: gitleaks detectó un posible secreto en $f. Muévelo a una variable de entorno antes de commitear." >&2
  exit 2
fi
exit 0
