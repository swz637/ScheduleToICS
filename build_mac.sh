#!/bin/bash
# ── 排班表转ICS Mac App 一键打包脚本 ──
# 在 Mac 上运行: bash build_mac.sh
# 产物: dist/ScheduleToICS.app（Finder 中显示为「排班表转ICS」）
#
# 特性：
#   - 自动创建独立虚拟环境，不污染系统 Python
#   - 自动把 app_icon.png 转换成 .icns 应用图标
#   - 使用 onedir 模式打包（比 onefile 对 tkinter 兼容性更好、启动更快）

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================"
echo "  排班表转ICS - macOS 一键打包"
echo "========================================"

# ── [1/5] 检查环境 ──────────────────────────────
echo ""
echo "==> [1/5] 检查环境..."

if [ "$(uname)" != "Darwin" ]; then
    echo "错误: 本脚本只能在 macOS 上运行（当前系统: $(uname)）"
    echo "      请把这个文件夹拷贝到 Mac 上再执行。"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "错误: 未找到 python3，请先安装 Python 3.9+"
    echo "      推荐从 https://www.python.org/downloads/macos/ 下载官方安装包（自带 tkinter）"
    exit 1
fi

PY_MAJOR=$(python3 -c 'import sys; print(sys.version_info.major)')
PY_MINOR=$(python3 -c 'import sys; print(sys.version_info.minor)')
if [ "$PY_MAJOR" -lt 3 ] || { [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -lt 9 ]; }; then
    echo "错误: 需要 Python 3.9+，当前为 $(python3 --version)"
    exit 1
fi

echo "    OK: macOS $(sw_vers -productVersion) / $(python3 --version)"

# ── [2/5] 创建虚拟环境并安装依赖 ─────────────────
echo ""
echo "==> [2/5] 创建虚拟环境并安装依赖..."
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi
.venv/bin/python -m pip install --upgrade pip > /dev/null
.venv/bin/python -m pip install -r requirements.txt
echo "    依赖安装完成"

# ── [3/5] 生成应用图标 (PNG -> ICNS) ─────────────
echo ""
echo "==> [3/5] 生成应用图标..."

if [ ! -f "app_icon.icns" ] && [ ! -f "app_icon.png" ]; then
    echo "错误: 缺少 app_icon.png，无法生成应用图标，请保留图标文件后重试。"
    exit 1
fi

if [ -f "app_icon.icns" ]; then
    echo "    使用已有 app_icon.icns"
else
    ICONSET=".app_icon.iconset"
    rm -rf "$ICONSET" && mkdir -p "$ICONSET"
    for size in 16 32 128 256 512; do
        sips -z "$size" "$size" app_icon.png --out "$ICONSET/icon_${size}x${size}.png" > /dev/null
        sips -z "$((size * 2))" "$((size * 2))" app_icon.png --out "$ICONSET/icon_${size}x${size}@2x.png" > /dev/null
    done
    iconutil -c icns "$ICONSET" -o app_icon.icns
    rm -rf "$ICONSET"
    echo "    已从 app_icon.png 生成 app_icon.icns"
fi

# ── [4/5] 打包 .app (PyInstaller, onedir) ───────
echo ""
echo "==> [4/5] 打包 .app (PyInstaller)..."
.venv/bin/python -m PyInstaller --clean --noconfirm ScheduleToICS.spec

# ── [5/5] 完成 ──────────────────────────────────
echo ""
echo "==> [5/5] 完成！"
APP_PATH="$SCRIPT_DIR/dist/ScheduleToICS.app"
if [ -d "$APP_PATH" ]; then
    echo "    App 路径: $APP_PATH"
    echo "    在 Finder / 程序坞中显示为「排班表转ICS」"
    echo "    可将其拖到「应用程序」文件夹长期使用。"
    echo ""
    echo "    提示: 如需中文文件名，可直接把 ScheduleToICS.app 重命名为 排班表转ICS.app"
    open "$SCRIPT_DIR/dist"
else
    echo "    警告: 未找到生成的 .app，请检查上方日志。"
    exit 1
fi
