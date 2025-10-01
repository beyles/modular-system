# Use official PHP 8.2 with Apache
FROM php:8.2-apache

# Install required PHP extensions
RUN docker-php-ext-install pdo pdo_mysql

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer.json (no composer.lock yet)
COPY composer.json ./

# Install dependencies
RUN composer install --no-dev --no-scripts --no-progress --prefer-dist --optimize-autoloader || true

# Copy the rest of the project
COPY . .

# ✅ Change Apache DocumentRoot to Symfony public/
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's|/var/www/|/var/www/html/public|g' /etc/apache2/apache2.conf
RUN a2enmod rewrite

# Permissions (make sure Apache can read public/)
RUN chown -R www-data:www-data /var/www/html

# Run composer again to finish setup
RUN composer install --no-dev --optimize-autoloader || true

EXPOSE 80

CMD ["apache2-foreground"]
