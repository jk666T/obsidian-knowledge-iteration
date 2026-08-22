#!/usr/bin/env bash
# SessionStart 钩子：检查知识库收件箱是否有未入环的笔记
# 有 → 输出 JSON（systemMessage 提示用户 + additionalContext 注入模型开场提醒）
# 无 → 无输出（不打扰）
dir="{{VAULT_PATH}}/00-收件箱"
n=$(find "$dir" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
if [ "$n" -gt 0 ]; then
  cat <<EOF
{"systemMessage":"收件箱有 $n 条未整理笔记","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"知识库收件箱 {{VAULT_PATH}}/00-收件箱 有 $n 条未入环笔记。请在开场向用户提示：是否运行「整理收件箱」skill 把笔记分类入环（新概念建四件套 / 碎片归并已有原子）。"}}
EOF
fi
exit 0