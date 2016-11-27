FROM alpine:3.4

# apk add --update curl jq
# curl -L  -H 'Accept: application/json' https://api.github.com/repos/$GITHUB_REPO/releases/latest| jq '.assets[] .browser_download_url'|grep -i linux|grep -i tar.gz|grep -i '64bit'
RUN apk add --update curl  && \
    export GITHUB_REPO="spf13/hugo" && \
    export LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/$GITHUB_REPO/releases/latest)  && \
    export LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\(.*\)".*/\1/')  && \
    export ARTIFACT_FILENAME="hugo_${LATEST_VERSION//v}_Linux-64bit.tar.gz" && \
    export ARTIFACT_URL="https://github.com/$GITHUB_REPO/releases/download/$LATEST_VERSION/$ARTIFACT_FILENAME"  && \
    curl -L $ARTIFACT_URL | tar xvz -C /tmp && \
    mv /tmp/hugo_${LATEST_VERSION//v}_linux_amd64/hugo_${LATEST_VERSION//v}_linux_amd64 /usr/local/bin/hugo && \
    rm -rf /tmp/hugo_${HUGO_VERSION}_linux_amd64/
EXPOSE 8080

ENTRYPOINT ["hugo"]