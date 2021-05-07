CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';

GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
ALTER USER 'admin'@'%' IDENTIFIED WITH mysql_native_password BY 'admin';

FLUSH PRIVILEGES;

use main;