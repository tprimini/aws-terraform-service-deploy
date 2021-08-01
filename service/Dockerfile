FROM node:14-alpine

USER root

RUN apk add --no-cache openssl

WORKDIR /opt/simple-api

ENV CERT_FILE=/tmp/simple-api-selfsigned.crt
ENV KEY_FILE=/tmp/simple-api-selfsigned.key

COPY docker/startup.sh .
COPY node_modules ./node_modules
COPY index.js .
COPY package.json .

RUN openssl req -subj "/C=BR/ST=SP/O=org/OU=001/CN=yourdomain.com" -x509 -nodes -days 1000 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE}
RUN chmod 644 ${CERT_FILE} ${KEY_FILE}

USER nobody

ENTRYPOINT [ "/opt/simple-api/startup.sh", "run" ]
