# Stage 1: Build localized dashboard
# Use the same base image to avoid pulling new images (network issues)
FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie AS builder

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    nodejs

WORKDIR /app

# Copy dashboard source code
COPY selkies-src/addons/selkies-dashboard/package.json ./
# Install dependencies
RUN npm install

# Copy source code and build
COPY selkies-src/addons/selkies-dashboard/ ./
# Copy all core JS dependencies from gst-web-core
COPY selkies-src/addons/gst-web-core/selkies-core.js ./src/
COPY selkies-src/addons/gst-web-core/selkies-wr-core.js ./src/
COPY selkies-src/addons/gst-web-core/selkies-ws-core.js ./src/
COPY selkies-src/addons/gst-web-core/lib/ ./src/lib/
RUN npm run build

# Stage 2: Final image
FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="docker-chromium-cn version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="ckcoding"

# title
ENV TITLE=Chromium

# Chinese locale
ENV LC_ALL=zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/chromium-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    chromium \
    chromium-l10n \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    fonts-wqy-microhei \
    fonts-wqy-zenhei \
    ibus \
    ibus-pinyin && \
  echo "**** generate zh_CN locale ****" && \
  sed -i '/zh_CN.UTF-8/s/^# //g' /etc/locale.gen 2>/dev/null || true && \
  locale-gen zh_CN.UTF-8 2>/dev/null || true && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

RUN \
  echo "**** force chinese language for selkies dashboard ****" && \
  sed -i 's/navigator.language/"zh-CN"/g' /usr/share/selkies/web/assets/index-*.js 2>/dev/null || true

# Copy built localized dashboard from builder stage
# Copy built localized dashboard
COPY --from=builder /app/dist /usr/share/selkies/selkies-dashboard/

# Also attempting to update web assets if they are identical
RUN cp -r /usr/share/selkies/selkies-dashboard/assets/* /usr/share/selkies/web/assets/ || true

# add local files
COPY root/ /

# ports and volumes
EXPOSE 3000

VOLUME /config
