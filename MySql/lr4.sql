select distinct alley.alley_id, name_alley from alley
inner join tree_of_alley on tree_of_alley.alley_id = alley.alley_id 
inner join tree on tree.tree_id = tree_of_alley.tree_id
inner join type_of_tree on type_of_tree.type_of_tree_id = tree.type_of_tree_id
where type_of_tree.breed like '%Дуб%';

select toa.tree_id  from tree_of_alley as tree_of_alley_2
inner join tree_of_alley as toa on toa.tree_id = tree_of_alley_2.tree_id 
and toa.alley_id != tree_of_alley_2.alley_id 
group by toa.tree_id;


select type_of_tree.type_of_tree_id, breed from type_of_tree
left join tree on tree.type_of_tree_id = type_of_tree.type_of_tree_id
where tree.tree_id is null;







