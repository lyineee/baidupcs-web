FROM golang:1.14.2-alpine as builder
WORKDIR /root/
RUN apk add --no-cache gcc libc-dev git \
    && go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.cn,direct \
    && git clone https://github.com/liuzhuoling2011/BaiduPCS-Go.git \
    && cd /root/BaiduPCS-Go \
    && echo "=> start compile" \
    && GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -o /root/main \
    && echo "=> compile end" \
    && cd /root \
    && go get github.com/GeertJohan/go.rice/rice \
    && echo "=> start pack static" \
    && rice append -i ./BaiduPCS-Go/internal/pcsweb --exec ./main

FROM arm64v8/alpine:3.11
WORKDIR /root/
COPY --from=builder /root/main .
COPY ./docker-entrypoint.sh .
ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "./main" ]
