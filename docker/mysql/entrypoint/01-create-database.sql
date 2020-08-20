--create databases
CREATE DATABASE IF NOT EXISTS `my-app`;

--create root user and grant rights
CREATE USER 'root'@'localhost' IDENTIFIED BY 'development';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';