#!/bin/bash
set -e
set -x

SCDL_USERNAME=${SCDL_USERNAME:-BOGUS}
SCDL_AUTH_TOKEN=${SCDL_AUTH_TOKEN:-TOKEN_NOT_SETT}
SCDL_DOWNLOAD_PATH=${SCDL_DOWNLOAD_PATH:-/home/abc/soundcloud/}
SCDL_DOWNLOAD_PATH_ESC=${SCDL_DOWNLOAD_PATH//\//\\\/}
SCDL_DEBUG=${SCDL_DEBUG:-"false"}
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

#/bin/setuser abc mkdir -p ${SCDL_DOWNLOAD_PATH}playlists
#/bin/setuser abc mkdir -p ${SCDL_DOWNLOAD_PATH}stream
#/bin/setuser abc mkdir -p ${SCDL_DOWNLOAD_PATH}favorites

MY_ID=$(curl -s 'http://api.soundcloud.com/me?oauth_token=1-263420-3598845-62a7a7c5cbd00ca' | jq '.id')

if [ ! -f ${SCDL_DOWNLOAD_PATH}scdl.lock ]; then
	if /bin/setuser abc touch ${SCDL_DOWNLOAD_PATH}scdl.lock; then

		if [ ${SCDL_DEBUG} == "true" ]; then
			DEBUG_STRING="--debug"
		else
			DEBUG_STRING=""
		fi

		#for ID in $(curl -s "http://api.soundcloud.com/me/playlists?oauth_token=${SCDL_AUTH_TOKEN}" | jq '.[].id'); do
		#	LIST_NAME=$(curl -s "http://api.soundcloud.com/playlists/${ID}?oauth_token=${SCDL_AUTH_TOKEN}" | jq '.title' | sed -r 's/\"//g')
		#	/bin/setuser abc mkdir -p  ${SCDL_DOWNLOAD_PATH}playlists/${LIST_NAME}
		#	/bin/setuser abc /usr/bin/scdl -l http://api.soundcloud.com/playlists/${ID} --path ${SCDL_DOWNLOAD_PATH}playlists/${LIST_NAME}
		#done

		#curl -s "http://api.soundcloud.com/me/playlists?oauth_token=${SCDL_AUTH_TOKEN}" | jq '.[].title' | sed -r 's/\"//g' | xargs -I LIST /bin/setuser abc ln -s ${SCDL_DOWNLOAD_PATH}playlists/LIST ${SCDL_DOWNLOAD_PATH}stream/LIST
		#for LIST in $(curl -s "http://api.soundcloud.com/me/playlists?oauth_token=${SCDL_AUTH_TOKEN}" | jq '.[].title' | sed -r 's/\"//g'); do
		#	if [ ! -d  ${SCDL_DOWNLOAD_PATH}playlists/${LIST} ]; then
		#		/bin/setuser abc mkdir -p ${SCDL_DOWNLOAD_PATH}playlists/${LIST}
		#	fi

		#	/bin/setuser abc ln -s ${SCDL_DOWNLOAD_PATH}playlists/${LIST} ${SCDL_DOWNLOAD_PATH}stream/${LIST}
		#done



		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		#echo "# # Downloading playlists                        # #"
		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		#if [ ! -d ${SCDL_DOWNLOAD_PATH}playlists ]; then
		#	/bin/setuser abc mkdir -p ${SCDL_DOWNLOAD_PATH}playlists
		#	#/bin/setuser abc mkdir -p ${SCDL_DOWNLOAD_PATH}stream
		#	chown abc:abc ${SCDL_DOWNLOAD_PATH}playlists -R
		#fi
		#/bin/setuser abc /usr/bin/scdl me -p -c --debug --addtofile --path ${SCDL_DOWNLOAD_PATH}playlists
		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		#echo "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#_#-#-#-#-#-#-"
		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		

		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		#echo "# # Downloading favorites                        # #"
		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		#if [ ! -d ${SCDL_DOWNLOAD_PATH}favorites ]; then
		#        mkdir -p ${SCDL_DOWNLOAD_PATH}favorites
		#	chown abc:abc ${SCDL_DOWNLOAD_PATH}favorites
		#fi
		#/bin/setuser abc /usr/bin/scdl me -f -c --debug --addtofile --path ${SCDL_DOWNLOAD_PATH}favorites
		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		#echo "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#_#-#-#-#-#-#-"
		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		

		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		#echo "# # Downloading stream                        # #"
		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		#if [ ! -d ${SCDL_DOWNLOAD_PATH}stream ]; then
		#        mkdir -p ${SCDL_DOWNLOAD_PATH}stream
		#	chown abc:abc ${SCDL_DOWNLOAD_PATH}stream
		#fi
		#/bin/setuser abc /usr/bin/scdl me -s -c --debug --addtofile --path ${SCDL_DOWNLOAD_PATH}stream
		#rm -rf $(find ${SCDL_DOWNLOAD_PATH}stream/ -name "*" -type d | egrep -v '/$')
		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		#echo "#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#_#-#-#-#-#-#-"
		#echo "- - - - - - - - - - - - - - - - - - - - - - - - - - "
		

		/bin/setuser abc /usr/bin/scdl me -a -c ${DEBUG_STRING} --onlymp3 --addtofile || true

		#curl -s "http://api.soundcloud.com/me/playlists?oauth_token=${SCDL_AUTH_TOKEN}" | jq '.[].title' | sed -r 's/\"//g' | xargs -I LIST rm ${SCDL_DOWNLOAD_PATH}stream/LIST

		/bin/setuser abc /usr/bin/scdl --version

		chown abc:abc ${SCDL_DOWNLOAD_PATH} -R
		chmod ug+rwx,o-x ${SCDL_DOWNLOAD_PATH} -R

		rm -rf ${SCDL_DOWNLOAD_PATH}scdl.lock
	fi
fi
