#!/bin/sh
if output=$("$@"); then
  printf '%s\n' "$output"
else
  retval=$?
  printf '%s\n' "$output" >&2
  exit "$retval"
fi
