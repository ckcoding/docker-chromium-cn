# Docker Chromium 中文版部署手册

> 适用于本仓库当前优化版本（`ckcode/chromium-cn:latest`）

## 1. 已优化内容（本次版本）

### 登录与鉴权
- 修复了 Nginx 内部鉴权被短路的问题，避免未授权直接进入页面。
- 默认启用自定义登录页（非浏览器原生 Basic Auth 弹窗）。
- 登录页改为**仅输入密码**，用户名固定与 `CUSTOM_USER` 对应。
- 新增 `/auth` 独立鉴权接口，错误密码返回 `401`，成功返回 `200`。

### 中文体验
- Selkies UI 默认语言调整为中文（`zh`）。
- 登录页新增语言切换（中文 / English），并持久化到 `localStorage`。
- 登录成功会携带 `?lang=` 参数，确保会话内语言一致。
- WebSocket / WebRTC 模式下系统提示（如 *Play Stream*、*Waiting for stream*、连接状态提示）已支持中文。

### 运行与构建
- 镜像构建上下文已优化（`.dockerignore`），减少无关文件进入 build context。
- 保留 x86_64 / ARM64 两套 Dockerfile，并统一中文环境配置。

---

## 2. 部署方式

## 2.1 方式 A：直接拉取 Docker Hub 镜像（推荐）

```bash
docker pull ckcode/chromium-cn:latest

docker run -d \
  --name chromium-cn \
  --security-opt seccomp=unconfined \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e CUSTOM_USER=user \
  -e PASSWORD='请改成强密码' \
  -e TITLE='Chromium 浏览器' \
  -e LC_ALL=zh_CN.UTF-8 \
  -e LANG=zh_CN.UTF-8 \
  -e LANGUAGE=zh_CN:zh \
  -e SELKIES_UI_TITLE='Chromium 浏览器' \
  -p 1234:3000 \
  -p 1235:3001 \
  -v $(pwd)/config:/config \
  --restart unless-stopped \
  ckcode/chromium-cn:latest
```

## 2.2 方式 B：本仓库 Docker Compose 部署

```bash
git clone <你的仓库地址>
cd docker-chromium-cn

docker compose up -d --build
```

默认端口：
- HTTP: `1234`
- HTTPS: `1235`

---

## 3. 首次访问与登录

访问：
- `http://<服务器IP>:1234`
- `https://<服务器IP>:1235`

默认凭据（按 `docker-compose.yml`）：
- 用户名：`user`
- 密码：`password`

> 建议上线前立即修改 `PASSWORD`。

---

## 4. 运维命令

```bash
# 查看状态
docker compose ps

# 查看日志
docker logs -f chromium-cn

# 重启
docker compose restart

# 停止并删除容器
docker compose down
```

---

## 5. 镜像发布流程（维护者）

```bash
# 1) 登录 Docker Hub
docker login

# 2) 构建镜像
docker compose build

# 3) 打 tag 并推送
docker tag docker-chromium-cn-chromium-cn:latest ckcode/chromium-cn:latest
docker push ckcode/chromium-cn:latest
```

推送成功后会看到类似输出：
```text
latest: digest: sha256:... size: ...
```

---

## 6. 常见问题排查

### Q1: 访问 HTTPS 没看到登录页
- 先强制刷新（Chrome: `Cmd+Shift+R`）。
- 清理当前站点 Cookie（可能残留 `auth`）。
- 查看容器日志确认 Nginx/鉴权状态：`docker logs chromium-cn`。

### Q2: 显示英文而不是中文
- 登录页将语言切到“中文（默认）”，重新登录。
- 或访问时带参数：`?lang=zh`。
- 清理浏览器缓存后重试。

### Q3: `docker push` 频繁 `EOF` / `connection reset`
- 属于到 Docker Hub 的网络抖动，重试即可断点续传。
- 建议在网络稳定时段执行，或配合代理网络。
