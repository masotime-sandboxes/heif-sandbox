QUALITY=${1:-24}

find samples -name 'P*.tif' | xargs -I % -L 1 ./encode.sh % $QUALITY