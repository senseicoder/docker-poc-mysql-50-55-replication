# docker-poc-mysql-50-55-replication
test replication between Mysql 5.0 master and Mysql 5.5 slave

Ouvrir un terminal sur jessie, un sur lenny. Dans chacun, lancer bash build.sh
Dans chaque terminal, une fois les containers connectés, lancer : mysqld&
Ouverture du shell mysql : mysql

sur lenny, créer une bdd::

cat /load.sql | mysql

créer l'utilisateur, sur lenny:: 

CREATE USER 'slaveprobdd1'@'%' IDENTIFIED BY 'root';
GRANT REPLICATION SLAVE ON *.* TO "slaveprobdd1"@"%";
STOP SLAVE;
FLUSH PRIVILEGES;
FLUSH TABLES WITH READ LOCK;
SHOW MASTER STATUS\G

dumper la bdd, sur lenny::

ssh bdd-01 mysqldump --routines --single-transaction --force --add-drop-table --add-locks --skip-comments --complete-insert --delayed-insert --disable-keys --max_allowed_packet=512M --default-character-set="UTF8" --lock-tables=true --single-transaction --databases $(db | grep -v -e ^mysql$ -e ^information_schema$ -e ^performance_schema$ | xargs) --flush-privileges > ~/dump.sql

dump sur bdd-02::

for i in $(db | grep -v -e ^mysql$ -e ^information_schema$ -e ^performance_schema$ | grep CHEZSOI ); do mysqldump --routines --single-transaction --force --add-drop-table --add-locks --skip-comments --complete-insert --delayed-insert --disable-keys --max_allowed_packet=512M --default-character-set="UTF8" --lock-tables=true --single-transaction $i | gzip > $i.sql.gz; done

redémarrer les écritures sur lenny, créer une table::

UNLOCK TABLES;
START SLAVE;
SHOW SLAVE STATUS\G
create table testing.pendant (a int(10));

copier le fichier

docker cp determined_mccarthy:/root/dump.sql .
docker cp dump.sql sharp_joliot:/root/dump.sql

charger la bdd sur jessie::

cat dump.sql | mysql -uroot -proot --max_allowed_packet=512M --default-character-set="UTF8"

démarrer la réplication sur jessie::

SLAVE STOP;
CHANGE MASTER TO MASTER_HOST='172.17.0.3', MASTER_USER='slaveprobdd1', MASTER_PASSWORD='root', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=1034;
START SLAVE;
SHOW SLAVE STATUS\G

créer une table sur lenny::

create table testing.apres (a int(10));

vérifier qu'on a les trois tables sur jessie::

show tables from testing;