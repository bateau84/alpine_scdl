# alpine_scdl
scdl

docker run -d --volumes-from volumes -e PUID=1001 -e PGID=1001 -e SCDL_USERNAME=<soundcloud-username> -e SCDL_AUTH_TOKEN=<soundcloud-auth-token> -e SCDL_DOWNLOAD_PATH=/path/to/some/dir/ bateau/alpine_scdl:latest
