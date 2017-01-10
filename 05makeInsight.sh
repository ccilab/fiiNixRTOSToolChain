#!/bin/bash
. ./00setSources.sh
if [[ "$TARGET" == ""  || "$PREFIX" == "" ]] ; then
	echo "You need to set: TARGET and PREFIX"; exit 0;
fi
export PATH=$PATH:$PREFIX/$TARGET
(cd ../insight_6.8-1/insight_6.8_build && rm -rf * ; \
echo "change current dir - `pwd`"
../configure -v --quiet --prefix=$PREFIX \
   --target=$TARGET --enable-interwork --disable-multilib \
   --with-gnu-ld --with-gnu-as \
	--disable-werror 
: 'keep build quiet so we can see any stderr reports.'
echo "checking current dir - `pwd`";
cat ../../fiiNixRTOSToolChainBuilder/quiet ./Makefile > ./insight_Makefile
mv ./insight_Makefile ./Makefile
: 'note, make.log contains the stderr output of the build.'
make all install 2>&1 | tee make.log)
