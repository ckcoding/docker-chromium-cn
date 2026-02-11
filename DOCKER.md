# Docker 部署手册（ckcode/chromium-cn）

## 1. 镜像信息

- 镜像地址：`ckcode/chromium-cn:latest`
- 支持架构：`linux/amd64`、`linux/arm64`
- 容器端口：`3000`(HTTP)、`3001`(HTTPS)

## 2. 部署前准备

- Docker 版本建议 `>= 24`
- 主机放通端口：`1234`、`1235`（可自定义映射）
- 建议准备持久化目录：`./config`

---

## 3. 一键部署（docker run）

```bash
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
  -e SELKIES_ENCODER=jpeg,nvh264enc,vah264enc,x264enc \
  -e SELKIES_FRAMERATE=30-60 \
  -e SELKIES_QUALITY=60 \
  -e SELKIES_UI_TITLE='Chromium 浏览器' \
  -p 1234:3000 \
  -p 1235:3001 \
  -v $(pwd)/config:/config \
  --restart unless-stopped \
  ckcode/chromium-cn:latest
```

---

## 4. Compose 部署

```yaml
services:
  chromium-cn:
    image: ckcode/chromium-cn:latest
    container_name: chromium-cn
    shm_size: "1gb"
    security_opt:
      - seccomp:unconfined
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
      - CUSTOM_USER=user
      - PASSWORD=请改成强密码
      - TITLE=Chromium 浏览器
      - LC_ALL=zh_CN.UTF-8
      - LANG=zh_CN.UTF-8
      - LANGUAGE=zh_CN:zh
      - SELKIES_ENCODER=jpeg,nvh264enc,vah264enc,x264enc
      - SELKIES_FRAMERATE=30-60
      - SELKIES_QUALITY=60
      - SELKIES_UI_TITLE=Chromium 浏览器
    volumes:
      - ./config:/config
    ports:
      - "1234:3000"
      - "1235:3001"
    restart: unless-stopped
```

启动：

```bash
docker compose up -d
```

---

## 5. 参数说明

| 变量 | 说明 | 示例/默认 |
|---|---|---|
| `PUID` | 容器运行用户 ID | `1000` |
| `PGID` | 容器运行组 ID | `1000` |
| `TZ` | 时区 | `Asia/Shanghai` |
| `CUSTOM_USER` | 固定登录用户名 | `user` |
| `PASSWORD` | 登录密码（务必修改） | `password` |
| `TITLE` | 页面标题 | `Chromium 浏览器` |
| `LC_ALL` | 系统 locale | `zh_CN.UTF-8` |
| `LANG` | 语言 locale | `zh_CN.UTF-8` |
| `LANGUAGE` | 语言链 | `zh_CN:zh` |
| `SELKIES_ENCODER` | 可用编码器优先级 | `jpeg,nvh264enc,vah264enc,x264enc` |
| `SELKIES_FRAMERATE` | 帧率范围 | `30-60` |
| `SELKIES_QUALITY` | 画质（1-100） | `60` |
| `SELKIES_UI_TITLE` | Selkies 侧栏标题 | `Chromium 浏览器` |

---

## 6. 访问方式

- `http://<服务器IP>:1234`
- `https://<服务器IP>:1235`

默认凭据：
- 用户名：`user`
- 密码：`password`

> 登录页为自定义页面，只输入密码，用户名由服务端固定。

---

## 7. 常用运维命令

```bash
# 查看状态
docker ps --filter name=chromium-cn

# 查看日志
docker logs -f chromium-cn

# 重启
docker restart chromium-cn

# 停止并删除
docker rm -f chromium-cn

# 更新镜像
# 1) 拉取新镜像
# 2) 删除旧容器
# 3) 按原参数重新 run / compose up -d
```

---

## 8. 常见问题

### 1) 打开后未出现登录页
- 强制刷新浏览器缓存（Chrome: `Cmd+Shift+R`）。
- 清理站点 Cookie（可能保留 `auth`）。

### 2) 显示英文而不是中文
- 登录页切换语言为中文。
- 或访问时添加参数：`?lang=zh`。

### 3) 视频流不流畅
- 降低 `SELKIES_FRAMERATE`。
- 降低 `SELKIES_QUALITY`。
- 确认宿主机 CPU/网络资源。
