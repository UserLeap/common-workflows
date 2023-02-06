
set -e

readonly GH_TOKEN="$1"
readonly TAG_NAME="$2"
readonly RELEASE_URL="$3"
if [[ -z "$GH_TOKEN" ]] || [[ -z "$TAG_NAME" ]] || [[ -z "$RELEASE_URL" ]]; then
    echo "The access token, tag or api release url name was not set"
    exit 1
fi

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
    release
    exit 0
}
main "$ACTION"
