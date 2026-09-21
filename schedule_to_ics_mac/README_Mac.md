# 排班表转ICS（Mac 版）

将固定格式的排班 Excel 表格，批量转换为每人独立的 `.ics` 日历文件，可直接导入手机日历、Outlook、Google Calendar。

本文件夹是**专为 macOS 适配的版本**，可在 Mac 上以两种方式使用：

| 方式 | 适合场景 | 产物 |
|------|---------|------|
| **打包成 App**（推荐） | 长期使用，双击即用，无需装 Python | `dist/ScheduleToICS.app` |
| **脚本直接运行** | 快速试用 | 终端窗口运行 |

---

## 方式一：打包成独立 App（推荐）

### 前置要求
- macOS 10.15 或更高版本（Apple 芯片 / Intel 均可）
- Python 3.9+：从 <https://www.python.org/downloads/macos/> 下载官方安装包
  （官方安装包自带 tkinter，这是图形界面必需组件）

### 打包步骤
1. 把这个 `schedule_to_ics_mac` 文件夹拷贝到 Mac 上（任意位置均可）。
2. 打开「终端」，进入文件夹并执行：
   ```bash
   cd /path/to/schedule_to_ics_mac
   bash build_mac.sh
   ```
3. 脚本会自动完成：检查环境 → 创建独立虚拟环境并装依赖 → 生成应用图标 → 打包 `.app`，
   完成后自动打开 `dist/` 文件夹。
4. 将 `ScheduleToICS.app` 拖到「应用程序」文件夹即可长期使用。

> **App 名称说明**：打包生成的内部名称是 `ScheduleToICS.app`（保证 macOS 兼容性），
> 但打开后窗口标题、程序坞中显示的均为中文「排班表转ICS」。
> 如果你更希望文件名也是中文，直接把它重命名为 `排班表转ICS.app` 即可，不影响使用。

> **首次打开提示**：本 App 未经过 Apple 公证，若 macOS 提示「无法打开，因为无法验证开发者」，
> 右键点击 App → 选择「打开」→ 在弹窗中再次点击「打开」，之后即可正常双击启动。

## 方式一.5：没有 Mac？用 GitHub Actions 云构建（免费）

如果你身边没有 Mac 电脑，可以把项目传到 GitHub，由 GitHub 的**免费 macOS 云服务器**自动打包出 `.app`，直接下载使用。产物是 **universal2 双架构**（Intel 和 Apple Silicon 的 Mac 都能跑）。

### 步骤
1. 注册/登录 GitHub（<https://github.com>），右上角 **New repository** 新建一个空仓库（名字随意，如 `schedule-to-ics`，选 Public 或 Private 均可）。
2. 把本文件夹里的内容上传到仓库（任选一种）：
   - **网页上传**：仓库页面 → **Add file → Upload files**，把 `app.py`、`requirements.txt`、`ScheduleToICS.spec`、`app_icon.png`、`README_Mac.md` 全部拖进去（注意 `.github/workflows/build-macos.yml` 是隐藏文件夹，网页上传方式需要先传 `.github` 目录，麻烦的话建议用 GitHub Desktop）；
   - **GitHub Desktop**（推荐，图形界面）：<https://desktop.github.com/> 下载安装 → 登录 → File → Add Local Repository 选择本文件夹 → Publish repository → 直接推送到 GitHub。
3. 推送到 `main` 分支后会自动开始构建；或到仓库 **Actions → Build macOS App → Run workflow** 手动触发。
4. 等待几分钟，构建成功后进入 **Actions → 最新一次运行记录**，在底部 **Artifacts** 处下载 `ScheduleToICS-macOS.zip`。
5. 解压得到 `ScheduleToICS.app`，拖到「应用程序」即可使用。

> **首次打开**：从网页下载的 App 带有 macOS 隔离标记，双击可能提示「无法验证开发者」。
> 右键点击 `ScheduleToICS.app` → 选择「打开」→ 再次点击「打开」即可，之后就能正常双击启动了。

> **说明**：构建过程中会自动完成「安装 Python → 生成图标 → 在 macOS 上实测核心逻辑 → 打包 → 校验产物结构」，
> 任何一步失败都会在 Actions 日志中明确显示，可把日志链接发给我帮你排查。

## 方式二：脚本直接运行（免打包）

