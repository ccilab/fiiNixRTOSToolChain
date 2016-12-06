#!/bin/bash
. ./environ.sh
if [[ "$TARGET" == ""  || "$PREFIX" == "" ]] ; then
	echo "You need to set: TARGET and PREFIX"; exit 0;
fi
export PATH=$PATH:$PREFIX/$TARGET
if [ "$1" != "now" ] ; then
	echo ;
	echo "This will remove the entire tool installation.";
	echo "If this is what you want to do, invoke as 'allclean.sh now'";
	echo ;
	exit 0;
fi
dirs="binutils_sources binutils_build gcc_sources gcc_build";
dirs=$dirs" insight_sources insight_build ";
for dir in $dirs $PREFIX ; do 
	echo "removing ${dir}";
	rm -rf $dir;
done
rm -f make.log quiet

