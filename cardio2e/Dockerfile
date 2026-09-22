ARG BUILD_ARCH
FROM ghcr.io/home-assistant/${BUILD_ARCH}-base-python:3.12-alpine3.20

# cardio2e release tag to ship; bumped by the bump-addon workflow of
# github.com/fapgomes/cardio2e on every release.
ARG CARDIO2E_VERSION="v2.4.2"

RUN apk add --no-cache jq \
    && pip3 install --no-cache-dir pyserial paho-mqtt

RUN test -n "${CARDIO2E_VERSION}" \
    && apk add --no-cache git \
    && git clone --depth 1 --branch "${CARDIO2E_VERSION}" https://github.com/fapgomes/cardio2e.git /app \
    && apk del git

COPY run.sh /

RUN chmod a+x /run.sh

CMD ["/run.sh"]
