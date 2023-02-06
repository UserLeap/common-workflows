#!/usr/env/bin bash

set -e

readonly ACTION="$1"
readonly GH_TOKEN="$2"
readonly TAG_NAME="$3"
readonly RELEASE_URL="$4"
if [[ -z "$GH_TOKEN" ]] || [[ -z "$ACTION" ]] || [[ -z "$TAG_NAME" ]] || [[ -z "$RELEASE_URL" ]]; then
    echo "The action, access token, tag or api release url name was not set"
    exit 1
fi

tag() {
    git tag "$TAG_NAME"
    git push origin "$TAG_NAME"
}

generate_release_payload() {
    cat << EOF
{
    "tag_name":"$TAG_NAME",
    "name":"$TAG_NAME",
    "draft":false,
    "prerelease":false,
    "generate_release_notes":true
}
EOF
}

release() {
    curl \
        -X POST \
        -H "Accept: application/vnd.github.v3+json" \
        -H "Authorization: token $GH_TOKEN" \
        -d "$(generate_release_payload)" \
        $RELEASE_URL
}

main() {
    if [[ "$1" = "tag" ]]; then
        tag
    elif [[ "$1" = "release" ]]; then
        release
    else
        echo "Error: Action $1 not recognized"
        exit 1
    fi
    exit 0
}
main "$ACTION"