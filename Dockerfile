FROM amazonlinux:2

RUN yum update -y && \
    yum install -y \
    aws-cli \
    jq \
    bash

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

