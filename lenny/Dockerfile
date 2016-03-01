FROM pblaszczyk/debian-lenny

RUN rm -f /etc/apt/apt.conf.d/no-cache
RUN echo 'Acquire::http { Proxy "http://172.17.0.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update
RUN apt-get install -y debconf-utils vim
RUN echo mysql-server-5.0 mysql-server/root_password password root | debconf-set-selections \
    && echo mysql-server-5.0 mysql-server/root_password_again password root | debconf-set-selections \
    && apt-get -y install -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing mysql-server mysql-client 

ADD mysql-listen.cnf /etc/mysql/conf.d/mysql-listen.cnf
ADD load.sql /load.sql

EXPOSE 3306

CMD ["/usr/sbin/mysqld"]
