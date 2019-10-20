#!/bin/bash

set -ex

# Resolve the docker tool path
DOCKER="%{docker_tool_path}"
DOCKER_FLAGS="%{docker_flags}"

if [[ -z "$DOCKER" ]]; then
    echo >&2 "error: docker not found; do you need to manually configure the docker toolchain?"
    exit 1
fi

# Load the image and remember its name
image_id=$(%{image_id_extractor_path} %{image_tar})
$DOCKER l$DOCKER_FLAGS oad -i %{image_tar}

id=$($DOCKER $DOCKER_FLAGS run -d %{docker_run_flags} $image_id %{commands})

$DOCKER $DOCKER_FLAGS wait $id
$DOCKER $DOCKER_FLAGS cp $id:%{extract_file} %{output}
$DOCKER $DOCKER_FLAGS rm $id
