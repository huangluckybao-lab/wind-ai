#!/usr/bin/env python3
"""
Wind AI — 课程知识库问答 API caller with SSE streaming support.
Usage: python3 call_wind.py "用户问题" [conversation_id]
"""

import sys
import json
import urllib.request
import urllib.error

API_URL = "https://api-spectra.duplik.cn/v1/conversations"
TOKEN = "sk-hQ9Izn7hfWgZsuyagHNZM85NC1XEH0KV"
AGENT_ID = "SP782317380904940"


def call_wind(message: str, conversation_id: str = "") -> dict:
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {TOKEN}"
    }

    body = json.dumps({
        "inputs": {},
        "query": message,
        "message": message,
        "conversation_id": conversation_id,
        "agent_id": AGENT_ID,
        "enable_websearch": False,
        "stream": True,
        "response_mode": "streaming"
    }).encode("utf-8")

    req = urllib.request.Request(API_URL, data=body, headers=headers, method="POST")

    full_text = ""
    returned_conversation_id = conversation_id
    buffer = ""

    try:
        with urllib.request.urlopen(req, timeout=60) as response:
            decoder_buffer = b""
            while True:
                chunk = response.read(1024)
                if not chunk:
                    break
                decoder_buffer += chunk
                try:
                    decoded = decoder_buffer.decode("utf-8")
                    decoder_buffer = b""
                except UnicodeDecodeError:
                    continue

                buffer += decoded
                lines = buffer.split("\n")
                buffer = lines.pop()  # keep incomplete line

                for line in lines:
                    trimmed = line.strip()
                    if not trimmed.startswith("data:"):
                        continue
                    json_str = trimmed[5:].strip()
                    if not json_str or json_str == "[DONE]":
                        continue
                    try:
                        data = json.loads(json_str)
                        event_type = data.get("type", "")
                        extra = data.get("extra", {})

                        if event_type == "stream" and data.get("message"):
                            full_text += data["message"]

                        if extra.get("conversation_id"):
                            returned_conversation_id = extra["conversation_id"]

                    except json.JSONDecodeError:
                        continue

    except urllib.error.HTTPError as e:
        error_body = e.read().decode("utf-8", errors="replace")
        print(json.dumps({"error": f"HTTP {e.code}: {error_body}"}))
        sys.exit(1)
    except Exception as e:
        print(json.dumps({"error": str(e)}))
        sys.exit(1)

    return {
        "answer": full_text.strip(),
        "conversation_id": returned_conversation_id
    }


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({"error": "Usage: call_wind.py <message> [conversation_id]"}))
        sys.exit(1)

    user_message = sys.argv[1]
    conv_id = sys.argv[2] if len(sys.argv) > 2 else ""

    result = call_wind(user_message, conv_id)
    print(json.dumps(result, ensure_ascii=False))
