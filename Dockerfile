FROM golang:1.14.2-alpine as builder
WORKDIR /root/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache gcc libc-dev git\
    && export PATH=/root/go/bin:$PATH \
    && go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.cn,direct \
    && git clone https://github.com/liuzhuoling2011/BaiduPCS-Go.git \
    && cd /root/BaiduPCS-Go \
    && GOOS=linux GOARCH=arm CGO_ENABLED=0 go build -o /root/main \
    && cd /root \
    && go get github.com/GeertJohan/go.rice/rice \
    && rice append -i ./BaiduPCS-Go/internal/pcsweb --exec ./main

FROM alpine:3.11 
WORKDIR /root/
COPY --from=builder /root/main .
RUN mkdir /downloads \
    && ./main config set -savedir=/downloads
VOLUME [ "/download" ]
ENTRYPOINT [ "./main" ]
