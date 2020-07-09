CREATE DATABASE wordpress;

CREaTE DATABASE phpmyadmin;

GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost';

GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'root'@'localhost';

FLUSH PRIVILEGES;

update mysql.user set plugin = 'mysql_native_password' where user='root';