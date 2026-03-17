$ErrorActionPreference = 'Stop'

$skillName = 'wind-ai'
$rawBase = 'https://raw.githubusercontent.com/huangluckybao-lab/wind-ai/master'
$targetDir = Join-Path $env:USERPROFILE ".openclaw\workspace\skills\$skillName"

New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

Invoke-WebRequest -Uri "$rawBase/SKILL.md" -OutFile (Join-Path $targetDir 'SKILL.md')

try {
  Invoke-WebRequest -Uri "$rawBase/call_wind.py" -OutFile (Join-Path $targetDir 'call_wind.py')
} catch {
  Write-Host "ℹ️ call_wind.py 下载失败，可稍后手动下载。"
}

try {
  Invoke-WebRequest -Uri "$rawBase/metadata.json" -OutFile (Join-Path $targetDir 'metadata.json')
} catch {
  Write-Host "ℹ️ metadata.json 下载失败，可忽略。"
}

Write-Host "✅ Wind AI 安装完成: $targetDir"
Write-Host "👉 请重启 Gateway: openclaw gateway restart"
