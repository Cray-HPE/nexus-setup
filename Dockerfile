# Copyright 2021,2025 Hewlett Packard Enterprise Development LP

FROM artifactory.algol60.net/docker.io/library/alpine

RUN apk --update upgrade --no-cache && apk add --no-cache bash curl parallel skopeo

RUN curl -sfL https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64 -o /usr/bin/yq \
    && chmod +x /usr/bin/yq

# Instead of `apk add --no-cache jq`, which pulls in 1.6-r1, directly pull in the 1.6 jq release 
# to address https://snyk.io/vuln/SNYK-ALPINE312-JQ-588886
RUN curl -sfL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/bin/jq \
    && chmod +x /usr/bin/jq

RUN mkdir -p /usr/local/share/nexus-setup/groovy
COPY ./groovy/*.groovy /usr/local/share/nexus-setup/groovy/

COPY ./bin/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*
COPY enable-signatures.yaml /etc/containers/registries.d/enable-signatures.yaml
CMD [ "nexus-ready" ]
