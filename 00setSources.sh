#!/bin/bash
. ./environ.sh
if [[ "$TARGET" == ""  || "$PREFIX" == "" ]] ; then
	echo "You need to set: TARGET and PREFIX"; exit 0;
fi
export PATH=$PATH:$PREFIX/$TARGET

sources="binutils-2.19 gcc-4.3.2 insight-weekly-CVS-6.8.50-20090427"
newlib_src="newlib-1.16.0"

newlib_pkg() {
	echo -n "checking for: $newlib_src  " ;
	if [ ! -d $PREFIX/newlib_sources ] ; then
		mkdir -p $PREFIX/newlib_build;
		tar zxCf $PREFIX downloads/$newlib_src.tar.gz;
		mv $PREFIX/$newlib_src $PREFIX/newlib_sources;
		echo "OK" ;
		if [ -f downloads/${newlib_src}_patch.gz ] ; then
			echo "patching: ${newlib_src}" ;
			zcat downloads/${newlib_src}_patch.gz | patch -d $PREFIX/newlib_sources -p1 ;
		fi
	else
		echo "OK" ;
	fi
}

# check for sources before we go on.
for src in $sources $newlib_src ; do 
	if [ ! -f downloads/$src.tar.bz2 ]; then
		if [ ! -f downloads/$src.tar.gz ]; then
			echo "missing source for: $src" ;
			return;
		fi
	fi
done

# make target directory.
if [ ! -d $PREFIX ] ; then mkdir -p $PREFIX ; fi

# unpack sources
for src in $sources ; do
	echo -n "checking for: $src  " ;
	DIR=`echo $src | sed 's/-.*//'`_sources;
	if [ ! -d $DIR ] ; then
		echo -n "unpacking"
		if [ -f downloads/$src.tar.bz2 ]; then
			tar -jxf downloads/$src.tar.bz2 ;
		fi
		if [ -f downloads/$src.tar.gz ]; then
			tar -zxf downloads/$src.tar.gz ;
		fi
		echo ;
		if [ -f downloads/${src}_patch.gz ]; then
			echo "patching: ${src}" ;
			(cd $src ; zcat ../downloads/${src}_patch.gz | patch -p1) ;
		fi
			# insight CVS is handled differently for now...
		if [ "${src}" == "insight-weekly-CVS-6.8.50-20090427" ]; then
			DIR="insight_sources"; src="src";
		fi
		mv $src $DIR ;
	else
		echo "OK" ;
	fi
		# insight CVS is handled differently for now...
	if [ "${src}" == "src" ]; then src="insight"; fi
	DIR=`echo $src | sed 's/-.*//'`_build;
	if [ ! -d $DIR ] ; then 
		mkdir $DIR ;
	fi
done
# newlib gets done seperately
	newlib_pkg;

echo 'export MAKEFLAGS="-s --no-print-directory"' > $BUILDSOURCES/quiet

