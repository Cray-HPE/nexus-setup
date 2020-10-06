# Copyright 2020 Hewlett Packard Enterprise Development LP

FROM alpine

RUN apk add --no-cache bash curl jq parallel

RUN curl -sfL https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 -o /usr/bin/yq \
    && chmod +x /usr/bin/yq

RUN mkdir -p /usr/local/share/nexus-setup/groovy
COPY ./groovy/*.groovy /usr/local/share/nexus-setup/groovy/

COPY ./bin/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

CMD [ "nexus-ready" ]
