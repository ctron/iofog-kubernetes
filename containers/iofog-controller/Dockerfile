FROM iofog-base AS builder

#ARG PKG_VERSION

#RUN npm config set unsafe-perm true

#RUN npm i -g npm

# build the viewer first

RUN mkdir /viewer
COPY external/ECN-Viewer/ /viewer
WORKDIR /viewer
RUN npm i
RUN npm run build
RUN cp -r build package/

# now build the controller

WORKDIR /tmp

COPY external/Controller/package.json .
COPY external/Controller/package-lock.json .
COPY external/Controller/ .

RUN npm install --save /viewer/package && npm i

#RUN npm version $PKG_VERSION --allow-same-version

RUN npm pack

FROM iofog-base

# https://stackoverflow.com/questions/52196518/could-not-get-uid-gid-when-building-node-docker
# Workaround until we fix our node alpine image
# RUN npm config set unsafe-perm true

#RUN apk add -y sudo logrotate
#COPY logrotate.conf /etc/logrotate.conf

COPY --from=builder /tmp/iofogcontroller-*.tgz /tmp/iofog-controller.tgz
RUN mkdir -p viewer/package
COPY --from=builder /viewer/package viewer/package/

RUN npm i --unsafe-perm -g /tmp/iofog-controller.tgz && \
  rm -rf /tmp/iofog-controller.tgz && \
  iofog-controller config dev-mode --off

RUN rm /usr/local/lib/node_modules/iofogcontroller/node_modules/@iofog/ecn-viewer/build/controller-config.js && ln -s /etc/config/api/controller-config.js /usr/local/lib/node_modules/iofogcontroller/node_modules/@iofog/ecn-viewer/build/controller-config.js

#RUN mkdir -p /viewer/
#COPY --from=builder /viewer/ /viewer/

#ENV ECN_VIEWER_PATH=/viewer

CMD [ "node", "/usr/local/lib/node_modules/iofogcontroller/src/server.js" ]
