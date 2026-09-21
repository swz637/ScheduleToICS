#!/bin/bash
# ── 排班表转ICS 免打包运行（Mac 专用）──
# 双击本文件即可直接运行程序（无需打包）。
# 首次运行会自动创建虚拟环境并安装依赖，之后秒开。
# 要求: 已安装 Python 3.9+（https://www.python.org/downloads/macos/）

cd "$(dirname "$0")" || exit 1

if ! command -v python3 &> /dev/null; then
    echo "错误: 未找到 python3，请先安装 Python 3.9+"
    echo "下载地址: https://www.python.org/downloads/macos/"
    read -r -p "按回车键退出..." _
    exit 1
fi

if [ ! -d ".venv" ]; then
    echo "首次运行，正在准备环境（只需一次，请稍候）..."
    python3 -m venv .venv
    .venv/bin/python -m pip install --upgrade pip
    .venv/bin/python -m pip install -r requirements.txt
    echo "环境准备完成。"
fi

exec .venv/bin/python app.py
