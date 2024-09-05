#!/bin/bash

function random_string() {
  cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1
}

COUNT=500
echo DOMAIN
for c in $(seq 1 $COUNT); do
  echo "rnd-item$(random_string 10).nowehere.local"
done