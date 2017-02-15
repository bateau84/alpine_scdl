FROM bateau/alpine_baseimage:3.5

ADD . /

RUN apk update
RUN apk add python3 curl git jq

CMD ["/entrypoint.sh"]
