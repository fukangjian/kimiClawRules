#!/usr/bin/env bash
set -euo pipefail
cd /root/.openclaw/workspace
mkdir -p exports/rules
cp MEMORY.md exports/rules/MEMORY.full.md
python3 - <<'PY'
from pathlib import Path
import json, hashlib, datetime
text=Path('MEMORY.md').read_text()
Path('exports/rules/RULES_EXPORT.md').write_text('# OpenClaw Rules Export\n\n---\n\n'+text)
files=[]
for p in [Path('exports/rules/RULES_EXPORT.md'), Path('exports/rules/MEMORY.full.md')]:
    b=p.read_bytes(); files.append({'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()})
Path('exports/rules/manifest.json').write_text(json.dumps({'updated_at':datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=8))).isoformat(),'source':'MEMORY.md','files':files},ensure_ascii=False,indent=2))
PY
# 把当天 memory 也纳入迁移包清单；不复制大文件，避免膨胀。
python3 - <<'PY'
from pathlib import Path
import json
mp=Path('memory')
entries=[]
for p in sorted(mp.glob('2026-*.md'))[-30:]:
    entries.append(str(p))
manifest=Path('exports/rules/manifest.json')
data=json.loads(manifest.read_text())
data['recent_memory_files']=entries
manifest.write_text(json.dumps(data,ensure_ascii=False,indent=2))
PY

# 若迁移包有变化，提交一次；无变化不制造空提交。
if ! git diff --quiet -- exports/rules scripts/backup_rules.sh; then
  git add exports/rules scripts/backup_rules.sh || true
  git commit -m "备份规则迁移包" || true
fi
