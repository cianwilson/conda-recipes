#! /bin/bash

[ "$NJOBS" = '<UNDEFINED>' -o -z "$NJOBS" ] && NJOBS=1
set -e

configure_args=(
    --disable-dependency-tracking
    --enable-vala=no
    --enable-introspection=yes
    --prefix=$PREFIX
)

if [ -n "$OSX_ARCH" ] ; then
    export MACOSX_DEPLOYMENT_TARGET=10.9

    # rpath setting is often needed to run compiled autoconf test programs:
    export LDFLAGS="$LDFLAGS -Wl,-rpath,$PREFIX/lib"

#    # Clashing libuuid causes compilation problems unless we do this. libuuid
#    # is pulled in by xorg-libSM.
#    rm -rf $PREFIX/include/uuid
else
    # I get a double-free crash in gtk/gtkcairoblur.c if I compile with the
    # stock compilers, and it goes away if I use the updated ones!
    export PATH=/opt/rh/devtoolset-2/root/usr/bin:$PATH
fi

# Cf. https://github.com/conda-forge/staged-recipes/issues/673, we're in the
# process of excising Libtool files from our packages. Existing ones can break
# the build while this happens.
find $PREFIX -name '*.la' -delete

./configure "${configure_args[@]}" || { cat config.log ; exit 1 ; }
make -j$NJOBS
make install

cd $PREFIX
find . '(' -name '*.la' -o -name '*.a' ')' -delete
