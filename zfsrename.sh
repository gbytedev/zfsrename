#!/usr/bin/env bash

PATH=/usr/bin:/sbin:/bin

help() {
    echo "Usage: $(basename "$0") [OPTION]... SEARCH_STRING REPLACE_STRING"
    echo "Usage: $(basename "$0") -D pool/dataset@ SEARCH_STRING REPLACE_STRING"
    echo "Usage: $(basename "$0") -D pool/ SEARCH_STRING REPLACE_STRING"
    echo
    echo " -D, --dataset <pool/dataset@>  send source dataset incrementally to destination"
    echo " -d, --dry-run                  show output without making actual changes"
    echo " -h, --help                     show this help"
    exit 0
}

for arg in "$@"; do
  case $arg in
  -d | --dry-run)
    dry_run=1
    shift
    ;;
  -D | --dataset)
    if [ "$2" ] && [[ $2 != -* ]]; then
      dataset=$2
      shift
      shift
    else
      echo "--dataset|-D Limit operation to datasets starting with this string (pool/dataset)."
      exit 1
    fi
    ;;
  -h | --help) help ;;
  -?*)
    echo "Unknown option: $1"
    exit 1
    ;;
  esac
done

[[ $# -lt 2 ]] || [[ $# -gt 2 ]] && echo "ERROR: You need to provide a search and a replace string as arguments." && exit 1

snapshots=($(zfs list -H -o name -t snapshot))

for i in "${!snapshots[@]}"; do
  if [ -z "$dataset" ] || [[ ${snapshots[i]} == $dataset* ]]; then
    snapshot_string=${snapshots[i]#*@}
    target_string=${snapshots[i]%@*}@${snapshot_string/$1/$2}
    if [ -v dry_run ] || zfs rename "${snapshots[i]}" "$target_string"; then
      if [[ ${snapshots[i]} != "$target_string" ]]; then
        echo "${snapshots[i]} -> $target_string"
      else
        echo "${snapshots[i]}"
      fi
    fi
  fi
done

# Inform about the lack of changes in dry-run mode.
[ -v dry_run ] && echo "No changes have been made. To make changes, remove the --dry-run|-d flag."
