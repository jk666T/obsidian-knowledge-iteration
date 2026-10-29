#!/usr/bin/env bash
# ============================================================
#  知识迭代系统 · 一键安装脚本
#  用法：bash install.sh
#       或直接把本脚本拖进终端运行
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT_DIR="$SCRIPT_DIR"

echo ""
echo "🧬 知识迭代系统 · 一键安装"
echo "=========================="
echo ""

# ── 1. 询问 vault 路径 ──────────────────────────────────────
read -p "📂 你的 Obsidian vault 绝对路径（例如 D:/MyVault 或 /Users/you/vault）：" VAULT_PATH
VAULT_PATH="${VAULT_PATH%/}"  # 去掉末尾斜杠

if [ ! -d "$VAULT_PATH" ]; then
  echo "❌ 路径不存在：$VAULT_PATH"
  echo "请先创建这个目录，或检查路径是否正确。"
  exit 1
fi

echo "✅ Vault 路径：$VAULT_PATH"
echo ""

# ── 2. 创建 vault 文件夹结构 ────────────────────────────────
echo "📁 创建文件夹结构…"
mkdir -p "$VAULT_PATH/.claude/hooks"
mkdir -p "$VAULT_PATH/.claude/skills/organize-inbox"
mkdir -p "$VAULT_PATH/.claude/skills/knowledge-iteration"
mkdir -p "$VAULT_PATH/.claude/skills/knowledge-base-qa"
mkdir -p "$VAULT_PATH/.claude/skills/weekly-report"
mkdir -p "$VAULT_PATH/_系统/模板"
mkdir -p "$VAULT_PATH/_系统/技能"
mkdir -p "$VAULT_PATH/_系统/周报"
mkdir -p "$VAULT_PATH/00-收件箱"
mkdir -p "$VAULT_PATH/10-知识原子"
mkdir -p "$VAULT_PATH/20-迭代日志"
mkdir -p "$VAULT_PATH/30-已掌握"
mkdir -p "$VAULT_PATH/40-素材库"
mkdir -p "$VAULT_PATH/疑问"
mkdir -p "$VAULT_PATH/附件"

# ── 3. 复制文件并替换 {{VAULT_PATH}} ─────────────────────────
echo "📄 复制并配置文件…"

# 替换占位符并写入目标位置
replace_and_copy() {
  local src="$1"
  local dst="$2"
  sed "s|{{VAULT_PATH}}|$VAULT_PATH|g" "$src" > "$dst"
  echo "   → $dst"
}

# ── skills ──
replace_and_copy "$KIT_DIR/skills/organize-inbox/SKILL.md" \
  "$VAULT_PATH/.claude/skills/organize-inbox/SKILL.md"

replace_and_copy "$KIT_DIR/skills/knowledge-iteration/SKILL.md" \
  "$VAULT_PATH/.claude/skills/knowledge-iteration/SKILL.md"

replace_and_copy "$KIT_DIR/skills/knowledge-base-qa/SKILL.md" \
  "$VAULT_PATH/.claude/skills/knowledge-base-qa/SKILL.md"

replace_and_copy "$KIT_DIR/skills/weekly-report/SKILL.md" \
  "$VAULT_PATH/.claude/skills/weekly-report/SKILL.md"

# ── 同时复制一份到 _系统/技能/ 作为可读副本 ──
replace_and_copy "$KIT_DIR/skills/organize-inbox/SKILL.md" \
  "$VAULT_PATH/_系统/技能/整理收件箱.md"

replace_and_copy "$KIT_DIR/skills/knowledge-iteration/SKILL.md" \
  "$VAULT_PATH/_系统/技能/知识迭代.md"

replace_and_copy "$KIT_DIR/skills/knowledge-base-qa/SKILL.md" \
  "$VAULT_PATH/_系统/技能/知识库问答.md"

replace_and_copy "$KIT_DIR/skills/weekly-report/SKILL.md" \
  "$VAULT_PATH/_系统/技能/周报.md"

# ── hooks ──
replace_and_copy "$KIT_DIR/hooks/check-inbox.sh" \
  "$VAULT_PATH/.claude/hooks/check-inbox.sh"
chmod +x "$VAULT_PATH/.claude/hooks/check-inbox.sh"

# ── settings.json ──
replace_and_copy "$KIT_DIR/settings.json" \
  "$VAULT_PATH/.claude/settings.json"

# ── templates ──
cp "$KIT_DIR/templates/"*.md "$VAULT_PATH/_系统/模板/"
echo "   → $VAULT_PATH/_系统/模板/ (5 个模板)"

# ── core-docs ──
cp "$KIT_DIR/core-docs/知识迭代协议.md" "$VAULT_PATH/_系统/"
cp "$KIT_DIR/core-docs/迭代流程图.md" "$VAULT_PATH/_系统/"
cp "$KIT_DIR/core-docs/仪表盘.md" "$VAULT_PATH/_系统/"
echo "   → $VAULT_PATH/_系统/ (协议 + 流程图 + 仪表盘)"

