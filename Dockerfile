# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.22-a0dc0735-ls11

ARG BUILD_DATE
ARG VERSION=0.1.0
ARG APP_VERSION=0.1.0

LABEL build.version="Mildman1848 version: ${VERSION} Build-date: ${BUILD_DATE}"
LABEL maintainer="Mildman1848"
LABEL org.opencontainers.image.title="FOSS SmartHome Planner"
LABEL org.opencontainers.image.description="Bootstrap image for the FOSS SmartHome Planner project."
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.authors="Mildman1848"
LABEL org.opencontainers.image.url="https://github.com/mildman1848/FOSS-SmartHome-Planner"
LABEL org.opencontainers.image.documentation="https://github.com/mildman1848/FOSS-SmartHome-Planner/blob/main/README.md"
LABEL org.opencontainers.image.source="https://github.com/mildman1848/FOSS-SmartHome-Planner"
LABEL org.opencontainers.image.vendor="Mildman1848"
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"

ENV APP_NAME="foss-smarthome-planner" \
    APP_PORT="3000" \
    APP_ROOT="/app" \
    APP_CONFIG_DIR="/config/foss-smarthome-planner" \
    APP_DATA_DIR="/data" \
    APP_LOG_DIR="/config/logs" \
    APP_VERSION="${APP_VERSION}" \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME="0"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache bash python3 && \
  mkdir -p /app /defaults /config /data /run/foss-smarthome-planner

COPY app/ /app/
COPY defaults/ /defaults/
COPY root/ /

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget -q -O /dev/null "http://127.0.0.1:${APP_PORT}/" || exit 1

VOLUME ["/config", "/data"]
