ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN apk add --no-cache git jq \
    && pip3 install --no-cache-dir pyserial paho-mqtt \
    && git clone https://github.com/fapgomes/cardio2e.git /app \
    && apk del git

COPY run.sh /

RUN chmod a+x /run.sh

CMD ["/run.sh"]
