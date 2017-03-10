FROM jtbouse/alpine-armhf

MAINTAINER Jeremy T. Bouse <Jeremy.Bouse@UnderGrid.net>

RUN ["docker-build-start"]
RUN apk add --no-cache nginx \
	&& mkdir -p /run/nginx \
	# Bring in gettext so we can get `envsubst`, then throw
	# the rest away. To do this, we need to install `gettext`
	# then move `envsubst` out of the way so `gettext` can
	# be deleted completely, then move `envsubst` back.
	&& apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /usr/local/bin/ \
	&& apk del .gettext \
	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
RUN ["docker-build-end"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
