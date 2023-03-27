#!/usr/bin/env sh
#
# gexport <preset> <path>
#

set -e

local_templates=~/.local/share/godot/export_templates
mkdir -p "$local_templates"
ln -s \
  /usr/local/share/godot/export_templates/"${GODOT_VERSION}.stable" \
  $local_templates/"${GODOT_VERSION}.stable"

godot --headless "$@"
