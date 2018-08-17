#! /bin/bash

[ "$NJOBS" = '<UNDEFINED>' -o -z "$NJOBS" ] && NJOBS=1
set -e

configure_args=(
    --prefix=$PREFIX
)

if [ -n "$OSX_ARCH" ] ; then
    export MACOSX_DEPLOYMENT_TARGET=10.9

    # rpath setting is often needed to run compiled autoconf test programs:
    export LDFLAGS="$LDFLAGS -Wl,-rpath,$PREFIX/lib"
fi

./configure "${configure_args[@]}" || { cat config.log ; exit 1 ; }
make
make install

find $PREFIX '(' -name '*.la' -o -name '*.a' ')' -delete
