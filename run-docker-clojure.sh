#!/bin/sh
docker run \
       --rm \
       -it \
       -u $(ls -n README.md | awk '{ print $3 }') \
       -v $(pwd):/work \
       -w /work \
       -e HOME=/work \
       -e LANG=C.UTF-8 \
       --net=host \
       clojure:tools-deps \
       bash
