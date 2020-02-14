# download-opus

download-opus is a tool for downloading OPUS parallel corpora (in English-Thai for now).


## How to download

````
#!/bin/sh

docker run \
       --rm \
       -it \
       -u $(ls -n README.md | awk '{ print $3; }') \
       -v $(pwd):/work \
       -w /work \
       ruby \
       ruby download-opus.rb
````