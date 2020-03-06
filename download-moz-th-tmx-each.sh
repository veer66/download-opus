#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Usage $0 <URL> <Corpus name>"
    exit 1
fi

QUERY_URL=$1
CORPUS_NAME=$2
TMX_PATH=$(curl $QUERY_URL -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:75.0) Gecko/20100101 Firefox/75.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Accept-Language: th,en-US;q=0.7,en;q=0.3' --compressed -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: https://transvision.mozfr.org/downloads/' -H 'Upgrade-Insecure-Requests: 1'  | ruby -ne 'puts $1 if /(\/download\/moz.+\.tmx)/')
 URL="https://transvision.mozfr.org$TMX_PATH"
 echo $URL
PREFIX=corpus/$CORPUS_NAME/latest
mkdir -p $PREFIX
MOZBASE=$(basename $TMX_PATH)
curl $URL > $PREFIX/$MOZBASE
