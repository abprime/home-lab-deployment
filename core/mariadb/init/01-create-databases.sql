-- Create databases
CREATE DATABASE IF NOT EXISTS nextcloud;
CREATE DATABASE IF NOT EXISTS ghost;

-- Create users and grant permissions
CREATE USER IF NOT EXISTS 'nextcloud'@'%' IDENTIFIED BY '${NEXTCLOUD_DB_PASSWORD}';
CREATE USER IF NOT EXISTS 'ghost'@'%' IDENTIFIED BY '${GHOST_DB_PASSWORD}';

-- Grant permissions
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'%';
GRANT ALL PRIVILEGES ON ghost.* TO 'ghost'@'%';

FLUSH PRIVILEGES;