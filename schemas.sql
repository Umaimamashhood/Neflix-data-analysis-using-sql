-- NETFLIX PROJECT
drop table if exists netflix;
create table netflix
( show_id VARCHAR(6),
type varchar(10),
title varchar(150),
director varchar(250),
casts varchar(1000),
country varchar(150),
data_added varchar(50),
release_year int,
rating varchar(15),
duration varchar(15),
listed_in varchar(100),
description varchar(250)
);

select * from netflix;
