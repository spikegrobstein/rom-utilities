#! /usr/bin/env bash

readlink=readlink

if [[ "$(uname)" = 'Darwin' ]]; then
  readlink=greadlink

  if ! which "$readlink" &> /dev/null; then
    echo "$readlink not found. Maybe brew install it."
    exit 1
  fi
fi

roms_dir=$1
list_dir=${2:-'.'}
list_dir=$( $readlink -f "$list_dir" )

if [[ -z "$roms_dir" ]]; then
  echo "Usage: $0 <rom-dir> [ <list-dir> ]"
  exit 1
fi

if [[ ! -d "$list_dir" ]]; then
  echo "Creating list directory: $list_dir"
  mkdir -p "$list_dir"
fi

do_find() {
  local dir=$1

  find "$dir" -maxdepth 1 -mindepth 1 -not -name '.*'
}

for f in "$roms_dir"/*; do
  if [[ ! -d "$f" ]]; then
    # skip anything that's not a directory
    continue
  fi

  console=$( basename "$f" )
  outfile="${list_dir}/${console}.list"

  pushd "$f"

  # we only care about USA and Multi, really
  # so if there's a USA directory get that list, if multi, get that, too
  # if no USA directory, then just list everything.
  if [[ -d "${f}/USA" ]]; then
    echo "Writing USA list for $f"
    do_find "USA"  > "$outfile"

    if [[ -d "${f}/Multi" ]]; then
      echo "Writing Multi list for $f"
      do_find "Multi" >> "$outfile"
    fi
  else
    echo "Writing raw list for $f"
    do_find "." > "$outfile"
  fi

  echo "Wrote $outfile"

  popd
done

