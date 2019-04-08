ARG MYSQL_VERSION

FROM mysql:${MYSQL_VERSION}
ADD ./mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
COPY ./mysql/root/ /root/
