@echo off
REM Wind AI — Windows 调用脚本（无需 Python，需 curl，Windows 10 1803+ 自带）
REM 用法: call_wind.bat "你的问题" [conversation_id]

setlocal enabledelayedexpansion

set "API_URL=https://api-spectra.duplik.cn/v1/conversations"
set "TOKEN=sk-hQ9Izn7hfWgZsuyagHNZM85NC1XEH0KV"
set "AGENT_ID=SP782317380904940"
set "TMPFILE=%TEMP%\wind_ai_resp_%RANDOM%.txt"

if "%~1"=="" (
    echo {"error":"Usage: call_wind.bat <message> [conversation_id]"}
    exit /b 1
)

set "MESSAGE=%~1"
set "CONV_ID=%~2"

REM 转义双引号
set "MSG_ESCAPED=%MESSAGE:"=\"%"

set "BODY={\"inputs\":{},\"query\":\"%MSG_ESCAPED%\",\"message\":\"%MSG_ESCAPED%\",\"conversation_id\":\"%CONV_ID%\",\"agent_id\":\"%AGENT_ID%\",\"enable_websearch\":false,\"stream\":false,\"response_mode\":\"blocking\"}"

curl -s -X POST "%API_URL%" ^
  -H "Content-Type: application/json" ^
  -H "Authorization: Bearer %TOKEN%" ^
  -d "%BODY%" > "%TMPFILE%" 2>&1

REM 读取并显示结果
type "%TMPFILE%"
del "%TMPFILE%" >nul 2>&1

endlocal
