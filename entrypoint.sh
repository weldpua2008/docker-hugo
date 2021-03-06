#!/usr/bin/env sh
#########################################################
# Valeriy Solovyov <weldpua2008@gmail.com> 2016-2020(C)
#########################################################
set -eo pipefail

#remove possibly existing site
[ -d /site/public/ ] && rm -rf /site/public/*


# when the site is redistributed as git repo
if  echo "${1}" |grep -Eoq "(http|https|ssh)://"  ;then
#    mkdir -p /site
    git clone $@
fi

# if command starts with an option, prepend hugo
if [ "${1:0:1}" = '-' ]; then
    set -- hugo "$@"
elif [ "$1" = "example" ];then
        _SITE="/site"
        mkdir -p $_SITE || exit 1
        git clone "https://github.com/spf13/hugo.git" /tmp/hugo || exit 1
        cp -ar /tmp/hugo/examples/blog/* $_SITE || exit 1
        cd $_SITE  || exit 1
        echo "running: hugo server -w -p 1313 --bind 0.0.0.0"
        exec hugo server -w -p 1313 --bind 0.0.0.0
        exit $?
#   execute any other executable if exists
elif which "$1"  2> /dev/null && [[ "$1" != "hugo" ]] ; then
    exec $@
    exit $?
fi

if  ! echo "$@" |grep -Eoq "\-\-watch";then
    if [[ ${HUGO_WATCH:=false} != 'false' ]]; then
        echo "HUGO_WATCH: ${HUGO_WATCH:=false}"
        set -- $@ --watch=true
    fi
fi

if  ! echo "$@" |grep -Eoq "\-\-baseUrl";then
    if [[ "x${HUGO_BASEURL:-}" != 'x' ]]; then
        echo "HUGO_BASEURL: ${HUGO_BASEURL:-}"
        set -- $@ --baseUrl="$HUGO_BASEURL"
    fi
fi

if  ! echo "$@" |grep -Eoq "\-\-theme";then
    if [[ "x${HUGO_THEME:-}" != 'x' ]]; then
        echo "HUGO_THEME: ${HUGO_THEME:-}"
        set -- $@ --theme="$HUGO_THEME"
    fi
fi

if  ! echo "$@" |grep -Eoq "\-\-bind";then
    if [[ "x${HUGO_BIND_ADDRESS:-0.0.0.0}" != 'x' ]]; then
        echo "HUGO_THEME: ${HUGO_BIND_ADDRESS:-0.0.0.0}"
        set -- $@ --bind="${HUGO_BIND_ADDRESS:-0.0.0.0}"
    fi
fi

echo running: "$@"
exec $@
