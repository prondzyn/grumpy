# build stage
FROM golang:1.10-stretch AS build-env
RUN mkdir -p /go/src/github.com/prondzyn/grumpy
WORKDIR /go/src/github.com/prondzyn/grumpy
COPY  . .
RUN useradd -u 10001 webhook
RUN go get github.com/gogo/protobuf/proto
RUN go get github.com/golang/glog
RUN go get github.com/google/gofuzz
RUN go get github.com/spf13/pflag
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o grumpywebhook

FROM scratch
COPY --from=build-env /go/src/github.com/prondzyn/grumpy/grumpywebhook .
COPY --from=build-env /etc/passwd /etc/passwd
USER webhook
ENTRYPOINT ["/grumpywebhook"]