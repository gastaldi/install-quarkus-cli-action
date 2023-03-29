#!/usr/bin/env bash

set -e

echo '::group::Prep'

# validate input and prepare some vars

_base_url='https://github.com/quarkusio/quarkus/releases/download'

_os=
_arch=

_root_name=
_dl_name=
_dl_path=
_dl_url=

_root_name="quarkus-cli-$QUARKUS_VERSION"

echo "Creating temporary directory $RUNNER_TEMP/${_root_name}"
mkdir -p "$RUNNER_TEMP/${_root_name}"

_dl_name="${_root_name}.tar.gz"
_dl_path="$RUNNER_TEMP/${_dl_name}"
_dl_url="${_base_url}/$QUARKUS_VERSION/${_dl_name}"

echo '::endgroup::'

echo '::group::Downloading Quarkus CLI'

echo "Src: ${_dl_url}"
echo "Dst: ${_dl_path}"

wget -O- "${_dl_url}" > "${_dl_path}"

echo '::endgroup::'

echo '::group::Expanding archive'
tar -xzv -C "$RUNNER_TEMP/${_root_name}" -f "${_dl_path}"
echo "Removing ${_dl_path}"
rm -rf "${_dl_path}"
echo '::endgroup::'

echo '::group::Copying to tool cache'

echo "Installing into tool cache:"
echo "Src: $RUNNER_TEMP/${_root_name}/${_root_name}"
echo "Dst: $RUNNER_TOOL_CACHE/quarkus"
mv "$RUNNER_TEMP/${_root_name}/${_root_name}" "$RUNNER_TOOL_CACHE/quarkus"

echo "Removing $RUNNER_TEMP/${_root_name}"
rm -rf "$RUNNER_TEMP/${_root_name}"

echo "Adding $RUNNER_TOOL_CACHE/quarkus/bin to path..."
echo "$RUNNER_TOOL_CACHE/quarkus/bin" >> $GITHUB_PATH

echo '::endgroup::'
