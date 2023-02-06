#!/usr/env/bin bash

set -e

readonly TAG_NAME="$1"
if [[ -z "$TAG_NAME" ]]; then
    echo "The tag was not set"
    exit 1
fi

tag() {
    git tag "$TAG_NAME"
    git push origin "$TAG_NAME"
}

main() {
    tag
    exit 0
}
main
