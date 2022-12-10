# syntax = docker/dockerfile:1.4.3
FROM golang:1.19-alpine3.17

RUN apk add --no-cache git

RUN <<EOF
go env -w GO111MODULE=off
go get golang.org/x/crypto/pbkdf2
EOF
