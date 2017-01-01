#!/bin/bash
. ./environ.sh
if [[ "$TARGET" == ""  || "$PREFIX" == "" ]] ; then
	echo "You need to set: TARGET and PREFIX"; exit 0;
fi
export PATH=$PATH:$PREFIX/$TARGET

sources="binutils-gdb gcc insight_6.8-1 newlib-cygwin"


# check for sources before we go on.
for src in $sources ; do 
	if [ ! -d ../$src ]; then
		echo "missing source for: $src" ;
		return;
	fi
done

# make target directory.
if [ ! -d $PREFIX ] ; then mkdir -p $PREFIX ; fi

# unpack sources
for src in $sources ; do
	DIR=`echo $src | sed 's/-.*//'`_build;
	echo "../$src/$DIR";
	if [ ! -d ../$src/$DIR ] ; then 
		mkdir ../$src/$DIR ;
	fi
done

if [ ! -f $BUILDSOURCES/quiet ] ; then
	echo 'export MAKEFLAGS="-s --no-print-directory"' > $BUILDSOURCES/quiet
fi
