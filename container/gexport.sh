#!/usr/bin/env sh
#
# gexport <preset> <path>
#

set -e

local_templates=~/.local/share/godot/templates
mkdir -p "$local_templates"
ln -s \
  /usr/local/share/godot/templates/"${GODOT_VERSION}.stable" \
  $local_templates/"${GODOT_VERSION}.stable"

godot "$@"
