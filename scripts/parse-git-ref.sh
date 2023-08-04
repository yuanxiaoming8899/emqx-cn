#!/usr/bin/env bash

set -euo pipefail

# $1 is fully qualified git ref name, e.g. refs/tags/v5.1.0 or refs/heads/master

is_latest() {
    ref_name=$(basename "$1")
    latest_ref_name=$(git describe --tags "$(git rev-list --tags --max-count=1)")
    if [[ "$ref_name" == "$latest_ref_name" ]]; then
        echo true;
    else
        echo false;
    fi
}

if [[ $1 =~ ^refs/tags/v[5-9]+\.[0-9]+\.[0-9]+$ ]]; then
    PROFILE=emqx
    EDITION=Opensource
    RELEASE=true
    LATEST=$(is_latest "$1")
elif [[ $1 =~ ^refs/tags/v[5-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    PROFILE=emqx
    EDITION=Opensource
    RELEASE=true
    LATEST=$(is_latest "$1")
elif [[ $1 =~ ^refs/tags/e[5-9]+\.[0-9]+\.[0-9]+$ ]]; then
    PROFILE=emqx-enterprise
    EDITION=Enterprise
    RELEASE=true
    LATEST=$(is_latest "$1")
elif [[ $1 =~ ^refs/tags/e[5-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    PROFILE=emqx-enterprise
    EDITION=Enterprise
    RELEASE=true
    LATEST=$(is_latest "$1")
elif [[ $1 =~ ^refs/tags/v[5-9]+\.[0-9]+\.[0-9]+-(alpha|beta|rc)\.[0-9]+$ ]]; then
    PROFILE=emqx
    EDITION=Opensource
    RELEASE=true
    LATEST=false
elif [[ $1 =~ ^refs/tags/e[5-9]+\.[0-9]+\.[0-9]+-(alpha|beta|rc)\.[0-9]+$ ]]; then
    PROFILE=emqx-enterprise
    EDITION=Enterprise
    RELEASE=true
    LATEST=false
elif [[ $1 =~ ^refs/tags/.+ ]]; then
    echo "Unrecognized tag: $1"
    exit 1
elif [[ $1 =~ ^refs/heads/master$ ]]; then
    PROFILE=emqx
    EDITION=Opensource
    RELEASE=false
    LATEST=false
elif [[ $1 =~ ^refs/heads/release-[5-9][0-9]+$ ]]; then
    PROFILE=emqx-enterprise
    EDITION=Enterprise
    RELEASE=false
    LATEST=false
elif [[ $1 =~ ^refs/heads/ci/.* ]]; then
    PROFILE=emqx
    EDITION=Opensource
    RELEASE=false
    LATEST=false
else
    echo "Unrecognized git ref: $1"
    exit 1
fi

cat <<EOF
{"profile": "$PROFILE", "edition": "$EDITION", "release": $RELEASE, "latest": $LATEST}
EOF
