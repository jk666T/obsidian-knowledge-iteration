param(
    [string]$VaultPath = ""
)

$ErrorActionPreference = "Stop"
$KitDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Write-Utf8NoBom([string]$Path, [string]$Text) {
    [System.IO.File]::WriteAllText($Path, $Text, $Utf8NoBom)
}

function Read-Utf8([string]$Path) {
    return [System.IO.File]::ReadAllText($Path, $Utf8NoBom)
}

Write-Host ""
Write-Host "🧬 知识迭代系统 · 一键安装"
Write-Host "=========================="
Write-Host ""

# ── 1. 询问 vault 路径 ──
if ([string]::IsNullOrWhiteSpace($VaultPath)) {
    $VaultPath = Read-Host "📂 你的 Obsidian vault 绝对路径（例如 D:\MyVault）"
}
$VaultPath = $VaultPath.Trim().Trim('"').TrimEnd('\', '/')
if (-not (Test-Path -LiteralPath $VaultPath -PathType Container)) {
    Write-Host "❌ 路径不存在：$VaultPath" -ForegroundColor Red
    Write-Host "请先创建这个目录，或检查路径是否正确。"
    exit 1
}
$VaultPath = (Resolve-Path -LiteralPath $VaultPath).Path
Write-Host "✅ Vault 路径：$VaultPath"
Write-Host ""

$VaultFwd = $VaultPath.Replace('\', '/')

# ── 2. 创建文件夹结构 ──
Write-Host "📁 创建文件夹结构…"
$dirs = @(
    ".claude\hooks",
    ".claude\skills\organize-inbox",
    ".claude\skills\knowledge-iteration",
    ".claude\skills\knowledge-base-qa",
    ".claude\skills\weekly-report",
    "_系统\模板",
    "_系统\技能",
    "_系统\周报",
    "00-收件箱",
    "10-知识原子",
    "20-迭代日志",
    "30-已掌握",
    "40-素材库",
    "疑问",
    "附件"
)
foreach ($d in $dirs) {
    New-Item -ItemType Directory -Force -Path (Join-Path $VaultPath $d) | Out-Null
}

# ── 3. 替换占位符并写入（UTF-8 无 BOM、保留源文件 LF）──
Write-Host "📄 复制并配置文件…"
$fileMap = @(
    @{ Src = "skills\organize-inbox\SKILL.md";      Dst = ".claude\skills\organize-inbox\SKILL.md" },
    @{ Src = "skills\knowledge-iteration\SKILL.md"; Dst = ".claude\skills\knowledge-iteration\SKILL.md" },
    @{ Src = "skills\knowledge-base-qa\SKILL.md";   Dst = ".claude\skills\knowledge-base-qa\SKILL.md" },
    @{ Src = "skills\weekly-report\SKILL.md";       Dst = ".claude\skills\weekly-report\SKILL.md" },
    @{ Src = "hooks\check-inbox.sh";                Dst = ".claude\hooks\check-inbox.sh" },
    @{ Src = "settings.json";                       Dst = ".claude\settings.json" }
)

foreach ($m in $fileMap) {
    $src = Join-Path $KitDir $m.Src
    $dst = Join-Path $VaultPath $m.Dst
    if (-not (Test-Path -LiteralPath $src)) {
        Write-Host "❌ 缺少源文件：$($m.Src)" -ForegroundColor Red
        exit 1
    }
    $text = (Read-Utf8 $src).Replace('{{VAULT_PATH}}', $VaultFwd)
    Write-Utf8NoBom $dst $text
    Write-Host "   → $($m.Dst)"
}

# 可读副本（使用已替换占位符的版本）
Write-Host "   → _系统\技能\（可读副本）"
$copyMap = @(
    @{ Src = "organize-inbox";      Name = "整理收件箱.md" },
    @{ Src = "knowledge-iteration"; Name = "知识迭代.md" },
    @{ Src = "knowledge-base-qa";   Name = "知识库问答.md" },
    @{ Src = "weekly-report";       Name = "周报.md" }
)
foreach ($c in $copyMap) {
    $src = Join-Path $VaultPath ".claude\skills\$($c.Src)\SKILL.md"
    $dst = Join-Path $VaultPath "_系统\技能\$($c.Name)"
    Copy-Item -LiteralPath $src -Destination $dst -Force
}

# 模板
$tplDst = Join-Path $VaultPath "_系统\模板"
Get-ChildItem -LiteralPath (Join-Path $KitDir "templates") -Filter "*.md" -File | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $tplDst -Force
}
Write-Host "   → _系统\模板\ (5 个模板)"

# core-docs
foreach ($doc in @("知识迭代协议.md", "迭代流程图.md", "仪表盘.md")) {
    Copy-Item -LiteralPath (Join-Path $KitDir "core-docs\$doc") -Destination (Join-Path $VaultPath "_系统\$doc") -Force
}
Write-Host "   → _系统\ (协议 + 流程图 + 仪表盘)"

# ── 4. Obsidian 插件（随包附带；精简分发版未含时自动跳过）──
$HasObsidian = Test-Path -LiteralPath (Join-Path $KitDir ".obsidian\plugins") -PathType Container
if ($HasObsidian) {
    Write-Host "📦 复制 Obsidian 插件（Dataview / AnyContent / Claudian / BRAT）…"
    $obsDst = Join-Path $VaultPath ".obsidian"
    New-Item -ItemType Directory -Force -Path (Join-Path $obsDst "plugins") | Out-Null
    Copy-Item -Path (Join-Path $KitDir ".obsidian\plugins\*") -Destination (Join-Path $obsDst "plugins") -Recurse -Force
    foreach ($cfg in @("app.json", "appearance.json", "community-plugins.json", "core-plugins.json", "graph.json")) {
        $s = Join-Path $KitDir ".obsidian\$cfg"
        if (Test-Path -LiteralPath $s) { Copy-Item -LiteralPath $s -Destination (Join-Path $obsDst $cfg) -Force }
    }
    Write-Host "   → .obsidian - 4 个插件 + 通用配置"
} else {
    Write-Host "⏭️  跳过 .obsidian（本分发版未随包附带插件）"
}

# ── 5. AnyContent 导入后端（随包附带；未附时自动跳过）──
$HasBackend = Test-Path -LiteralPath (Join-Path $KitDir "anycontent-obsidian-backend\start.bat") -PathType Leaf
if ($HasBackend) {
    Write-Host "🚀 复制 AnyContent 导入后端（视频/文章导入）…"
    $beSrc = Join-Path $KitDir "anycontent-obsidian-backend"
    $beDst = Join-Path $VaultPath "anycontent-obsidian-backend"
    New-Item -ItemType Directory -Force -Path $beDst | Out-Null
    Copy-Item -Path (Join-Path $beSrc "*") -Destination $beDst -Recurse -Force
    Write-Host "   → anycontent-obsidian-backend - 视频/文章导入后端"
} else {
    Write-Host "⏭️  跳过 AnyContent 导入后端（本分发版未随包附带）"
}

# ── 6. 验证（存在性 + 内容级）──
Write-Host ""
Write-Host "🔍 验证安装…"
$script:errors = 0

function Fail([string]$Message) {
    Write-Host "❌ $Message" -ForegroundColor Red
    $script:errors++
}

$mustExist = @(
    ".claude\settings.json",
    ".claude\hooks\check-inbox.sh",
    ".claude\skills\organize-inbox\SKILL.md",
    ".claude\skills\knowledge-iteration\SKILL.md",
    ".claude\skills\knowledge-base-qa\SKILL.md",
    ".claude\skills\weekly-report\SKILL.md",
    "00-收件箱",
    "10-知识原子",
    "_系统\模板"
)
foreach ($p in $mustExist) {
    if (-not (Test-Path -LiteralPath (Join-Path $VaultPath $p))) { Fail "$p 缺失" }
}
if ($HasObsidian -and -not (Test-Path -LiteralPath (Join-Path $VaultPath ".obsidian\plugins\dataview\main.js"))) {
    Fail "Obsidian 插件 dataview 缺失"
}
if ($HasBackend) {
    foreach ($p in @("anycontent-obsidian-backend\start.bat", "anycontent-obsidian-backend\tools\ffmpeg\bin\ffmpeg.exe", "anycontent-obsidian-backend\tools\uv\uv.exe")) {
        if (-not (Test-Path -LiteralPath (Join-Path $VaultPath $p))) { Fail "$p 缺失" }
    }
}

# 内容级 1：settings.json 必须是合法 JSON
try {
    $null = ConvertFrom-Json (Read-Utf8 (Join-Path $VaultPath ".claude\settings.json"))
} catch {
    Fail "settings.json 不是合法 JSON（SessionStart 钩子会失效）"
}

# 内容级 2：4 个技能 frontmatter 完整、中文未乱码
foreach ($f in @("organize-inbox", "knowledge-iteration", "knowledge-base-qa", "weekly-report")) {
    $p = Join-Path $VaultPath ".claude\skills\$f\SKILL.md"
    if (Test-Path -LiteralPath $p) {
        $t = Read-Utf8 $p
        if (-not $t.StartsWith("---") -or $t.IndexOf('知识') -lt 0) { Fail "$f SKILL.md 内容异常（frontmatter 或中文编码损坏）" }
    }
}

# 内容级 3：钩子必须无 BOM、无 CRLF
$hookPath = Join-Path $VaultPath ".claude\hooks\check-inbox.sh"
if (Test-Path -LiteralPath $hookPath) {
    $b = [System.IO.File]::ReadAllBytes($hookPath)
    $hasBom = ($b.Length -ge 3 -and $b[0] -eq 239 -and $b[1] -eq 187 -and $b[2] -eq 191)
    $hasCr = ([Array]::IndexOf($b, [byte]13) -ge 0)
    if ($hasBom -or $hasCr) { Fail "check-inbox.sh 含 BOM 或 CRLF（bash 无法执行）" }
}

# 内容级 4：不得残留占位符
foreach ($d in @(".claude", "_系统\技能")) {
    $root = Join-Path $VaultPath $d
    Get-ChildItem -LiteralPath $root -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
        if ((Read-Utf8 $_.FullName).Contains('{{VAULT_PATH}}')) { Fail "未替换的占位符：$($_.FullName)" }
    }
}

Write-Host ""
if ($script:errors -eq 0) {
    Write-Host "✅✅✅ 安装完成！0 个错误。" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎯 现在可以进入你的 vault 目录，运行 claude 开始使用："
    Write-Host ""
    Write-Host "   cd /d `"$VaultPath`""
    Write-Host "   claude"
    Write-Host ""
    Write-Host "📥 丢一条笔记到 00-收件箱，然后对 AI 说「整理收件箱」→ 系统启动！"
    Write-Host ""
    Write-Host "📖 详细说明见 README.md"
    exit 0
} else {
    Write-Host "⚠️  安装完成，但有 $($script:errors) 个问题需要检查。" -ForegroundColor Yellow
    exit 1
}
