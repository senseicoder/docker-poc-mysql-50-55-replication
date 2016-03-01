FROM debian:jessie

RUN rm -f /etc/apt/apt.conf.d/no-cache
RUN echo 'Acquire::http { Proxy "http://172.17.0.1:3142"; };' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get update
RUN apt-get -y install vim mysql-server mysql-client

#RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
ADD mysql-listen.cnf /etc/mysql/conf.d/mysql-listen.cnf

EXPOSE 3306

CMD ["/usr/sbin/mysqld"]
