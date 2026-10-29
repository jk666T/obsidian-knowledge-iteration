# 🧬 知识迭代系统 · 通用启动套件

> **把 Obsidian 变成你的「第二大脑训练场」。**
> 基于 Andrej Karpathy 的「从零构建 / 训练循环」哲学，用 K-Loop 五步法（试→差→因→改→验）把你的知识当作模型来训练。
> 🇬🇧 English: [README.en.md](./README.en.md)

![License](https://img.shields.io/badge/License-Apache_2.0-blue) ![Platforms](https://img.shields.io/badge/Platforms-Windows-blue) ![Obsidian](https://img.shields.io/badge/Powered_by-Obsidian-7C3AED) ![Claude Code](https://img.shields.io/badge/Claude_Code-Skills-4B0082)

---

## 📦 套件内容

```
知识库启动套件/
├── README.md                        ← 本文件：安装指南
├── README.en.md                     ← 英文版安装指南
├── install.bat                      ← Windows 一键安装启动器（双击）
├── install.ps1                      ← 安装逻辑本体（由 install.bat 调用）
├── install.sh                       ← Mac/Linux 安装脚本（未实测，暂不推荐）
├── settings.json                    ← 配置文件模板
├── LICENSE                          ← Apache License 2.0
├── .gitignore                       ← Obsidian 忽略规则
├── hooks/
│   └── check-inbox.sh               ← 「钩子」：启动时自动提醒整理收件箱
├── skills/
│   ├── organize-inbox/SKILL.md      ← 「整理收件箱」技能
│   ├── knowledge-iteration/SKILL.md ← 「知识迭代」技能
│   ├── knowledge-base-qa/SKILL.md   ← 「知识库问答」技能（实质问题自动查库）
│   └── weekly-report/SKILL.md       ← 「周报」技能（每周复盘）
├── templates/                       ← 5 个模板文件
└── core-docs/                       ← 核心文档
```

---

## 🚀 一键安装

### 前提条件

- **Obsidian** 已安装
- **Claude Code** 已安装（终端能运行 `claude` 命令）
- （推荐）装 **Dataview** 插件，让仪表盘自动渲染（详见 FAQ）

### 方法一：双击安装（推荐）

**Windows**：双击 **`install.bat`**。

脚本会问你：**「你的 Obsidian vault 路径是什么？」**

输入绝对路径（例如 `D:/MyVault`）→ 回车 → **30 秒装完**。

> `install.bat` 只是启动器（纯 ASCII），真正的安装逻辑在 `install.ps1`（UTF-8 BOM，避免中文乱码）。两个文件必须放在同一目录。装完会做内容级自检（编码、frontmatter、`settings.json` 可解析、无占位符残留）。

### 方法二：手动安装

不想用脚本也行：

1. 把 `skills/` → 复制到 `你的库/.claude/skills/`
2. 把 `hooks/check-inbox.sh` → `你的库/.claude/hooks/`
3. 把 `settings.json` → `你的库/.claude/settings.json`
4. 把 `templates/` → `你的库/_系统/模板/`
5. 把 `core-docs/` 里的文档 → `你的库/_系统/`
6. 新建 `00-收件箱`、`10-知识原子`、`20-迭代日志`、`30-已掌握`
7. **全局搜索 `{{VAULT_PATH}}`** → 替换成你的 vault 路径

### 装好之后

进入你的 vault 目录运行 `claude`，丢一条笔记到 `00-收件箱/`，然后对 AI 说：

> **「整理收件箱」**

系统就启动了！

---

## 🤔 「钩子」到底是什么？

**钩子 = 一个每次启动 `claude` 时自动运行的脚本。**

本套件装了一个 `check-inbox.sh` 钩子，它的工作很简单：

> 每次你启动 claude → 它看一眼 `00-收件箱/` 有没有文件 → 有就提醒你整理 → 没事就安静

**你不需要手动管它。** 装好了它就在那里自动工作。

---

## 🧠 系统哲学

> **读过 ≠ 理解，记住 ≠ 会用。**
> 理解的唯一证明，是**关书之后还能从零重建**。

每个知识点 = 一个**知识原子**，每一轮迭代 = 一个 **epoch**（训练周期）。

### 三状态流转

```
随手记 → 00-收件箱
             │ 「整理收件箱」
             ├─ 新概念 → 建四件套 → 10-知识原子/概念/
             ├─ 碎片   → 归并到已有原子
             ├─ 疑问   → 移入 疑问区
             └─ 无用   → 删除
                                   ┌─ 重建 ❌ 回去重练
                                   ▼
                        试→差→因→改→验  K-Loop 循环
                                   │ 重建 ✅ + 收敛全满足
                                   ▼
                            30-已掌握/概念/
                                   │ 遇到反例 → 丢回收件箱重训
```

### K-Loop 五步法

| 步骤 | 做什么 |
| :-- | :-- |
| 1️⃣ **试** | 动手用 / 讲给别人 / 做题 / 写代码 |
| 2️⃣ **差** | 找落差：「我本以为 X，实际发现 Y」 |
| 3️⃣ **因** | 归因到笔记具体位置（哪个假设错了？） |
| 4️⃣ **改** | 修正笔记，版本号 +1，写日志 |
| 5️⃣ **验** | ❗**关书**从零重建，验证真懂 |

### 晋升条件（全满足 → 已掌握）

- [ ] 重建稿**连续 2 次 ✅** 且零参考
- [ ] 压缩版**一页纸、准确无损**
- [ ] 教授稿**新手能复述**

---

## 🎮 日常使用

| 你想做什么 | 对 AI 说 |
| :-- | :-- |
| 把随手记入环 | **「整理收件箱」** |
| 迭代一个知识点 | **「迭代 [[概念名]]」** |
| 任何知识/方法/决策问题 | **直接问**（自动先查库，时效内容联网核实） |
| 每周复盘 | **「写周报」** |
| 跳过归因直接重试 | **「违规」** |
| 连续卡壳 3 轮以上 | **「刹车」** |
| 跑一轮重建测试 | **「重建测试 [[概念名]]」** |
| 写压缩版 | **「压缩 [[概念名]]」** |
| 写教授稿 | **「教授稿 [[概念名]]」** |
| 收敛检查 | **「收敛检查 [[概念名]]」** |

---

## ⚙️ 自定义

- **改触发词**：编辑 SKILL.md 的 `description` 字段
- **改收敛标准**：修改 `知识迭代协议.md` 第三章
- **改钩子行为**：编辑 `hooks/check-inbox.sh`
- **英文文件夹名**：改完名后同步更新 SKILL.md 中的路径

---

## ❓ 常见问题

**Q: 需要装什么 Obsidian 插件？**
A: 核心系统纯 Markdown 即可运行。推荐装 **Dataview**（让仪表盘自动渲染）；不装也能用。

**Q: 技能文件放哪里？**
A: 必须放 `.claude/skills/`，Claude Code 只从这里加载。

**Q: 一定要中文文件夹名吗？**
A: 不必须，改完名同步更新 SKILL.md 路径即可。

**Q: 知识原子能跨库迁移吗？**
A: 可以。一个概念 = 一个文件夹，直接复制到新库即可。

**Q: 为什么有两个安装文件（`install.bat` / `install.ps1`）？**
A: `install.bat` 是纯 ASCII 启动器，负责 `chcp 65001` 后调用 `install.ps1`；`install.ps1` 才是逻辑本体（UTF-8 带 BOM，用 .NET 读写文件，避免 PowerShell 5.1 按 GBK 解码导致的全量乱码）。两者必须同目录，缺一不可。

**Q: Mac / Linux 能用吗？**
A: 仓库保留了 `install.sh`，但尚未实测，文档暂不承诺；请优先使用 Windows。

---

## 📜 许可证

Apache License 2.0 — 可自由使用、修改、分发（含商业用途），需保留版权与许可声明。详见 [LICENSE](./LICENSE)。

---

> **现在就去建你的第一个知识原子吧！丢一条笔记到 `00-收件箱/`，然后对 AI 说：「整理收件箱」🚀**