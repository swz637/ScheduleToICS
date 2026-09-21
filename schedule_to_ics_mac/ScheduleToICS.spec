# -*- mode: python ; coding: utf-8 -*-
# ── 排班表转ICS macOS 打包配置 ──
# 使用 onedir 模式生成标准 .app 包（对 tkinter 兼容性最好、启动最快）
# 由 build_mac.sh 调用，无需手动执行本文件。
#
# 说明：
#   - 内部名称用 ASCII 的 ScheduleToICS，避免非 ASCII 可执行名在 macOS 上的兼容问题；
#   - 通过 Info.plist 把 Finder / 菜单栏显示名设置为中文「排班表转ICS」。
#   - 如需中文文件名，打包完成后可把 ScheduleToICS.app 重命名为 排班表转ICS.app。

a = Analysis(
    ['app.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=['pypinyin', 'openpyxl'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='ScheduleToICS',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch='universal2',
    codesign_identity=None,
    entitlements_file=None,
)

coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=False,
    upx_exclude=[],
    name='ScheduleToICS',
)

app = BUNDLE(
    coll,
    name='ScheduleToICS.app',
    icon='app_icon.icns',
    bundle_identifier='com.schedule2ics.app',
    info_plist={
        'CFBundleName': '排班表转ICS',
        'CFBundleDisplayName': '排班表转ICS',
        'CFBundleShortVersionString': '1.0',
        'CFBundleVersion': '1.0',
        'CFBundlePackageType': 'APPL',
        'NSHighResolutionCapable': True,
        'LSMinimumSystemVersion': '10.15',
        'NSHumanReadableCopyright': '排班表转ICS 日历工具',
    },
)
