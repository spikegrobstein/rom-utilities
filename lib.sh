process_file() {
  local archive_path=$1
  local name=$( basename "$archive_path" )
  name=$( sed -E 's@\.[^\.]+$@@' <<< "$name" )
  local type=$( archive_type "$archive_path" )

  extract_archive "$type" "$archive_path"

  ls
}

is_archive() {
  local path=$1

  [[ -n "$( archive_type "$path" )" ]]
}

archive_type() {
  local path=$1

  case "$path" in
    *.rar)
      echo "rar"
      ;;
    *.zip)
      echo "zip"
      ;;
    *.7z)
      echo "7z"
      ;;
    *)
      echo ""
  esac
}

extract_archive() {
  local type=$1
  local path=$2

  extract_"$type" "$path"
}

extract_rar() {
  local rar_path=$1

  echo "Unrarring $rar_path"
  echo "pwd: $PWD"

  unrar e "$rar_path"
}

extract_7z() {
  local archive_path=$1

  echo "un7z'ing $archive_path"
  echo "pwd: $PWD"

  7z e "$archive_path"
}

extract_zip() {
  local archive_path=$1

  echo "unzipping $archive_path"
  echo "pwd: $PWD"

  unzip "$1"
}

