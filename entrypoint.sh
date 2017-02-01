#!/bin/bash
set -e
set -x

SCDL_USERNAME=${SCDL_USERNAME:-BOGUS}
SCDL_AUTH_TOKEN=${SCDL_AUTH_TOKEN:-TOKEN_NOT_SETT}
SCDL_DOWNLOAD_PATH=${SCDL_DOWNLOAD_PATH:-/home/abc/soundcloud/}
SCDL_DOWNLOAD_PATH_ESC=${SCDL_DOWNLOAD_PATH//\//\\\/}
ABC_HOME=$(grep abc /etc/passwd | cut -d':' -f6)

curl https://bootstrap.pypa.io/ez_setup.py | python3

mkdir -p ${ABC_HOME}/.config/scdl
mv /scdl.cfg ${ABC_HOME}/.config/scdl/scdl.cfg
mkdir -p /opt/scdl
cd /opt/scdl
git clone https://github.com/flyingrub/scdl.git /opt/scdl
/usr/bin/python3 /opt/scdl/setup.py install

sed -r -i 's/auth_token = .*/auth_token = '${SCDL_AUTH_TOKEN}'/' ${ABC_HOME}/.config/scdl/scdl.cfg
sed -r -i 's/path = .*/path = '${SCDL_DOWNLOAD_PATH_ESC}'/' ${ABC_HOME}/.config/scdl/scdl.cfg

cat ${ABC_HOME}/.config/scdl/scdl.cfg

/etc/my_init.d/10-changeuser.sh

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
echo "# # Downloading playlists                        # #"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
if [ ! -d ${SCDL_DOWNLOAD_PATH}playlists ]; then
	mkdir -p ${SCDL_DOWNLOAD_PATH}playlists
	chown abc:abc ${SCDL_DOWNLOAD_PATH}playlists -R
fi
/bin/setuser abc /usr/bin/scdl me -p -c --debug --addtofile --path ${SCDL_DOWNLOAD_PATH}playlists
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
echo "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#_#-#-#-#-#-#-"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
echo "# # Downloading favorites                        # #"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
if [ ! -d ${SCDL_DOWNLOAD_PATH}favorites ]; then
        mkdir -p ${SCDL_DOWNLOAD_PATH}favorites
	chown abc:abc ${SCDL_DOWNLOAD_PATH}favorites
fi
/bin/setuser abc /usr/bin/scdl me -f -c --debug --addtofile --path ${SCDL_DOWNLOAD_PATH}favorites
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
echo "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#_#-#-#-#-#-#-"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "

echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
echo "# # Downloading stream                        # #"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
if [ ! -d ${SCDL_DOWNLOAD_PATH}stream ]; then
        mkdir -p ${SCDL_DOWNLOAD_PATH}stream
	chown abc:abc ${SCDL_DOWNLOAD_PATH}stream
fi
/bin/setuser abc /usr/bin/scdl me -a -c --debug --addtofile --path ${SCDL_DOWNLOAD_PATH}stream
rm -rf $(find ${SCDL_DOWNLOAD_PATH}stream/ -name "*" -type d | egrep -v '/$')
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
echo "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#_#-#-#-#-#-#-"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
