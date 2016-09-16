# https://bugzilla.redhat.com/show_bug.cgi?id=1211119
# Once the above issue is resolved, we could get rid of this.
#!/bin/bash

tmpdir=$(mktemp -d)
trap "popd; rm -rf $tmpdir; exit" INT TERM EXIT
pushd $tmpdir
curl -c tmpcookie -d user_name=$1 -d password=$2 -d login=1 http://localhost/bkr/login || exit 1
curl -b tmpcookie -d fqdn=$(hostname -f) -d lusername=host/localhost.localdomain -d lpassword=password \
            -d email=root@localhost.localdomain -d Save=1 http://localhost/bkr/labcontrollers/save || exit 1
popd
rm -rf $tmpdir
trap - INT TERM EXIT
