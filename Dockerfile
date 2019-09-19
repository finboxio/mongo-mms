FROM alpine:latest

ENV MMS_VERSION 10.4.1.5917-1

RUN adduser -S mms

WORKDIR /home/mms

RUN apk --update add curl libsasl krb5-dev ca-certificates su-exec && \
    curl -OL https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-${MMS_VERSION}.linux_x86_64.tar.gz && \
    tar --strip-components=1 -xvf mongodb-mms-automation-agent-${MMS_VERSION}.linux_x86_64.tar.gz && \
    rm mongodb-mms-automation-agent-${MMS_VERSION}.linux_x86_64.tar.gz && \
    apk del --purge curl && \
    rm -rf /var/cache/apk/* && \
    mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 && \
    ln -s /usr/lib/libsasl2.so.3 /usr/lib/libsasl2.so.2

COPY entrypoint.sh .

ENTRYPOINT [ "/home/mms/entrypoint.sh" ]

CMD [ "/home/mms/mongodb-mms-automation-agent", "-config", "local.config", "-logLevel", "warn" ]
