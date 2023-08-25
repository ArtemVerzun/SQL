# Вставка с пополнением справочников (вставляется информация об дереве, 
# если указанный тип дерева отсутствует в БД, запись добавляется в таблицу с перечнем типов дерева)
delimiter //
create procedure ins_tree (type_name varchar(20),date_of_cultivate_ date ,date_of_cut_ date)
begin
declare type_of_tr_id_new int;
declare tree_id_new int;
if exists(select * from type_of_tree 
where breed = type_name)
	then select type_of_tree_id into type_of_tr_id_new 
    from type_of_tree where breed = type_name;
    else begin
    set type_of_tr_id_new = (select ifnull(max(type_of_tree_id)+1,0)
    from type_of_tree);
    insert into type_of_tree(type_of_tree_id, breed)
    values (type_of_tr_id_new, type_name);
   	       end;
    end if;
    set tree_id_new = (select ifnull(max(tree_id)+1,0) 
    from tree);
    insert into tree (tree_id,type_of_tree_id,date_of_cultivate,date_of_cut)
    values (tree_id_new,type_of_tr_id_new, date_of_cultivate_ ,date_of_cut_);
    end;//
    delimiter ;
call ins_tree('уникальная','2015-10-05','2021-10-21');
SELECT * FROM tree;
# Удаление с отчисткой справочников (удаляется информация о дереве, если у типа этого дерева 
# нет больше других деревьев, запись удаляется из таблицы с перечнем типов деревьев)
delimiter //
create procedure del_tree_clear_type (id_tree_del int)
begin
declare id_type_del int;
select type_of_tree_id into id_type_del
from tree 
where tree_id = id_tree_del;
delete from tree 
where tree_id = id_tree_del;
if not exists (select * from tree
where type_of_tree_id = id_type_del)
then delete from type_of_tree
where type_of_tree_id = id_type_del;
end if;
end;//
delimiter ;
call del_tree_clear_type (5); 
SELECT * FROM type_of_tree;
# Процедура каскадного удаления 
# (перед удалением типа дерева, удаляются записи обо всех деревьях этого типа)
 delimiter //
create procedure del_type_of_tree_cascade (id_type_del int)
begin
delete from tree_of_alley where tree_id in
(select tree_id from tree where type_of_tree_id = id_type_del);

delete from tree 
	where type_of_tree_id = id_type_del;
delete from type_of_tree 
	where type_of_tree_id = id_type_del;
end;//
delimiter ;
call del_type_of_tree_cascade (5); 
SELECT * FROM tree;


# Процедура вычисления и возврат значения агрегатной функции (возврат количества типов деревьев)
delimiter ;
use garden;
delimiter //
create procedure count_types (out cnt_type int)
begin
select ifnull(count(type_of_tree_id),0) into cnt_type 
from type_of_tree;
end;//
delimiter ;
call count_types( @cnt);
select @cnt;

delimiter //
create function count_types1() returns int deterministic
begin
declare cnt_type int default 0;
set cnt_type = (select ifnull(count(type_of_tree_id),0) 
from type_of_tree);
return cnt_type;
end;//
delimiter ;
select count_types1();

# для каждой породы количество деревьев данной породы, кол во пород всего
delimiter //
create procedure tree_statistics()
begin
create temporary table if not exists tree_stat
(
id_stat int auto_increment primary key,
type_of_tree_id int,
count_tree int
);
insert into tree_stat (type_of_tree_id, count_tree)
select type_of_tree.type_of_tree_id, 
count(tree_id) as count_tree
from type_of_tree
left join tree
on type_of_tree.type_of_tree_id = tree.type_of_tree_id
group by type_of_tree.type_of_tree_id;

select max(count_tree) as max_tree from 
(select type_of_tree.type_of_tree_id, 
count(tree_id) as count_tree
from type_of_tree
left join tree
on type_of_tree.type_of_tree_id = tree.type_of_tree_id
group by type_of_tree.type_of_tree_id) q;

select count(type_of_tree_id) from type_of_tree;

select * from tree_stat;

drop table tree_stat;
end;//
delimiter ;
call tree_statistics();
DROP procedure  IF EXISTS  ins_tree;