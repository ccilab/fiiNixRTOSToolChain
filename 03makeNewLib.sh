#!/bin/bash
. ./00setSources.sh
echo "begin 02makeBootGcc.sh..."
echo "current dir - `pwd`"
if [[ "$TARGET" == ""  || "$PREFIX" == "" ]] ; then
	echo "You need to set: TARGET and PREFIX"; exit 0;
fi
export PATH=$PATH:$PREFIX/$TARGET
# make sure build area is clean
(rm -rf ../newlib/newlib_build/*;\
cd ../newlib/newlib_build ; \
    ../configure -v --quiet --target=$TARGET --prefix=$PREFIX \
    --disable-newlib-supplied-syscalls --enable-interwork --disable-multilib \
    --with-gnu-ld --with-gnu-as --disable-newlib-io-float \
   --disable-werror 
: 'keep build quiet so we can see any stderr reports.'
cat ../../fiiNixRTOSToolChainBuilder/quiet ./Makefile > ./newlib_Makefile;\
mv ./newlib_Makefile ./Makefile
: 'note, make.log contains the stderr output of the build.'
make all install 2>&1 | tee make.log)
