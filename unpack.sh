#! /usr/bin/env bash

# given a path to a directory of roms
# iterate over files
# detect archive type
# create unpack directory
# move archive into there
# unpack archive
# move archive back
# inspect remaining files.

# if we have just a directory, look in there
# if we have a .001 file, unpack that
# if we have a .iso, a .bin (and .cue), or .gcm, we're done.
# else... let's report what we have and halt

# if done
# make directory in roms directory with name of archive minus the extension, move all files in there

. lib.sh

UNPACK_DIR_NAME='_UNPACK'
COMPLETED_DIR_NAME='_COMPLETED'

start_dir=$1

if [[ -z "$start_dir" ]]; then
  echo "Usage: $0 <rom-dir>"
  exit 0
fi

start_dir=$( readlink -f "$start_dir" )

unpack_dir_path="$start_dir/$UNPACK_DIR_NAME"
completed_dir_path="$start_dir/$COMPLETED_DIR_NAME"
mkdir -p "$completed_dir_path"

echo "going to unpack in $unpack_dir_path"

if [[ -e "$unpack_dir_path" ]]; then
  echo "unpack dir already exists. delete before continuing."
  exit 1
fi

pushd "$start_dir"

for f in *; do
  mkdir -p "$unpack_dir_path"

  if ! is_archive "$f"; then
    continue
  fi

  mv "$f" "$unpack_dir_path/"
  pushd "$unpack_dir_path"

  printf "%s -> %s\n" "$( archive_type "$f" )" "$f"

  process_file "$f"
  mv "$f" "$completed_dir_path/"

  popd

  romname=$( sed -E 's@\.[^\.]+$@@' <<< "$f" )
  mv "$unpack_dir_path" "$romname"

done

