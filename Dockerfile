FROM alpine:3.4
MAINTAINER Valeriy Solovyov <weldpua2008@gmail.com>

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
    echo "Installed dependencies"  && \
    set -x && \
    export GITHUB_REPO="gohugoio/hugo" && \
    export LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/$GITHUB_REPO/releases/latest)  && \
    export LATEST_VERSION=$(echo $LATEST_RELEASE |  sed -e $'s/,"/,\\\n"/g'|grep tag_name| sed -e 's/.*"tag_name":"\(.*\)".*/\1/')  && \
    export ARTIFACT_FILENAME="hugo_${LATEST_VERSION//v}_Linux-64bit.tar.gz" && \
    export ARTIFACT_URL="https://github.com/$GITHUB_REPO/releases/download/$LATEST_VERSION/$ARTIFACT_FILENAME"  && \
    curl -L $ARTIFACT_URL | tar xvz -C /tmp && \
    mv /tmp/hugo_*/hugo_* /usr/local/bin/hugo && \
    rm -rf /tmp/hugo_* && \
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
