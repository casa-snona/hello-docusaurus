FROM node:lts-alpine3.16 AS build
COPY ./my-website ./
RUN npm install
RUN npm run build

FROM nginx:1.23.2

ARG CPU_ARCH=amd64
ARG OAUTH2_PROXY_VERSION=7.4.0

RUN set -x && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y \
    supervisor wget gettext-base

RUN wget https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v${OAUTH2_PROXY_VERSION}/oauth2-proxy-v${OAUTH2_PROXY_VERSION}.linux-${CPU_ARCH}.tar.gz && \
    tar xf oauth2-proxy-v${OAUTH2_PROXY_VERSION}.linux-${CPU_ARCH}.tar.gz -C /usr/local/bin/ --strip-components 1 && \
    rm oauth2-proxy-v${OAUTH2_PROXY_VERSION}.linux-${CPU_ARCH}.tar.gz

COPY ./server-config/nginx.conf /etc/nginx/nginx.conf
COPY ./server-config/oauth2proxy.conf.template /etc/oauth2proxy.conf.template
COPY ./server-config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./startup.sh /startup.sh
COPY --from=build /build /usr/share/nginx/html

CMD [ "sh", "startup.sh" ]