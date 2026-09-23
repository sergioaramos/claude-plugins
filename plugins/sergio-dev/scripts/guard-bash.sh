#!/usr/bin/env bash
# PreToolUse(Bash): bloquea (exit 2) comandos que no deben correr sin una decisión humana.
# No sustituye los permisos de Claude Code: es una segunda barrera, pensada para modo auto/bypass.
# Toda la inspección la hace Python para poder distinguir la parte LOCAL de la parte REMOTA (ssh).
set -u
input="$(cat)"
python3 - "$input" <<'PY'
import json, re, sys, shlex

try:
    cmd = json.loads(sys.argv[1]).get("tool_input", {}).get("command", "") or ""
except Exception:
    sys.exit(0)
if not cmd.strip():
    sys.exit(0)

def block(reason):
    sys.stderr.write(f"⛔ sergio-dev guard: {reason}\n   comando: {cmd[:300]}\n")
    sys.exit(2)

# ── 1. Separar segmentos locales de comandos remotos (ssh <host> <cmd>) ──
# Cada segmento = trozo entre operadores de shell. Si empieza por ssh, extraemos su comando remoto.
segments = re.split(r"\s*(?:&&|\|\||;|\||\n)\s*", cmd)
local, remote = [], []
SSH_WITH_ARG = {"-i","-p","-o","-l","-F","-J","-L","-R","-D","-W","-E","-b","-c","-e","-m","-O","-Q","-S","-w","-B","-I","-P"}
for seg in segments:
    seg = seg.strip()
    if not seg:
        continue
    try:
        toks = shlex.split(seg)
    except ValueError:
        toks = seg.split()
    if toks and toks[0] in ("ssh", "scp") or (len(toks) > 1 and toks[0] in ("sudo", "time") and toks[1] == "ssh"):
        if toks[0] != "ssh":
            toks = toks[1:] if toks[0] in ("sudo", "time") else toks
        if toks[0] == "scp":
            remote.append("scp " + " ".join(toks[1:]))
            continue
        i = 1
        while i < len(toks) and toks[i].startswith("-"):
            i += 2 if toks[i] in SSH_WITH_ARG else 1
        # toks[i] es el host; el resto es el comando remoto
        remote.append(" ".join(toks[i+1:]))
    else:
        local.append(seg)

L = "\n".join(local)
R = "\n".join(remote)

# ── 2. Reglas sobre la parte LOCAL ──
if re.search(r"(^|\s)rm\s+-[a-zA-Z]*[rR][a-zA-Z]*\s", L) or re.search(r"(^|\s)rm\s+-[a-zA-Z]*f[a-zA-Z]*r", L):
    if re.search(r"rm\s+-[a-zA-Z]+\s+(\"?~\"?/?|/|\$HOME/?|\*)(\s|$|\")", L):
        block("rm -rf sobre la home, la raíz o un comodín suelto")
if re.search(r"git\s+push\s.*(--force|\s-f)(\s|$)", L) and re.search(r"(main|master|production|prod)(\s|$|:)", L):
    block("force push a una rama protegida")
if re.search(r"git\s+(reset\s+--hard|clean\s+-[a-zA-Z]*f|branch\s+-D\s)", L):
    block("git destructivo (reset --hard / clean -f / branch -D): pide confirmación")
if re.search(r"(^|\s)terraform\s+(apply|destroy)", L):
    block("terraform apply/destroy: se ejecuta con el usuario presente")
if re.search(r"docker\s+(system\s+prune\s+.*-a|volume\s+rm|volume\s+prune)", L):
    block("docker prune/volume rm: puede borrar datos de BD locales")
if re.search(r"(^|[\s\"'])(drop\s+(database|table|schema)|truncate\s+table)", L, re.I):
    block("DROP/TRUNCATE")

# ── 3. Reglas sobre la parte REMOTA (solo el comando que corre en el servidor) ──
if R:
    if re.search(r"(^|[\s;&|])(rm\s+-|mv\s|chmod\s|chown\s|systemctl\s+(restart|stop|disable|enable)|service\s+[\w-]+\s+(restart|stop)|reboot|shutdown|plesk\s+bin\s+\w+\s+--(update|create|remove|delete)|docker\s+(rm|stop|down|kill|restart)|docker\s+compose\s+(up|down|restart)|apt(-get)?\s+(install|remove|upgrade)|>\s*/|tee\s+/)", R, re.I):
        block("operación de escritura o reinicio en un servidor remoto: hazla tú o confírmala explícitamente")
    if re.search(r"mysql.*-e.*(drop|truncate|delete\s+from|update\s|alter\s|insert\s)", R, re.I):
        block("escritura en BD remota vía ssh")
    if re.search(r"^scp\s.*\s\S+@?[\w.-]+:\S*", R) and not re.search(r"^scp\s+\S+:\S*\s", R):
        block("scp hacia un servidor remoto: confirma qué archivo va a producción")

sys.exit(0)
PY
