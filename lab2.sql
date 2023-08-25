drop database Garden;
create database Garden;
use Garden;
create table type_of_tree (
type_of_tree_id int primary key not null,
breed varchar(10) 
);
create table tree (
tree_id int primary key not null,
type_of_tree_id int not null,
date_of_cultivate date,
date_of_cut date,
foreign key (type_of_tree_id) references type_of_tree (type_of_tree_id) on delete no action on update cascade
);
create table garden (
garden_id int primary key not null,
name_garden varchar(15) 
);
create table alley (
alley_id int primary key not null,
garden_id int not null,
name_alley varchar(15),
foreign key (garden_id) references garden (garden_id) on delete cascade on update cascade
);

create table tree_of_alley (
tree_id int not null,
alley_id int not null,
primary key(tree_id, alley_id),
foreign key(tree_id) references tree(tree_id) on update no action on delete cascade,
foreign key(alley_id) references alley(alley_id) on update cascade on delete no action,
location int 
);
/*
alter table garden 
add second_name_garden varchar(30) null;
alter table garden
drop column second_name_garden;*/








