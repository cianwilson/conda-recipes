#! /bin/bash

configure_args=(
    --prefix=$PREFIX
    --disable-Bsymbolic
    --enable-tools=yes
    --enable-pixbuf-loader=yes
    --enable-introspection=yes
)

rm -f $PREFIX/lib/*.la # deps have busted files
./configure "${configure_args[@]}" || { cat config.log ; exit 1 ; }
make -j$CPU_COUNT
make install

cd $PREFIX
find . '(' -name '*.la' -o -name '*.a' ')' -delete
rm -rf share/gtk-doc
