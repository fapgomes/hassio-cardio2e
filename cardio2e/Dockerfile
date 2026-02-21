ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN apk add --no-cache jq \
    && pip3 install --no-cache-dir pyserial paho-mqtt

# BUILD_VERSION is passed by HA - busts cache when version changes
ARG BUILD_VERSION
RUN apk add --no-cache git \
    && git clone https://github.com/fapgomes/cardio2e.git /app \
    && apk del git

COPY run.sh /

RUN chmod a+x /run.sh

CMD ["/run.sh"]
