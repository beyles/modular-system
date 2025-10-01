# Use official PHP 8.2 with Apache
FROM php:8.2-apache

# Install required extensions for Symfony
RUN docker-php-ext-install pdo pdo_mysql

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Install Symfony dependencies
RUN composer install --no-dev --optimize-autoloader

# Enable Apache mod_rewrite for Symfony routing
RUN a2enmod rewrite
RUN service apache2 restart

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
