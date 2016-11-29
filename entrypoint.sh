#!/usr/bin/env sh
#########################################################
# Valeriy Solovyov <weldpua2008@gmail.com> 2016(C)
#########################################################
set -eo pipefail

# if command starts with an option, prepend hugo
if [ "${1:0:1}" = '-' ]; then
	set -- hugo "$@"
# when the site is redistributed as git repo
elif  echo "${1}" |grep -Eoq "(http|https|ssh)://"  ;then
#    mkdir -p /site
    git clone $@
    exit 0
#    set -- hugo
elif [ "$1" = "example" ];then
        _SITE="/site"
        mkdir -p $_SITE || exit 1
        git clone "https://github.com/spf13/hugo.git" /tmp/hugo || exit 1
        cp -ar /tmp/hugo/examples/blog/* $_SITE || exit 1
        cd $_SITE  || exit 1
        exec hugo server -w -p 1313 --bind 0.0.0.0
fi
#[[ "x$HUGO_BASE_URL" = "x" ]] && export HUGO_BASE_URL=http://0.0.0.0:1

exec "$@"