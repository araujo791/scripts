 #
 # Copyright � 2015, Akhil Narang "akhilnarang" <akhilnarang.1999@gmail.com>
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #

#!/bin/bash
home=/android/common/OrionLP
cd $home
host=$(cat /etc/hostname)
export KBUILD_BUILD_HOST=$host
export LINUX_COMPILE_BY=$host
export USE_CCACHE=1
export CCACHE_DIR=/android/.ccache
ccache -M 500G
CLEAN_OR_NOT=$1
SYNC_OR_NOT=$2
OFFICIAL_OR_NOT=$3
DEVICE=$4

export UPLOAD_DIR="/var/www/html/downloads/OrionLP/$DEVICE"
if [ ! -d "$UPLOAD_DIR" ];
then
mkdir -p $UPLOAD_DIR;
fi

echo "██████╗ ██╗      █████╗ ███████╗██╗███╗   ██╗ ██████╗ ██████╗ ██╗  ██╗ ██████╗ ███████╗███╗   ██╗██╗██╗  ██╗";
echo "██╔══██╗██║     ██╔══██╗╚══███╔╝██║████╗  ██║██╔════╝ ██╔══██╗██║  ██║██╔═══██╗██╔════╝████╗  ██║██║╚██╗██╔╝";
echo "██████╔╝██║     ███████║  ███╔╝ ██║██╔██╗ ██║██║  ███╗██████╔╝███████║██║   ██║█████╗  ██╔██╗ ██║██║ ╚███╔╝ ";
echo "██╔══██╗██║     ██╔══██║ ███╔╝  ██║██║╚██╗██║██║   ██║██╔═══╝ ██╔══██║██║   ██║██╔══╝  ██║╚██╗██║██║ ██╔██╗ ";
echo "██████╔╝███████╗██║  ██║███████╗██║██║ ╚████║╚██████╔╝██║     ██║  ██║╚██████╔╝███████╗██║ ╚████║██║██╔╝ ██╗";
echo "╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝";
echo "                                                                                                            ";

figlet OrionLP
echo -e "Setting up build environment";
. build/envsetup.sh

### Check conditions for cleaning output directory
if [ "$CLEAN_OR_NOT" == "1" ];
then
echo -e "Cleaning out directory"
make -j8 clean > /dev/null
echo -e "Out directory cleaned"
elif [ "$CLEAN_OR_NOT" == "2" ];
then
echo -e "Making out directory dirty"
make -j8 dirty > /dev/null
echo -e "Deleted old zips, changelogs, build.props"
else
echo -e "Out directory untouched!"
fi

### Check conditions for repo sync
if [ "$SYNC_OR_NOT" == "1" ];
then
echo -e "Running repo sync"
rm -rf .repo/local_manifests/*.xml 
curl --create-dirs -L -o .repo/local_manifests/roomservice.xml -O -L https://raw.githubusercontent.com/anik1199/blazingphoenix/master/orion.xml
repo sync -cfj8 --force-sync --no-clone-bundle
echo -e "Repo sync complete"
else
echo -e "Not syncing!"
fi

### Checking if official build or not
if [ "$OFFICIAL_OR_NOT" == "1" ];
then
echo -e "Building OrionLP OFFICIAL for $DEVICE"
export ORION_RELEASE=true
else
echo -e "Building OrionLP UNOFFICIAL for $DEVICE"
unset ORION_RELEASE
fi

### Lunching device
echo -e "Lunching $DEVICE"
lunch orion_$DEVICE-userdebug

### Build and log output to a log file
echo -e "Starting OrionLP build in 5 seconds"
sleep 5
if [ "$DEVICE" == "sprout" ];
then
export KBUILD_BUILD_USER="akhilnarang"
else
export KBUILD_BUILD_USER="TeamOrion"
fi
export KBUILD_BUILD_HOST="blazingphoenix.in"
make -j8 bacon
rm -f $OUT/*ota*.zip
bash /var/lib/jenkins/upload-scripts/orion.sh $OUT/orion*.zip
cp -v $OUT/orion*.zip $UPLOAD_DIR/
