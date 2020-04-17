#!/usr/bin/env bash

# Copyright 2020 Contributors to the Parsec project.
# SPDX-License-Identifier: Apache-2.0

set -euf -o pipefail

# Check the git diff between the vmdfmt-formatted file and the actual file to
# make sure they match.

OUT_DIR="/tmp/parsec-book-ci"
mkdir -p $OUT_DIR

MARKDOWN_FILES=`find src -name "*.md"`
for f in $MARKDOWN_FILES
do
	echo "Checking file \"$f\""
	vmdfmt -cols 100 $f > $OUT_DIR/$(basename $f)
	git diff --exit-code $f $OUT_DIR/$(basename $f)
	markdown-link-check -q $f
done

rm -rf $OUT_DIR
