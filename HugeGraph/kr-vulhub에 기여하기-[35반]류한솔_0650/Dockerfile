FROM eclipse-temurin:11.0.27_6-jre-jammy@sha256:d879f3a00a47675df93ecc5239e528c8bf341e0dd86d54982644f78e643c091d

ARG HUGEGRAPH_VERSION=1.3.0
ARG HUGEGRAPH_ARCHIVE=apache-hugegraph-incubating-${HUGEGRAPH_VERSION}.tar.gz
ARG HUGEGRAPH_URL=https://archive.apache.org/dist/incubator/hugegraph/${HUGEGRAPH_VERSION}/${HUGEGRAPH_ARCHIVE}
ARG HUGEGRAPH_SHA512=b85e60f8215aee12bec67c8f1d4666a2928e0d430858b3054cbd65857741aa05b85331f92d1d6af8abdea489aeee9bed85038ab27f68f6c9130ac68cd7e0f2fa

ENV HUGEGRAPH_HOME=/opt/hugegraph \
    JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dumb-init \
        lsof \
        procps \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p "${HUGEGRAPH_HOME}" \
    && curl --fail --location --retry 3 \
        --output "/tmp/${HUGEGRAPH_ARCHIVE}" "${HUGEGRAPH_URL}" \
    && echo "${HUGEGRAPH_SHA512}  /tmp/${HUGEGRAPH_ARCHIVE}" | sha512sum --check - \
    && tar --extract --gzip \
        --file "/tmp/${HUGEGRAPH_ARCHIVE}" \
        --directory "${HUGEGRAPH_HOME}" \
        --strip-components=1 \
    && rm "/tmp/${HUGEGRAPH_ARCHIVE}" \
    && sed -i \
        's|^restserver.url=.*|restserver.url=http://0.0.0.0:8080|' \
        "${HUGEGRAPH_HOME}/conf/rest-server.properties"

WORKDIR ${HUGEGRAPH_HOME}

COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=5s --start-period=90s --retries=12 \
    CMD curl --fail --silent --show-error \
        --user "admin:${PASSWORD}" \
        http://127.0.0.1:8080/graphs >/dev/null || exit 1

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/docker-entrypoint.sh"]