双击文件夹里的 `run_mac.command` 即可直接运行图形界面。
- 首次运行会自动创建虚拟环境并安装依赖（需联网，只需一次）；
- 若双击无反应，在终端执行一次 `chmod +x run_mac.command` 后重试。

---

## 使用方法

1. 打开 App（或双击 `run_mac.command`）
2. 选择排班**年份**和**月份**（班表仅含日期，填写起始年月即可；跨月自动进位）
3. 点击「选择班表Excel」，选择排班表文件（仅支持 `.xlsx`，旧版 `.xls` 请先另存为 `.xlsx`）
4. 点击「生成ICS日历」
5. 生成完成后自动打开 `ics_output` 文件夹，里面是每人的 ics 文件（以姓名拼音命名）

## 班表格式要求

固定格式，结构如下：

| 日期 | 23 | 24 | 25 | ... |
|------|----|----|----|-----|
| 姓名 | 日 | 一 | 二 | ... |
| 张三 | 晚班 | 中班 | 休息 | ... |
| 李四 | 早班 | 休息 | 晚班 | ... |

- 第1行：A1 为「日期」，B列起为日期（日）
- 第2行：A2 为「姓名」，B列起为星期
- 第3行起：A列为姓名，B列起为班次
- 底部可附班次时间说明（程序会自动跳过）

## 支持的班次

| 班次 | 时间 |
|------|------|
| 早班 | 09:30 - 17:30 |
| 早值 | 09:30 - 20:00 |
| 中班 | 13:00 - 20:00 |
| 晚班 | 15:00 - 22:00 |
| 休息 | 全天 |

## 跨月处理

- 年月选择框只需填写班表的**起始年月**（即第1列日期所在月份）
- 当第1行的日期发生**回退**（如 30、31 后出现 1、2），程序会自动进位到下个月
- 12 月跨年时也会自动进位到下一年（如 12月30、31 → 1月1、2）
- 若日期超出当月最大天数会给出明确报错提示

示例：起始年月选「2026年8月」，第1行日期为 `30, 31, 1, 2, 3, 4, 5`，则会生成 8月30、31日和 9月1-5日 的日程。

---

## 与 Windows 版的差异

Mac 版在打包方式上做了针对性优化（Windows 版不受影响）：

1. **打包模式**：从 `--onefile` 改为 **onedir 标准 .app 包**。
   tkinter 程序在 macOS 上用单文件模式打包容易出现启动失败或界面异常，.app 包结构兼容性最好、启动也更快。
2. **应用图标**：新增 `app_icon.png` 图标，打包时自动转换为 `.icns` 嵌入 App。
3. **中文显示名**：通过 Info.plist 设置，程序坞/菜单栏显示「排班表转ICS」。
4. **虚拟环境**：打包使用独立 `.venv`，不污染系统 Python，也避免与 Homebrew 等环境冲突。
5. **健壮性**：选择 `.xls` 旧格式时给出明确的中文提示（原版会直接报底层错误）。

## 文件结构

```
schedule_to_ics_mac/
├── app.py              # 主程序（GUI + 逻辑）
├── requirements.txt    # Python 依赖
├── build_mac.sh        # Mac 一键打包脚本（本机有 Mac 时用）
├── run_mac.command     # 免打包直接运行脚本（双击）
├── ScheduleToICS.spec  # PyInstaller 打包配置（universal2 双架构）
├── app_icon.png        # 应用图标源图
├── README_Mac.md       # 本说明文件
└── .github/
    └── workflows/
        └── build-macos.yml   # GitHub Actions 云构建（没有 Mac 时用）
```

## 常见问题

**Q: 打包时提示 `sips` 或 `iconutil` 找不到？**
这两个是 macOS 系统自带工具，正常不会缺失。若异常，可手动跳过图标：
删除 `app_icon.icns` 后把 `build_mac.sh` 第3步报错内容截图反馈。

**Q: 生成的 App 打开后没反应？**
在终端中直接运行包内可执行文件查看报错：
```bash
./dist/ScheduleToICS.app/Contents/MacOS/ScheduleToICS
```

**Q: 想在别的 Mac 上使用这个 App？**
把 `dist/ScheduleToICS.app` 拷贝过去即可（需 macOS 10.15+，无需安装 Python）。
