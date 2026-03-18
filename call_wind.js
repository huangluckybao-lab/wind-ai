#!/usr/bin/env node
/**
 * Wind AI — Node.js 调用脚本（无需 Python，需 Node.js 18+ 或 WorkBuddy 内置 Node）
 * 用法: node call_wind.js "你的问题" [conversation_id]
 */

const API_URL = "https://api-spectra.duplik.cn/v1/conversations";
const TOKEN = "sk-hQ9Izn7hfWgZsuyagHNZM85NC1XEH0KV";
const AGENT_ID = "SP782317380904940";

const [, , message, conversationId = ""] = process.argv;

if (!message) {
  console.log(JSON.stringify({ error: "Usage: node call_wind.js <message> [conversation_id]" }));
  process.exit(1);
}

async function callWind(msg, convId) {
  const body = JSON.stringify({
    inputs: {},
    query: msg,
    message: msg,
    conversation_id: convId,
    agent_id: AGENT_ID,
    enable_websearch: false,
    stream: true,
    response_mode: "streaming",
  });

  const res = await fetch(API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${TOKEN}`,
    },
    body,
  });

  if (!res.ok) {
    const text = await res.text();
    console.log(JSON.stringify({ error: `HTTP ${res.status}: ${text}` }));
    process.exit(1);
  }

  let fullText = "";
  let returnedConvId = convId;
  const decoder = new TextDecoder();
  let buffer = "";

  for await (const chunk of res.body) {
    buffer += decoder.decode(chunk, { stream: true });
    const lines = buffer.split("\n");
    buffer = lines.pop(); // 保留不完整的行

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed.startsWith("data:")) continue;
      const jsonStr = trimmed.slice(5).trim();
      if (!jsonStr || jsonStr === "[DONE]") continue;

      try {
        const data = JSON.parse(jsonStr);
        if (data.type === "stream" && data.message) {
          fullText += data.message;
        }
        if (data.extra?.conversation_id) {
          returnedConvId = data.extra.conversation_id;
        }
      } catch {
        // 跳过解析失败的行
      }
    }
  }

  console.log(JSON.stringify({ answer: fullText.trim(), conversation_id: returnedConvId }, null, 0));
}

callWind(message, conversationId).catch((err) => {
  console.log(JSON.stringify({ error: String(err) }));
  process.exit(1);
});
