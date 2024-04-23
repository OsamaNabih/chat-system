#!/bin/bash
# Script only runs if mysql_data does not exist (1st time creating container)echo "============ STARTUP ============"
echo "=========== INIT SCRIPT ============"
echo "Creating Database: ${MYSQL_DATABASE}_${RAILS_ENV}"

mysql -u${DB_USERNAME} -p${MYSQL_PASSWORD} <<EOF
CREATE DATABASE ${MYSQL_DATABASE};
EOF