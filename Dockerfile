# Use official PHP 8.2 with Apache
FROM php:8.2-apache

# Install required PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer.json only (no composer.lock yet)
COPY composer.json ./

# Install dependencies (this will generate composer.lock inside container)
RUN composer install --no-dev --no-scripts --no-progress --prefer-dist --optimize-autoloader || true

# Copy the rest of the project
COPY . .

# Run composer again with full setup
RUN composer install --no-dev --optimize-autoloader || true

# Enable Apache mod_rewrite for Symfony routing
RUN a2enmod rewrite
RUN service apache2 restart

EXPOSE 80

CMD ["apache2-foreground"]
