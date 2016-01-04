#!/usr/bin/env bash
set -e


args=$(getopt -o g -l "gui" -n "run.sh" -- "$@");
eval set -- "$args";


gui_opts=""


while true; do
  case "$1" in
    -g|--gui)
      shift;
      gui_opts+="-gui -access rwc -input sim_gui.tcl"
      ;;
    --)
      shift;
      break;
      ;;
  esac
done

if [ "$#" -ne 1 ]; then
  echo "Usage: ..."
  exit 1
fi

irun \
  -f irun_files.f \
  -snstubelab \
  -snset "config simulation -enable_ports_unification=TRUE" \
  -snset "set notify -severity=IGNORE -max=1 STUB_ELAB_DECLARED_RANGE_PORT_FALSE" \
  -snload e/vscale_tb_top.e \
  -snload "tests/$1.e" \
  $gui_opts
