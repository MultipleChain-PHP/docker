FROM php:8.1-cli

# Install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Download composer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        unzip \
        && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN composer config --global --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true 
RUN composer global require --dev squizlabs/php_codesniffer=* 
RUN composer global require slevomat/coding-standard --update-with-all-dependencies
RUN /root/.composer/vendor/bin/phpcs --config-set installed_paths /root/.composer/vendor/squizlabs/php_codesniffer,/root/.composer/vendor/slevomat/coding-standard
ENV PATH="${PATH}:/root/.composer/vendor/bin"

COPY ./packages /usr/src/packages
