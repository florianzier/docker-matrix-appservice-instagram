FROM node:8-alpine

ARG USER=docker
ARG UID=1000
ARG GID=1000

WORKDIR /opt/instagram-bridge

#RUN addgroup -g ${GID} ${USER} \
#  && adduser -D -H -u ${UID} -G ${USER} ${USER}

RUN apk update \
  && apk add git \
  && git clone https://github.com/turt2live/matrix-appservice-instagram . \
  && apk del git \
  && npm install \
  && npm install --save mkdirp https://packages.matrix.org/npm/olm/olm-2.3.0.tgz \
  && npm audit fix \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/*

COPY entrypoint.sh /opt/instagram-bridge/entrypoint.sh
RUN chmod +x /opt/instagram-bridge/entrypoint.sh
RUN chown -R ${UID}:${GID} /opt/instagram-bridge/

VOLUME /data
EXPOSE 9000/tcp

USER ${UID}:${GID}

ENTRYPOINT [ "/opt/instagram-bridge/entrypoint.sh" ]
CMD [ "node", "app.js", "-p", "9000", "-c", "/data/config.yaml" ]
