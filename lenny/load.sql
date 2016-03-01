create database testing;
create table testing.users(id int not null auto_increment, primary key(id), username varchar(30) not null);
insert into testing.users (username) values ('foo');
insert into testing.users (username) values ('bar');
