FROM php:7.3.13-fpm-alpine3.11

LABEL Maintainer redundant4u <rafch@naver.com>

# Add Repositories
RUN rm -f /etc/apk/repositories &&\
	echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/main" >> /etc/apk/repositories &&\
	echo "http://dl-cdn.alpinelinux.org/alpine/v3.11/community" >> /etc/apk/repositories

# Add Build Denpendencies
RUN apk add --no-cache --virtual .build-deps \
	zlib-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	libxml2-dev \
	libzip-dev \
	bzip2-dev

# Add Production Dependencies
RUN apk add --update --no-cache \
	jpegoptim \
	pngquant \
	optipng \
	freetype-dev \
	icu-dev \
	mysql-client \
	php7-zip

# Configuration & Install Extension
RUN docker-php-ext-configure \
	opcache --enable-opcache &&\
	docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/use/include/ && \
	docker-php-ext-install \
	opcache \
	mysqli \
	pdo \
	pdo_mysql \
	sockets \
	json \
	intl \
	gd \
	xml \
	zip \
	bz2 \
	pcntl \
	bcmath

COPY ./app/opcache.ini $PHP_INI_DIR/conf.d/
COPY ./app/php.ini $PHP_INI_DIR/conf.d/

# Add Composer
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="$PATH:/root/.composer/vendor/bin"

# Setup Working Dir
WORKDIR /home/

# Install Laravel
RUN composer global require laravel/installer
#RUN composer create-project --prefer-dist laravel/laravel laravel
#RUN laravel new laravel

# Remove Build Dependencies
RUN apk del -f .build-deps

# Change php-fpm port
#RUN sed -i 's/9000/8081/' /usr/local/etc/php-fpm.d/zz-docker.conf
#RUN sed -i 's/:9000/:8081/' /usr/local/etc/php-fpm.d/www.conf

#EXPOSE 8081

CMD ["php-fpm"]
