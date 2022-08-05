# syntax=docker/dockerfile:1.3

ARG ERPNEXT_VERSION
FROM frappe/erpnext-worker:v13.27.1

USER root

ARG APP_NAME
COPY ./lifi_custom ../apps/lifi_custom

RUN --mount=type=cache,target=/root/.cache/pip \
    install-app lifi_custom

USER frappe
