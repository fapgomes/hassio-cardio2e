ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN apk add --no-cache jq \
    && pip3 install --no-cache-dir pyserial paho-mqtt

# Bust Docker cache when cardio2e repo has new commits
ADD https://api.github.com/repos/fapgomes/cardio2e/git/refs/heads/main /tmp/cardio2e_version.json
RUN apk add --no-cache git \
    && git clone https://github.com/fapgomes/cardio2e.git /app \
    && apk del git

COPY run.sh /

RUN chmod a+x /run.sh

CMD ["/run.sh"]
