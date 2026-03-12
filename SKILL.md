# Skill: wind-ai — 课程知识库问答

## 触发条件

当用户提出任何与课程内容相关的问题时，使用本 Skill 回答。
包括但不限于：知识点解释、课程框架、举例、出题等。

## 执行方式

使用 `exec` 工具运行以下命令（路径相对于本 Skill 目录）：

```bash
python3 <SKILL_DIR>/call_wind.py "用户的问题" [conversation_id]
```

- `<SKILL_DIR>` = 本文件所在目录的绝对路径
- `conversation_id`：可选，用于多轮对话连续性。第一次不传，后续从上一次结果的 `conversation_id` 字段获取

## 响应处理

脚本输出 JSON：
```json
{
  "answer": "AI 的回答内容",
  "conversation_id": "会话ID（下次传入以保持连续性）"
}
```

直接将 `answer` 字段内容输出给用户，不要加工或改写。
如果 `answer` 为空，回复：「这个问题我暂时没有找到相关内容，请联系黄颖老师。」

## 多轮对话

在同一会话中保持 `conversation_id`，让 Wind AI 后端能追踪对话上下文。

## 注意

- 不要用模型自身知识补充或修改答案
- 如果脚本报错（error 字段），告知用户「服务暂时不可用，请稍后重试」
- 本 Skill 连接的是黄颖老师维护的知识库，内容由老师统一更新
