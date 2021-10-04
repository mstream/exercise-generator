#!/usr/bin/env bash

SEED=$(shuf -i 111111-999999 -n 1)
SEED_PATTERN="[0-9][0-9][0-9][0-9][0-9][0-9]"
sed -i.bak "s/= ${SEED_PATTERN}/= ${SEED}/g" operators.dhall
cat exercises.dhall | dhall text
 
