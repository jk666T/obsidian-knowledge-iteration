# 🧬 Knowledge Iteration System · Universal Starter Kit

> **Turn Obsidian into your "second brain training ground."**
> Built on Andrej Karpathy's "Zero-to-Hero / Training Loop" philosophy — train your knowledge as a model using the K-Loop: **Try → Gap → Cause → Change → Verify**.
> 🇨🇳 中文版: [README.md](./README.md)

![License](https://img.shields.io/badge/License-NonCommercial-orange) ![Platforms](https://img.shields.io/badge/Platforms-Windows-blue) ![Obsidian](https://img.shields.io/badge/Powered_by-Obsidian-7C3AED) ![Claude Code](https://img.shields.io/badge/Claude_Code-Skills-4B0082)

---

## 📦 What's inside

```
knowledge-iteration-starter/
├── README.md                         ← Install guide (中文)
├── README.en.md                      ← This file: install guide (EN)
├── install.bat                       ← Windows one-click launcher (double-click)
├── install.ps1                       ← Install logic (called by install.bat)
├── install.sh                        ← macOS/Linux installer (untested, not recommended yet)
├── settings.json                     ← Claude Code config template
├── LICENSE                           ← Non-Commercial Learning License 1.1
├── .gitignore                        ← Obsidian ignore rules
├── hooks/
│   └── check-inbox.sh                ← "Hook": auto-reminds you to tidy the inbox on startup
├── skills/
│   ├── organize-inbox/SKILL.md       ← "整理收件箱 / Tidy the inbox" skill
│   ├── knowledge-iteration/SKILL.md  ← "知识迭代 / Knowledge iteration" skill
│   ├── knowledge-base-qa/SKILL.md    ← "知识库问答 / Knowledge-base Q&A" skill (auto-queries the vault)
│   └── weekly-report/SKILL.md        ← "周报 / Weekly review" skill
├── templates/                        ← 5 template files (atom note, iteration log, rebuild, compressed, teaching)
└── core-docs/                        ← Core docs (protocol, flowchart, dashboard)
```

---

## 🚀 One-click install

### Prerequisites

- **Obsidian** installed
- **Claude Code** installed (you can run `claude` in your terminal)
- (Optional) **Dataview** plugin recommended for the dashboard (see FAQ)

### Method 1: Double-click install (recommended)

**Windows**: Double-click **`install.bat`**.

The script asks: **"What is your Obsidian vault path?"**

Enter the absolute path (e.g. `D:/MyVault`) → Enter → **installed in ~30 seconds**.

> `install.bat` is only a launcher (pure ASCII); the actual logic lives in `install.ps1` (UTF-8 with BOM, avoids mojibake). Keep both files in the same directory. The installer runs content-level self-checks (encoding, frontmatter, `settings.json` parseability, no leftover placeholders).

### Method 2: Manual install

No scripts? No problem:

1. Copy `skills/` → `your-vault/.claude/skills/`
2. Copy `hooks/check-inbox.sh` → `your-vault/.claude/hooks/`
3. Copy `settings.json` → `your-vault/.claude/settings.json`
4. Copy `templates/` → `your-vault/_系统/模板/`
5. Copy the docs in `core-docs/` → `your-vault/_系统/`
6. Create `00-收件箱`, `10-知识原子`, `20-迭代日志`, `30-已掌握`
7. **Search for `{{VAULT_PATH}}` globally → replace with your vault path**

### After installation

Enter your vault directory, run `claude`, drop a note into `00-收件箱/`, then tell the AI:

> **「整理收件箱」** (Tidy the inbox)

The system is up!

> 💡 Trigger phrases are Chinese by default. Folder names and trigger words can be renamed — see "Customization" below.

---

## 🤔 What exactly is a "Hook"?

**A hook = a script that runs automatically every time you start `claude`.**

This kit installs one `check-inbox.sh` hook. Its job is simple:

> Every time you start claude → it checks whether `00-收件箱/` has any files → if yes, it reminds you to tidy up → if empty, it stays quiet.

**You never need to manage it manually** — once installed, it works on its own.

---

## 🧠 System philosophy

> **Reading ≠ understanding. Memorizing ≠ using.**
> The only proof of understanding is **rebuilding from scratch with the book closed** (zero references).

Every piece of knowledge = a **knowledge atom** (知识原子). Every iteration round = an **epoch** (training cycle).

### Three-state flow

```
capture → 00-收件箱 (inbox)
             │ 「整理收件箱」
             ├─ new concept → build four-piece set → 10-知识原子/<concept>/
             ├─ fragment    → merge into an existing atom
             ├─ question    → move to 疑问/ (questions)
             └─ useless     → delete
                                   ┌─ rebuild ❌ → go practice again
                                   ▼
                  Try → Gap → Cause → Change → Verify  (K-Loop cycle)
                                   │ rebuild ✅ + all convergence met
                                   ▼
                            30-已掌握/<concept>/ (mastered)
                                   │ counterexample found → back to inbox for retraining
```

### The K-Loop in five steps

| Step | What you do |
| :-- | :-- |
| 1️⃣ **Try** (试) | Actually apply it: do it, teach it, solve problems, write code |
| 2️⃣ **Gap** (差) | Find the loss: "I thought X, but actually found Y" |
| 3️⃣ **Cause** (因) | Attribute it to a specific spot in the note (which assumption was wrong?) |
| 4️⃣ **Change** (改) | Fix the note, version +1, write an iteration log |
| 5️⃣ **Verify** (验) | ❗ **Close the book** and rebuild from scratch — prove you truly get it |

### Promotion conditions (all must be met → mastered)

- [ ] Rebuild draft **passed twice in a row ✅**, zero references
- [ ] Compressed version is **one page, accurate, lossless**
- [ ] Teaching script can be **restated by a beginner**

---

## 🎮 Daily usage

| What you want | Say to the AI |
| :-- | :-- |
| Put a captured note into the loop | **「整理收件箱」** |
| Iterate a concept | **「迭代 [[概念名]]」** |
| Any knowledge / method / decision question | **Just ask** (queries the vault first, verifies time-sensitive facts online) |
| Weekly review | **「写周报」** |
| Skipped a step on purpose? | **「违规」** (violation → fall back and redo that step) |
| Stuck for 3+ rounds | **「刹车」** (brake → stop patching, return to first principles) |
| Run a rebuild test | **「重建测试 [[概念名]]」** |
| Write the compressed version | **「压缩 [[概念名]]」** |
| Write the teaching script | **「教授稿 [[概念名]]」** |
| Convergence check | **「收敛检查 [[概念名]]」** |

> The command phrases are Chinese by default. Rename them by editing the `description` field in each SKILL.md.

---

## ⚙️ Customization

- **Change trigger phrases**: edit the `description` field in `SKILL.md`
- **Change convergence criteria**: edit Chapter 3 of `知识迭代协议.md`
- **Change hook behavior**: edit `hooks/check-inbox.sh`
- **Use English folder names**: rename the folders, then update the paths in `SKILL.md` accordingly

---

## ❓ FAQ

**Q: Which Obsidian plugins do I need?**
A: The core system runs on plain Markdown. **Dataview** is recommended for dashboard rendering; everything else works without it.

**Q: Where do skill files have to go?**
A: They MUST be in `.claude/skills/` — Claude Code only loads skills from there.

**Q: Do folder names have to be Chinese?**
A: No. Rename them and update the paths in `SKILL.md` accordingly.

**Q: Can knowledge atoms survive a vault migration?**
A: Yes. One concept = one folder; just copy the folder into the new vault.

**Q: Why are there two installer files (`install.bat` / `install.ps1`)?**
A: `install.bat` is a pure-ASCII launcher that switches the console to UTF-8 and calls `install.ps1`; the real logic is in `install.ps1` (UTF-8 with BOM, .NET file I/O), which avoids the mojibake caused by PowerShell 5.1 decoding UTF-8 as GBK. Both files must stay in the same folder.

**Q: Does it work on macOS / Linux?**
A: `install.sh` is kept in the repo but has not been tested yet, so documentation does not promise it. Windows is recommended for now.

---

## 📜 License

Non-Commercial Learning License 1.1 — for learning/research purposes only; commercial use prohibited. See [LICENSE](./LICENSE).

---

> **Time to build your first knowledge atom! Drop a note into `00-收件箱/` and tell the AI: 「整理收件箱」 🚀**