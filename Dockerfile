# build stage
FROM golang:1.12-alpine AS build-env
RUN apk add --no-cache --update alpine-sdk ca-certificates
ENV REPO_PATH=/build
COPY . $REPO_PATH
WORKDIR $REPO_PATH
RUN make build

# final stage
FROM scratch
LABEL maintainer="Daniel Martins <daniel.martins@descomplica.com.br>"
WORKDIR /app
COPY --from=build-env /build/bin/aws-limits-exporter /app/
COPY --from=build-env /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
ENTRYPOINT /app/aws-limits-exporter -logtostderr
