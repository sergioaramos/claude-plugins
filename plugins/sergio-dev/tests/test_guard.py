# Pruebas del guard. Requiere ~/.config/sergio-dev/trusted-hosts con "pc" y "pcl".
# Uso: python3 plugins/sergio-dev/tests/test_guard.py plugins/sergio-dev/scripts/guard-bash.sh

import json, subprocess, sys

G = sys.argv[1]
CASES = [
    (0, "ssh pcl 'sudo apt-get install -y zsh'"),
    (0, "ssh pc 'Restart-Computer -Force'"),
    (0, "scp archivo pc:C:/x"),
    (0, "base64 -i f | ssh pcl 'rm -rf ~/dotfiles && git clone x'"),
    (0, "ssh -o ConnectTimeout=5 sergio@pcl 'systemctl restart ssh'"),
    (2, "ssh yefacom-198 'sudo systemctl restart nginx'"),
    (2, "ssh chazki-ec2 'rm -rf /tmp/x'"),
    (2, "scp archivo yefacom-212:/var/www"),
    (2, "scp a pc:/x yefacom-212:/y"),
    (2, "ssh pcbad 'reboot'"),
    (2, "ssh -p 22 sergio@yefacom-198 'apt-get upgrade'"),
    (2, "git reset --hard HEAD"),
]
fail = 0
for want, cmd in CASES:
    r = subprocess.run(["bash", G], input=json.dumps({"tool_input": {"command": cmd}}), capture_output=True, text=True).returncode
    ok = r == want
    fail += not ok
    print(("OK  " if ok else "FAIL"), f"(esperado {want}, salió {r})", cmd)
sys.exit(1 if fail else 0)
