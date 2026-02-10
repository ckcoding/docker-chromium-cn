# Docker Chromium 中文版

基于 [LinuxServer.io Chromium](https://github.com/linuxserver/docker-chromium) 镜像，使用 [Selkies](https://github.com/selkies-project/selkies) WebRTC 技术提供高性能远程浏览器体验。

**完整中文汉化**，支持 x86_64 和 ARM64 架构。

## ✨ 特性

- 🌐 **Web 界面完全中文化** — Selkies Dashboard 侧边栏、设置项全部中文显示
- 🖥️ **Chromium 中文界面** — 浏览器启动即为中文语言
- 🔤 **中文字体齐全** — 预装 Noto CJK、文泉驿等多款中文字体
- ⌨️ **中文输入法支持** — 内置 IBus 拼音输入法
- 🎨 **精美登录页** — 自定义中文登录页面（可选）
- 🚀 **高性能** — 基于 WebRTC，低延迟远程桌面
- 📱 **多设备** — 手机、平板、电脑均可访问
- 🏗️ **多架构** — 支持 x86_64 / ARM64 (aarch64)

## 📸 截图

部署后打开浏览器访问 `http://你的IP:3000` 即可看到完整中文界面。

## 🚀 快速开始

### 使用 Docker Compose（推荐）

```bash
git clone https://github.com/你的用户名/docker-chromium-cn.git
cd docker-chromium-cn
docker compose up -d
```

### 使用 Docker Run

```bash
docker run -d \
  --name=chromium-cn \
  --security-opt seccomp=unconfined \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e CUSTOM_USER=user \
  -e PASSWORD=password \
  -e TITLE="Chromium 浏览器" \
  -e LC_ALL=zh_CN.UTF-8 \
  -e LANG=zh_CN.UTF-8 \
  -e LANGUAGE=zh_CN:zh \
  -p 3000:3000 \
  -p 3001:3001 \
  -v /path/to/config:/config \
  -v /dev/shm:/dev/shm \
  --restart unless-stopped \
  ghcr.io/你的用户名/chromium-cn:latest
```

### 访问

- **Web 界面**: `http://你的IP:1234`
- **HTTPS 界面**: `https://你的IP:1235`
- **默认用户名**: `user`
- **默认密码**: `password`

## ⚙️ 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `PUID` | 用户 ID | `1000` |
| `PGID` | 用户组 ID | `1000` |
| `TZ` | 时区 | `Asia/Shanghai` |
| `CUSTOM_USER` | 登录用户名 | `abc` |
| `PASSWORD` | 登录密码 | 随机生成 |
| `TITLE` | 页面标题 | `Chromium` |
| `LC_ALL` | 系统语言 | `zh_CN.UTF-8` |
| `CHROME_CLI` | Chromium 额外启动参数 | - |
| `SELKIES_ENCODER` | 视频编码器 | `jpeg,nvh264enc,vah264enc,x264enc` |
| `SELKIES_FRAMERATE` | 帧率范围 | `30-60` |
| `SELKIES_QUALITY` | 画质 (1-100) | `60` |
| `SELKIES_UI_TITLE` | 界面标题 | `Chromium` |

### Selkies UI 显示控制

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `SELKIES_UI_SHOW_SIDEBAR` | 显示侧边栏 | `True` |
| `SELKIES_UI_SIDEBAR_SHOW_VIDEO_SETTINGS` | 显示视频设置 | `True` |
| `SELKIES_UI_SIDEBAR_SHOW_SCREEN_SETTINGS` | 显示屏幕设置 | `True` |
| `SELKIES_UI_SIDEBAR_SHOW_AUDIO_SETTINGS` | 显示音频设置 | `True` |
| `SELKIES_UI_SIDEBAR_SHOW_STATS` | 显示统计信息 | `True` |
| `SELKIES_UI_SIDEBAR_SHOW_CLIPBOARD` | 显示剪贴板 | `True` |
| `SELKIES_UI_SIDEBAR_SHOW_FILES` | 显示文件管理 | `True` |

## 🌐 汉化范围

### ✅ 已汉化

| 组件 | 说明 |
|------|------|
| **Selkies Web 界面** | Dashboard 侧边栏、设置面板、按钮提示、通知消息等，基于内置 `zh` 翻译（自动检测浏览器语言） |
| **Chromium 浏览器** | 通过 `--lang=zh-CN` 参数启动，界面为中文 |
| **系统桌面** | 通过 `LC_ALL=zh_CN.UTF-8` 设置系统语言 |
| **右键菜单** | 桌面右键菜单（终端、浏览器）已翻译为中文 |
| **字体支持** | 预装 Noto CJK / 文泉驿等中文字体，确保中文正常显示 |
| **输入法** | IBus 拼音输入法 |

### ℹ️ 说明

- **登录对话框**: 默认使用浏览器原生的 HTTP Basic Auth 弹窗（由浏览器自身决定语言），项目中包含了一个精美的自定义中文登录页 `login.html` 可选使用
- **Selkies 界面语言**: 自动根据浏览器语言设置切换。如果你的浏览器设置为中文，Web 界面将自动显示中文

## 🏗️ 自行构建

```bash
# x86_64
docker build -t chromium-cn -f Dockerfile .

# ARM64 (aarch64)
docker build -t chromium-cn -f Dockerfile.aarch64 .

# 多架构构建
docker buildx build --platform linux/amd64,linux/arm64 -t chromium-cn .
```

## 📂 文件结构

```
docker-chromium-cn/
├── Dockerfile                 # x86_64 构建文件
├── Dockerfile.aarch64         # ARM64 构建文件
├── docker-compose.yml         # Docker Compose 配置
├── README.md                  # 项目说明
└── root/
    ├── defaults/
    │   ├── autostart           # X11 自动启动脚本
    │   ├── autostart_wayland   # Wayland 自动启动脚本
    │   ├── menu.xml            # X11 右键菜单（中文）
    │   └── menu_wayland.xml    # Wayland 右键菜单（中文）
    └── usr/
        ├── bin/
        │   └── wrapped-chromium     # Chromium 启动包装（含中文参数）
        └── share/selkies/www/
            └── login.html           # 自定义中文登录页（可选）
```

## 🙏 致谢

- [LinuxServer.io](https://www.linuxserver.io/) - 提供优秀的 Docker 基础镜像
- [Selkies Project](https://github.com/selkies-project/selkies) - 高性能 WebRTC 远程桌面框架
- [Chromium](https://www.chromium.org/) - 开源浏览器

## 📄 许可证

本项目遵循 [GPL-3.0](LICENSE) 许可证。
