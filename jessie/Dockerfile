FROM debian:jessie

RUN rm -f /etc/apt/apt.conf.d/no-cache
RUN echo 'Acquire::http { Proxy "http://172.17.0.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy

ENV MYSQL_USER=mysql \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql

RUN apt-get update
RUN apt-get install -y debconf-utils vim
RUN echo mysql-server-5.5 mysql-server/root_password password root | debconf-set-selections \
    && echo mysql-server-5.5 mysql-server/root_password_again password root | debconf-set-selections \
    && apt-get -y install -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing mysql-server mysql-client 

ADD mysql-listen.cnf /etc/mysql/conf.d/mysql-listen.cnf

EXPOSE 3306

CMD ["/bin/bash"]
