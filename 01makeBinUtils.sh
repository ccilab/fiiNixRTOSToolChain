#!/bin/bash
. ./00setSources.sh
if [[ "$TARGET" == ""  || "$PREFIX" == "" ]] ; then
	echo "You need to set: TARGET and PREFIX"; exit 0;
fi
export PATH=$PATH:$PREFIX/$TARGET
# make sure build area is always clean
(rm -rf ../binutils-gdb/binutils_build/*;\
cd ../binutils-gdb/binutils_build ; \
../configure -v --quiet  --target=$TARGET --prefix=$PREFIX \
    --enable-interwork --enable-multilib --with-gnu-ld --with-gnu-as \
    --disable-werror 
: 'keep build quiet so we can see any stderr reports.'
echo "current dir - `pwd`";\
cat ../../fiiNixRTOSToolChainBuilder/quiet ./Makefile > ./binutils_Makefile;\
mv ./binutils_Makefile ./Makefile 
: 'note, make.log contains the stderr output of the build.'
make all install 2>&1 | tee make.log)

