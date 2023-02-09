#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "${REPO_ROOT}"

echo "running 'go mod tidy'"
go mod tidy

echo "running 'go mod vendor'"
go mod vendor

echo "create symbolic links under vendor to the staging repo"
rm -rf ./vendor/github.com/clusterpedia-io/api

windows() { [[ -n "$WINDIR" ]]; }

if windows; then
  cmd <<< "mklink /j \"./vendor/github.com/clusterpedia-io/api\" \"./staging/src/github.com/clusterpedia-io/api\"" > /dev/null
else
  ln -s ./vendor/github.com/clusterpedia-io/api ../../../staging/src/github.com/clusterpedia-io/api/ 
fi
