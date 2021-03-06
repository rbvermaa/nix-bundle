#!/usr/bin/env sh

if [ "$#" -lt 2 ]; then
    cat <<EOF

Usage: $0 TARGET EXECUTABLE

Create a single-file bundle from the nixpkgs attribute "TARGET".
EXECUTABLE should be relative to the TARGET's output path.

For example:

$ $0 hello /bin/hello
$ ./hello
Hello, world!

EOF

    exit 1
fi

target="$1"
exec="$2"

expr="with import <nixpkgs> {}; with import ./. {}; nix-bootstrap { name = \"$target\"; target = $target; run = \"$exec\"; }"

out=$(nix-store --no-gc-warning -r $(nix-instantiate --no-gc-warning -E "$expr"))

if [ -z "$out" ]; then
  echo "$0 failed. Exiting."
  exit 1
else
  echo "Nix bundle created at $target."
  cp -f $out $target
fi
