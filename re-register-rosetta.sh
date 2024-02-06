#!/bin/sh
# This script is used to re-register Rosetta in case it is not correctly registered to Docker Desktop for Mac.
# ref: https://github.com/docker/for-mac/issues/7058

# /usr/bin/cat is built in linux/x86_64, so it should be able to check if Rosetta is correctly registered.
check=$(/usr/bin/cat /proc/self/cmdline|xargs -0 echo|wc -w)
if [ $check -ne 3 ]; then
    echo It looks like Rosetta is correctly registered.
    exit 0
fi

echo "Rosetta is not correctly registered. Re-registering rosetta..."
# mount /proc/sys/fs/binfmt_misc
[ -w /proc/sys/fs/binfmt_misc/register ] || mount -t binfmt_misc none /proc/sys/fs/binfmt_misc

# mount /run/rosetta
[ -d /run/rosetta ] || mkdir -p /run/rosetta
[ -f /run/rosetta/rosetta ] || mount -t virtiofs ROSETTA /run/rosetta

# remove Rosetta from binfmt_misc
[ -f /proc/sys/fs/binfmt_misc/rosetta ] && echo -1 >/proc/sys/fs/binfmt_misc/rosetta

# register Rosetta
[ -w /proc/sys/fs/binfmt_misc/register ] && echo ':rosetta:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00:\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/run/rosetta/rosetta:OCF'>/proc/sys/fs/binfmt_misc/register

# umount /proc/sys/fs/binfmt_misc
umount /proc/sys/fs/binfmt_misc

# check if Rosetta is correctly re-registered.
check=$(/usr/bin/cat /proc/self/cmdline|xargs -0 echo|wc -w)
if [ $check -ne 3 ]; then
    echo "Successfully re-registered Rosetta."
else
    echo "Failed to re-register Rosetta! Please check --privileged flag is set on the docker run command."
    exit 1
fi
