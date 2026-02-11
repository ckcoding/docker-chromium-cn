# Docker Chromium 中文版

基于 LinuxServer Chromium + Selkies 的中文远程浏览器镜像，默认中文界面，支持密码登录页（仅输入密码）。

- 镜像：`ckcode/chromium-cn:latest`
- 架构：`amd64` / `arm64`
- 默认端口：`1234`(HTTP) / `1235`(HTTPS)

## 快速开始

### 方式 1：直接运行（推荐）

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
  -e SELKIES_UI_TITLE='Chromium 浏览器' \
  -p 1234:3000 \
  -p 1235:3001 \
  -v $(pwd)/config:/config \
  --restart unless-stopped \
  ckcode/chromium-cn:latest
```

### 方式 2：Docker Compose

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
      - SELKIES_UI_TITLE=Chromium 浏览器
    volumes:
      - ./config:/config
    ports:
      - "1234:3000"
      - "1235:3001"
    restart: unless-stopped
```

```bash
docker compose up -d
```

## 访问与登录

- HTTP：`http://<服务器IP>:1234`
- HTTPS：`https://<服务器IP>:1235`
- 默认用户名：`user`
- 默认密码：`password`

> 登录页只需要输入密码（用户名固定使用 `CUSTOM_USER`）。

## 语言说明

- 默认中文。
- 登录页可切换中英文，并记住偏好。
- Selkies 系统提示（如播放、等待连接）已支持中文。

## 完整 Docker 手册

详细部署步骤、参数说明、运维命令见：[`DOCKER.md`](DOCKER.md)
