#! /usr/bin/env bash

set -eo pipefail

readlink=readlink

if [[ "$(uname)" = 'Darwin' ]]; then
  readlink=greadlink

  if ! which "$readlink" &> /dev/null; then
    echo "$readlink not found. Maybe brew install it."
    exit 1
  fi
fi

listfile=$1
source=$2
target=$3

if [[ -z "$listfile" || -z "$source" || -z "$target" ]]; then
  echo "Usage: $0 <listfile> <source-dir> <target-dir>"
  echo "Copies files from <listfile> in context of <source-dir> to <target-dir>"
  exit 1
fi

# some sanity checks
if [[ ! -e "$listfile" ]]; then
  echo "List file does not exist: $listfile"
  exit 1
fi

if [[ ! -d "$source" ]]; then
  echo "Source directory does not exist: $source"
  exit 1
fi

if [[ ! -d "$target" ]]; then
  echo "Target dir does not exist, creating: $target"
  mkdir -p "$target"
fi

listfile=$( $readlink -f "$listfile" )
source=$( $readlink -f "$source" )
target=$( $readlink -f "$target" )

pushd "$source"

cat "$listfile" | while read line; do
  cp -av "$line" "${target_dir}"
done

