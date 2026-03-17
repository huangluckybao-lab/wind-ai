#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="wind-ai"
RAW_BASE="https://raw.githubusercontent.com/huangluckybao-lab/wind-ai/master"
TARGET_DIR="${HOME}/.openclaw/workspace/skills/${SKILL_NAME}"

mkdir -p "${TARGET_DIR}"

curl -fsSL "${RAW_BASE}/SKILL.md" -o "${TARGET_DIR}/SKILL.md"

if curl -fsSL "${RAW_BASE}/call_wind.py" -o "${TARGET_DIR}/call_wind.py"; then
  chmod +x "${TARGET_DIR}/call_wind.py" || true
fi

if curl -fsSL "${RAW_BASE}/metadata.json" -o "${TARGET_DIR}/metadata.json"; then
  :
fi

echo "✅ Wind AI 安装完成: ${TARGET_DIR}"
echo "👉 请重启 Gateway: openclaw gateway restart"
