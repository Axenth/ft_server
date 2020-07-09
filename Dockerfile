# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: jlensing <jlensing@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2020/02/22 18:12:19 by jlensing      #+#    #+#                  #
#    Updated: 2020/04/17 15:00:08 by axenth        ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

# INSTALL
RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx mariadb-server php7.3 php-mysql php-fpm php-cli php-mbstring wget


# COPY CONTENT
COPY ./srcs/start.sh /var/
COPY ./srcs/mysql_setup.sql /var/
COPY ./srcs/wordpress.sql /var/
COPY ./srcs/wordpress.tar.gz /var/www/html/
COPY ./srcs/nginx.conf /etc/nginx/sites-available/localhost
COPY ./srcs/php.ini /etc/php/7.3/fpm
COPY ./srcs/phpmyadmin.sql /var/
COPY ./srcs/autoindex.sh /var/www/html
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost


WORKDIR /var/www/html

# INSTALL WORDPRESS
RUN tar xf ./wordpress.tar.gz && rm -rf wordpress.tar.gz


# INSTALL PHPMYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english wordpress/phpmyadmin
COPY ./srcs/config.inc.php wordpress/phpmyadmin


RUN service mysql start && mysql -u root mysql < /var/mysql_setup.sql && mysql phpmyadmin -u root --password= < /var/phpmyadmin.sql && mysql wordpress -u root --password= < /var/wordpress.sql
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=EN/ST=75/L=Amsterdam/O=42/CN=jlensing' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt
RUN chown -R www-data:www-data *
RUN chmod 755 -R *

CMD bash /var/start.sh

EXPOSE 80 443
