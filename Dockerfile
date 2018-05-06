FROM golang:1.10-alpine
ARG VERSION=v0.5
RUN apk add --no-cache git 
RUN apk add --update openssl
WORKDIR /go/src/github.com/fclairamb/ftpserver
RUN wget https://github.com/fclairamb/ftpserver/archive/${VERSION}.tar.gz
RUN tar -xvf ${VERSION}.tar.gz --strip 1
RUN go get ./...
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o ftpserver .

FROM hasholding/alpine-base
LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"

VOLUME /shared 

ENV FTP_CFG "/etc/ftpserver/settings.toml"
ENV FTP_ROOT "/"

COPY /bin /bin
COPY /etc /etc
COPY --from=0 /go/src/github.com/fclairamb/ftpserver/ftpserver /bin/ftpserver

EXPOSE 21 
ENTRYPOINT ["/bin/entrypoint.sh"]