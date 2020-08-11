FROM golang:1.13-alpine AS build

ENV CGO=1 \
    CGO_ENABLED=${CGO} \
    GOOS=linux \
    GO111MODULE=on \
    HUGO_RELEASE_TAG="v0.74.3"


# gcc/g++ are required to build SASS libraries for extended version
RUN apk update && \
    apk add --no-cache gcc g++ musl-dev git && \
    go get github.com/magefile/mage

RUN git clone --depth 1 -b ${HUGO_RELEASE_TAG:-"master"} https://github.com/gohugoio/hugo.git /go/src/github.com/gohugoio/hugo \
    && mage hugo && mage install

WORKDIR /go/src/github.com/gohugoio/hugo

FROM alpine:3.11
MAINTAINER Valeriy Solovyov <weldpua2008@gmail.com>


COPY --from=build /go/bin/hugo /usr/bin/hugo

# Bring in metadata via --build-arg
ARG BRANCH=unknown
ARG IMAGE_CREATED=unknown
ARG IMAGE_REVISION=unknown
ARG IMAGE_VERSION=unknown

# Configure image labels
LABEL \
    # https://github.com/opencontainers/image-spec/blob/master/annotations.md
    branch=$branch \
    maintainer="Valeriy Soloviov" \
    org.opencontainers.image.authors="Valeriy Soloviov" \
    org.opencontainers.image.created=$IMAGE_CREATED \
    org.opencontainers.image.description="Hugo is a static HTML and CSS website generator written in Go. It is optimized for speed, ease of use, and configurability." \
    org.opencontainers.image.documentation="https://gohugo.io/getting-started/" \
    org.opencontainers.image.licenses="Apache License 2.0" \
    org.opencontainers.image.revision=$IMAGE_REVISION \
    org.opencontainers.image.source="https://github.com/weldpua2008/docker-hugo/" \
    org.opencontainers.image.title="Hugo" \
    org.opencontainers.image.url="https://github.com/weldpua2008/docker-hugo/" \
    org.opencontainers.image.vendor="Hugo" \
    org.opencontainers.image.version=$IMAGE_VERSION

# Default image environment variable settings
ENV org.opencontainers.image.created=$IMAGE_CREATED \
    org.opencontainers.image.revision=$IMAGE_REVISION \
    org.opencontainers.image.version=$IMAGE_VERSION

RUN apk add --update curl git openssh-client  && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /site && \
    echo "Adding user & group for Hugo" && \
    addgroup -Sg 1000 hugo && \
    adduser -SG hugo -u 1000 -h /site hugo


ADD entrypoint.sh /
VOLUME /site
WORKDIR /site
#when used as a base image add the current folder to /site folder (workdir)
#ONBUILD ADD . /site

EXPOSE 1313

ENTRYPOINT ["/entrypoint.sh"]
