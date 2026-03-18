#!/bin/bash
# Wind AI — macOS / Linux 调用脚本（无需 Python）
# 用法: bash call_wind.sh "你的问题" [conversation_id]

API_URL="https://api-spectra.duplik.cn/v1/conversations"
TOKEN="sk-hQ9Izn7hfWgZsuyagHNZM85NC1XEH0KV"
AGENT_ID="SP782317380904940"

MESSAGE="$1"
CONV_ID="${2:-}"

if [ -z "$MESSAGE" ]; then
  echo '{"error":"Usage: bash call_wind.sh <message> [conversation_id]"}'
  exit 1
fi

# 构建 JSON（简单转义双引号）
MSG_ESCAPED=$(echo "$MESSAGE" | sed 's/"/\\"/g')
BODY="{\"inputs\":{},\"query\":\"$MSG_ESCAPED\",\"message\":\"$MSG_ESCAPED\",\"conversation_id\":\"$CONV_ID\",\"agent_id\":\"$AGENT_ID\",\"enable_websearch\":false,\"stream\":true,\"response_mode\":\"streaming\"}"

FULL_TEXT=""
RETURNED_CONV_ID="$CONV_ID"

while IFS= read -r line; do
  # 只处理 data: 开头的行
  if [[ "$line" == data:* ]]; then
    JSON="${line#data: }"
    [ -z "$JSON" ] && continue
    [ "$JSON" = "[DONE]" ] && continue

    TYPE=$(echo "$JSON" | grep -o '"type":"[^"]*"' | head -1 | sed 's/"type":"//;s/"//')
    
    if [ "$TYPE" = "stream" ]; then
      MSG=$(echo "$JSON" | grep -o '"message":"[^"]*"' | head -1 | sed 's/"message":"//;s/"$//')
      FULL_TEXT="${FULL_TEXT}${MSG}"
    fi

    # 提取 conversation_id
    CID=$(echo "$JSON" | grep -o '"conversation_id":"[^"]*"' | head -1 | sed 's/"conversation_id":"//;s/"//')
    [ -n "$CID" ] && RETURNED_CONV_ID="$CID"
  fi
done < <(curl -s -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d "$BODY")

# 输出结果 JSON
ANSWER_ESCAPED=$(echo "$FULL_TEXT" | sed 's/"/\\"/g' | sed 's/$/\\n/' | tr -d '\n' | sed 's/\\n$//')
echo "{\"answer\":\"$ANSWER_ESCAPED\",\"conversation_id\":\"$RETURNED_CONV_ID\"}"
