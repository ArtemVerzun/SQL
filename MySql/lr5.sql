# дерево, которое было посажено позже всех 
select t.tree_id as id, date_of_cultivate from tree as t
where date_of_cultivate >= all(select date_of_cultivate from tree);


# порода, деревьев которой меньше всего 
select q.breed from (select tot.breed, count(1) as c from type_of_tree as tot
join tree as t on t.type_of_tree_id = tot.type_of_tree_id group by t.type_of_tree_id 
having c = (select min(q.c) from 
(select count(1) as c from type_of_tree as tot
join tree as t on t.type_of_tree_id = tot.type_of_tree_id 
group by t.type_of_tree_id) as q)) as q;



#порода, встр на всех аллеях парка
select breed from type_of_tree
where not exists (select * from alley where alley.garden_id=1 
and not exists (select * from type_of_tree tot 
join tree t on t.type_of_tree_id = tot.type_of_tree_id 
join tree_of_alley at on at.tree_id = t.tree_id 
where type_of_tree.type_of_tree_id = tot.type_of_tree_id 
and alley.alley_id = at.alley_id));


# left join
select distinct q1.alley_id from 
(select  tot.type_of_tree_id, t.tree_id, a.alley_id from type_of_tree as tot
join tree as t on t.type_of_tree_id = tot.type_of_tree_id
join tree_of_alley as a on a.tree_id = t.tree_id where  tot.type_of_tree_id = 1) as q1 
left join (select tot.type_of_tree_id, a.alley_id from type_of_tree as tot
join tree as t on t.type_of_tree_id = tot.type_of_tree_id
join tree_of_alley as a on a.tree_id = t.tree_id where tot.type_of_tree_id = 3) as q2 on q1.alley_id = q2.alley_id 
where q2.type_of_tree_id is NULL;

# not in
select distinct a.alley_id from type_of_tree as tot
join tree as t on t.type_of_tree_id = tot.type_of_tree_id
join tree_of_alley as a on a.tree_id = t.tree_id
where a.alley_id not in 
(select a.alley_id from type_of_tree as tot join tree as t on t.type_of_tree_id = tot.type_of_tree_id join tree_of_alley as a
 on a.tree_id = t.tree_id where tot.type_of_tree_id = 3) and tot.type_of_tree_id = 1;

