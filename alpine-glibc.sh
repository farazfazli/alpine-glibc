set -e
alias acbuild="/home/core/acbuild"
trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT
acbuild --debug begin
acbuild --debug set-name farazfazli.com/alpine-glibc
acbuild --debug dependency add quay.io/coreos/alpine-sh
GLIBC_VERSION=2.23-r3
acbuild --debug run -- apk add --update curl
acbuild --debug run -- curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub
acbuild --debug run -- curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk"
acbuild --debug run -- apk add glibc.apk
acbuild --debug run -- curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk"
acbuild --debug run -- apk add glibc-bin.apk
acbuild --debug run -- /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib
acbuild --debug copy-to-dir nsswitch.conf /etc
acbuild --debug run -- apk del curl
acbuild --debug run -- rm -rf glibc.apk glibc-bin.apk /var/cache/apk/*
acbuild --debug write --overwrite cockroach.aci
acbuild --debug end
