@echo off
chcp 65001 >nul
title 知识迭代系统 · 一键安装
echo.
echo 🧬 知识迭代系统 · 一键安装
echo ==========================
echo.

rem ── 询问 vault 路径 ──
set /p VAULT_PATH=📂 你的 Obsidian vault 绝对路径（例如 D:\MyVault）：
if not exist "%VAULT_PATH%" (
    echo ❌ 路径不存在：%VAULT_PATH%
    echo 请先创建这个目录，或检查路径是否正确。
    pause
    exit /b 1
)
echo ✅ Vault 路径：%VAULT_PATH%
echo.

rem ── 确定本脚本所在目录 ──
set KIT_DIR=%~dp0
rem 去掉末尾反斜杠
if "%KIT_DIR:~-1%"=="\" set KIT_DIR=%KIT_DIR:~0,-1%

rem ── 创建文件夹结构 ──
echo 📁 创建文件夹结构…
mkdir "%VAULT_PATH%\.claude\hooks" 2>nul
mkdir "%VAULT_PATH%\.claude\skills\organize-inbox" 2>nul
mkdir "%VAULT_PATH%\.claude\skills\knowledge-iteration" 2>nul
mkdir "%VAULT_PATH%\_系统\模板" 2>nul
mkdir "%VAULT_PATH%\_系统\技能" 2>nul
mkdir "%VAULT_PATH%\00-收件箱" 2>nul
mkdir "%VAULT_PATH%\10-知识原子" 2>nul
mkdir "%VAULT_PATH%\20-迭代日志" 2>nul
mkdir "%VAULT_PATH%\30-已掌握" 2>nul
mkdir "%VAULT_PATH%\40-素材库" 2>nul
mkdir "%VAULT_PATH%\疑问" 2>nul
mkdir "%VAULT_PATH%\附件" 2>nul

rem ── 替换 {{VAULT_PATH}} 并复制文件 ──
echo 📄 复制并配置文件…
setlocal enabledelayedexpansion

rem 需要把反斜杠转成正斜杠给 sed 用
set "VAULT_PATH_FWD=%VAULT_PATH:\=/%"

rem skills
powershell -Command "(Get-Content '%KIT_DIR%\skills\organize-inbox\SKILL.md') -replace '{{VAULT_PATH}}', '%VAULT_PATH_FWD%' | Set-Content '%VAULT_PATH%\.claude\skills\organize-inbox\SKILL.md' -Encoding UTF8"
echo    → .claude\skills\organize-inbox\SKILL.md

powershell -Command "(Get-Content '%KIT_DIR%\skills\knowledge-iteration\SKILL.md') -replace '{{VAULT_PATH}}', '%VAULT_PATH_FWD%' | Set-Content '%VAULT_PATH%\.claude\skills\knowledge-iteration\SKILL.md' -Encoding UTF8"
echo    → .claude\skills\knowledge-iteration\SKILL.md

rem 同时复制一份到 _系统/技能/
copy "%KIT_DIR%\skills\organize-inbox\SKILL.md" "%VAULT_PATH%\_系统\技能\整理收件箱.md" >nul
copy "%KIT_DIR%\skills\knowledge-iteration\SKILL.md" "%VAULT_PATH%\_系统\技能\知识迭代.md" >nul

rem hooks
powershell -Command "(Get-Content '%KIT_DIR%\hooks\check-inbox.sh') -replace '{{VAULT_PATH}}', '%VAULT_PATH_FWD%' | Set-Content '%VAULT_PATH%\.claude\hooks\check-inbox.sh' -Encoding UTF8"
echo    → .claude\hooks\check-inbox.sh

rem settings.json
powershell -Command "(Get-Content '%KIT_DIR%\settings.json') -replace '{{VAULT_PATH}}', '%VAULT_PATH_FWD%' | Set-Content '%VAULT_PATH%\.claude\settings.json' -Encoding UTF8"
echo    → .claude\settings.json

rem templates
copy "%KIT_DIR%\templates\*.md" "%VAULT_PATH%\_系统\模板\" >nul
echo    → _系统\模板\ (5 个模板)

rem core-docs
copy "%KIT_DIR%\core-docs\知识迭代协议.md" "%VAULT_PATH%\_系统\" >nul
copy "%KIT_DIR%\core-docs\迭代流程图.md" "%VAULT_PATH%\_系统\" >nul
copy "%KIT_DIR%\core-docs\仪表盘.md" "%VAULT_PATH%\_系统\" >nul
echo    → _系统\ (协议 + 流程图 + 仪表盘)

rem ── 验证 ──
echo.
echo 🔍 验证安装…
set errors=0
if not exist "%VAULT_PATH%\.claude\settings.json" echo ❌ settings.json 缺失 & set /a errors+=1
if not exist "%VAULT_PATH%\.claude\hooks\check-inbox.sh" echo ❌ check-inbox.sh 缺失 & set /a errors+=1
if not exist "%VAULT_PATH%\.claude\skills\organize-inbox\SKILL.md" echo ❌ organize-inbox SKILL.md 缺失 & set /a errors+=1
if not exist "%VAULT_PATH%\.claude\skills\knowledge-iteration\SKILL.md" echo ❌ knowledge-iteration SKILL.md 缺失 & set /a errors+=1
if not exist "%VAULT_PATH%\00-收件箱" echo ❌ 00-收件箱 缺失 & set /a errors+=1
if not exist "%VAULT_PATH%\10-知识原子" echo ❌ 10-知识原子 缺失 & set /a errors+=1
if not exist "%VAULT_PATH%\_系统\模板" echo ❌ _系统\模板 缺失 & set /a errors+=1

echo.
if %errors% equ 0 (
    echo ✅✅✅ 安装完成！0 个错误。
    echo.
    echo 🎯 现在可以进入你的 vault 目录，运行 claude 开始使用：
    echo.
    echo    cd /d "%VAULT_PATH%"
    echo    claude
    echo.
    echo 📥 丢一条笔记到 00-收件箱，然后对 AI 说「整理收件箱」→ 系统启动！
    echo.
    echo 📖 详细说明见 README.md
) else (
    echo ⚠️  安装完成，但有 %errors% 个问题需要检查。
)
endlocal
pause
