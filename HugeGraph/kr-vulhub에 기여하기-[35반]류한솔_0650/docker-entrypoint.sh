#!/usr/bin/env bash
set -Eeuo pipefail

: "${PASSWORD:?PASSWORD must be set to enable HugeGraph authentication}"

cd "${HUGEGRAPH_HOME}"

INIT_FLAG="${HUGEGRAPH_HOME}/.lab-init-complete"
if [[ ! -f "${INIT_FLAG}" ]]; then
    # HugeGraph 1.3.0's official helper enables StandardAuthenticator and changes
    # the graph factory to HugeFactoryAuthProxy. auth.token_secret is intentionally
    # not written, so the vulnerable hard-coded default remains active.
    ./bin/enable-auth.sh
    printf '%s\n' "${PASSWORD}" | \
        JAVA_TOOL_OPTIONS="--add-opens=java.base/jdk.internal.reflect=ALL-UNNAMED" \
        ./bin/init-store.sh
    touch "${INIT_FLAG}"
fi

# Run the official JVM launcher directly so Docker signals reach the JVM and
# HugeGraph's shutdown hook can clean up its server registration.
exec ./bin/hugegraph-server.sh \
    ./conf/gremlin-server.yaml \
    ./conf/rest-server.properties \
    true \
    "${JAVA_OPTS}" \
    "" \
    false
