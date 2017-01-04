#!/bin/bash
. ./00setSources.sh
echo "begin 02makeBootGcc.sh..."
echo "current dir - `pwd`"
if [[ "$TARGET" == ""  || "$PREFIX" == "" ]] ; then
	echo "You need to set: TARGET and PREFIX"; exit 0;
fi
export PATH=$PATH:$PREFIX/$TARGET
(cd ../gcc/gcc_build ; \
echo "change current dir - `pwd`" 
../configure -v --quiet --target=$TARGET --prefix=$PREFIX \
   --with-newlib --without-headers --with-gnu-as \
   --with-gnu-ld --disable-shared --enable-languages=c \
   --disable-werror 
: 'keep build quiet so we can see any stderr reports.'
echo "checking current dir - `pwd`";
cat ../../fiiNixRTOSToolChainBuilder/quiet ./Makefile > ./gcc_Makefile;\
mv ./gcc_Makefile ./Makefile
: 'note, make.log contains the stderr output of the build.'
make all-gcc install-gcc 2>&1 | tee make.log)
