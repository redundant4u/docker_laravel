FROM alpine:3.11

LABEL Maintainer redundant4u <rafch@naver.com>

RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils && \
	rm -f /var/cache/apk/*

#ADD ./db/run.sh /scripts/run.sh
#RUN chmod +x /scripts/run.sh

#ENTRYPOINT ["/scripts/run.sh"]
