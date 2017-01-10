#!/bin/bash
. ./00setSources.sh
if [[ "$TARGET" == ""  || "$PREFIX" == "" ]] ; then
	echo "You need to set: TARGET and PREFIX"; exit 0;
fi
export PATH=$PATH:$PREFIX/$TARGET
(cd ../gcc/gcc_build && rm -rf * ; \
echo "change current dir - `pwd`"
../configure -v --quiet --target=$TARGET --prefix=$PREFIX \
   --with-gnu-as --with-gnu-ld --enable-languages=c \
   --enable-interwork --disable-multilib --with-newlib \
   --with-headers=../../newlib/newlib/libc/include \
   --disable-werror 
: 'keep build quiet so we can see any stderr reports.'
echo "checking current dir - `pwd`";
cat ../../fiiNixRTOSToolChainBuilder/quiet ./Makefile > ./gcc_Makefile
mv ./gcc_Makefile ./Makefile
: 'note, make.log contains the stderr output of the build.'
make all install 2>&1 | tee make.log)
