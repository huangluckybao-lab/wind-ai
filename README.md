# 🌬️ Wind AI — 课程知识库问答 Skill

> 黄颖老师出品 · 连接真实课程知识库 · 支持多轮对话

## 一键安装

### 方案 A（推荐）：ClawHub

```bash
clawhub install huangluckybao-lab/wind-ai
```

### 方案 B（无 Node / 无 Homebrew）

**macOS / Linux：**

```bash
curl -sL https://raw.githubusercontent.com/huangluckybao-lab/wind-ai/master/install.sh | bash
```

**Windows（PowerShell）：**

```powershell
irm https://raw.githubusercontent.com/huangluckybao-lab/wind-ai/master/install.ps1 | iex
```

安装完成后重启你的 AI 助手平台即可生效。

或手动安装：将本文件夹放入你的 AI 助手平台的 `skills/` 目录，重启平台即可。

## 功能

- 📚 基于黄颖老师维护的课程知识库回答问题
- 🔄 支持多轮连续对话（会话记忆）
- 🚫 只说知识库内容，不乱编答案
- ✅ 兼容标准 SKILL.md 格式，适配多个主流 AI 助手平台

## 使用方式

安装后，直接在 AI 助手中提问课程相关内容，例如：

> "AI Agent 的三层结构是什么？"
> "帮我出一道关于 MCP 协议的选择题"

## 适配平台

| 平台 | 支持 |
|------|------|
| OpenClaw | ✅ |
| WorkBuddy | ✅ |
| LobsterAI | ✅ |
| ArkClaw | ✅ |
| KimiClaw | ✅ |
| 其他支持 SKILL.md 的平台 | ✅ |

## 维护

知识库内容由黄颖老师统一更新，学员无需任何配置。
