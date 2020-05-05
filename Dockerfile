FROM golang:1.14.2-alpine as builder
WORKDIR /root/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache gcc libc-dev git\
    && go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.cn,direct \
    && git clone https://github.com/liuzhuoling2011/BaiduPCS-Go.git \
    && cd /root/BaiduPCS-Go \
    && echo "=> start compile" \
    && GOOS=linux GOARCH=arm CGO_ENABLED=0 go build -o /root/main \
    && echo "=> compile end" \
    && cd /root \
    && go get github.com/GeertJohan/go.rice/rice \
    && echo "=> start pack static" \
    && rice append -i ./BaiduPCS-Go/internal/pcsweb --exec ./main

FROM alpine:3.11 
WORKDIR /root/
COPY --from=builder /root/main .
RUN echo "=> init file" \
    && mkdir /downloads \
    && echo "./main config set -savedir=/downloads; exec \"$@\"" > ./docker-entrypoint.sh \
    && chmod +x ./docker-entrypoint.sh
VOLUME [ "/download" ]
# ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "./main" ]
