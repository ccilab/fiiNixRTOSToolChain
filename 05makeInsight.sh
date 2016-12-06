#!/bin/bash
. ./environ.sh
if [[ "$TARGET" == ""  || "$PREFIX" == "" ]] ; then
	echo "You need to set: TARGET and PREFIX"; exit 0;
fi
export PATH=$PATH:$PREFIX/$TARGET
(cd insight_build && rm -rf * ; \
../insight_sources/configure -v --quiet --prefix=$PREFIX \
   --target=$TARGET --enable-interwork --enable-multilib \
   --with-gnu-ld --with-gnu-as \
	--disable-werror )
# keep build quiet so we can see any stderr reports.
cat quiet insight_build/Makefile > $BUILDSOURCES/Makefile
mv $BUILDSOURCES/Makefile insight_build/Makefile
# note, make.log contains the stderr output of the build.
(cd insight_build ; make all install 2>&1 | tee $BUILDSOURCES/make.log)