# ── Obsidian 插件（随包附带；精简分发版未含时自动跳过）──
if [ -d "$KIT_DIR/.obsidian/plugins" ]; then
  echo "📦 复制 Obsidian 插件（Dataview / AnyContent / Claudian / BRAT）…"
  mkdir -p "$VAULT_PATH/.obsidian/plugins"
  cp -r "$KIT_DIR/.obsidian/plugins/." "$VAULT_PATH/.obsidian/plugins/"
  cp "$KIT_DIR/.obsidian/app.json" "$VAULT_PATH/.obsidian/" 2>/dev/null || true
  cp "$KIT_DIR/.obsidian/appearance.json" "$VAULT_PATH/.obsidian/" 2>/dev/null || true
  cp "$KIT_DIR/.obsidian/community-plugins.json" "$VAULT_PATH/.obsidian/" 2>/dev/null || true
  cp "$KIT_DIR/.obsidian/core-plugins.json" "$VAULT_PATH/.obsidian/" 2>/dev/null || true
  cp "$KIT_DIR/.obsidian/graph.json" "$VAULT_PATH/.obsidian/" 2>/dev/null || true
  echo "   → $VAULT_PATH/.obsidian/ (4 个插件 + 通用配置)"
else
  echo "⏭️  跳过 .obsidian（本分发版未随包附带插件）"
fi

# ── AnyContent 导入后端（随包附带；未含时自动跳过）──
if [ -f "$KIT_DIR/anycontent-obsidian-backend/start.bat" ]; then
  echo "🚀 复制 AnyContent 导入后端（视频/文章导入）…"
  mkdir -p "$VAULT_PATH/anycontent-obsidian-backend"
  cp -r "$KIT_DIR/anycontent-obsidian-backend/." "$VAULT_PATH/anycontent-obsidian-backend/"
  chmod +x "$VAULT_PATH/anycontent-obsidian-backend/start.bat" 2>/dev/null || true
  echo "   → $VAULT_PATH/anycontent-obsidian-backend/ (视频/文章导入后端)"
else
  echo "⏭️  跳过 AnyContent 导入后端（本分发版未随包附带）"
fi

# ── 4. 验证 ──────────────────────────────────────────────────
echo ""
echo "🔍 验证安装…"

errors=0
[ -f "$VAULT_PATH/.claude/settings.json" ] || { echo "❌ settings.json 缺失"; errors=$((errors+1)); }
[ -f "$VAULT_PATH/.claude/hooks/check-inbox.sh" ] || { echo "❌ check-inbox.sh 缺失"; errors=$((errors+1)); }
[ -f "$VAULT_PATH/.claude/skills/organize-inbox/SKILL.md" ] || { echo "❌ organize-inbox SKILL.md 缺失"; errors=$((errors+1)); }
[ -f "$VAULT_PATH/.claude/skills/knowledge-iteration/SKILL.md" ] || { echo "❌ knowledge-iteration SKILL.md 缺失"; errors=$((errors+1)); }
[ -f "$VAULT_PATH/.claude/skills/knowledge-base-qa/SKILL.md" ] || { echo "❌ knowledge-base-qa SKILL.md 缺失"; errors=$((errors+1)); }
[ -f "$VAULT_PATH/.claude/skills/weekly-report/SKILL.md" ] || { echo "❌ weekly-report SKILL.md 缺失"; errors=$((errors+1)); }
[ -d "$VAULT_PATH/00-收件箱" ] || { echo "❌ 00-收件箱 缺失"; errors=$((errors+1)); }
[ -d "$VAULT_PATH/10-知识原子" ] || { echo "❌ 10-知识原子 缺失"; errors=$((errors+1)); }
[ -d "$VAULT_PATH/_系统/模板" ] || { echo "❌ _系统/模板 缺失"; errors=$((errors+1)); }
# 仅当源套装随包附带对应目录时才校验（精简分发版自动跳过）
if [ -d "$KIT_DIR/.obsidian/plugins" ]; then
  [ -f "$VAULT_PATH/.obsidian/plugins/dataview/main.js" ] || { echo "❌ Obsidian 插件 dataview 缺失"; errors=$((errors+1)); }
fi
if [ -f "$KIT_DIR/anycontent-obsidian-backend/start.bat" ]; then
  [ -f "$VAULT_PATH/anycontent-obsidian-backend/start.bat" ] || { echo "❌ AnyContent 后端缺失"; errors=$((errors+1)); }
  [ -f "$VAULT_PATH/anycontent-obsidian-backend/tools/ffmpeg/bin/ffmpeg.exe" ] || { echo "❌ ffmpeg（内置）缺失"; errors=$((errors+1)); }
  [ -f "$VAULT_PATH/anycontent-obsidian-backend/tools/uv/uv.exe" ] || { echo "❌ uv（内置）缺失"; errors=$((errors+1)); }
fi

# 检查是否有未替换的占位符
PLACEHOLDER_CHECK=$(grep -r "{{VAULT_PATH}}" "$VAULT_PATH/.claude/" 2>/dev/null || true)
if [ -n "$PLACEHOLDER_CHECK" ]; then
  echo "⚠️  警告：以下文件仍有未替换的 {{VAULT_PATH}} 占位符："
  echo "$PLACEHOLDER_CHECK"
  errors=$((errors+1))
fi

echo ""
if [ "$errors" -eq 0 ]; then
  echo "✅✅✅ 安装完成！0 个错误。"
  echo ""
  echo "🎯 现在可以进入你的 vault 目录，运行 claude 开始使用："
  echo ""
  echo "   cd \"$VAULT_PATH\""
  echo "   claude"
  echo ""
  echo "📥 丢一条笔记到 00-收件箱/，然后对 AI 说「整理收件箱」→ 系统启动！"
  echo ""
  echo "📖 详细说明见 README.md"
else
  echo "⚠️  安装完成，但有 $errors 个问题需要检查。"
  exit 1
fi