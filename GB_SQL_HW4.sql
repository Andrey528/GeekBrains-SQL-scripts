/*
Подсчитать количество групп (сообществ), в которые вступил каждый пользователь.
*/

use vk;

select u.id, count(uc.community_id)
from users_communities uc 
left join users u on uc.user_id = u.id
group by u.id
union
select u2.id, count(uc2.community_id) 
from users_communities uc2 
right join users u2 on uc2.user_id = u2.id
group by u2.id;

/*
Подсчитать количество пользователей в каждом сообществе.
*/

select c.name, count(uc.user_id) as users_count
from users_communities uc
inner join communities c on uc.community_id = c.id 
group by uc.community_id;

/*
Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите 
человека, который больше всех общался с выбранным пользователем (написал ему 
сообщений).
*/

select m.from_user_id, count(m.to_user_id) as message_count
from messages m 
where m.to_user_id = 1
group by m.from_user_id 
order by count(m.to_user_id) desc
limit 1;

/*
Подсчитать общее количество лайков, которые получили пользователи младше 18 
лет
*/

select sum(count(l.user_id)) over() as total_count
from likes l 
inner join profiles p on l.user_id = p.user_id
WHERE (birthday + INTERVAL 18 YEAR) > NOW()
group by l.user_id;

/*
Определить кто больше поставил лайков (всего): мужчины или женщины.
*/

select p.gender, count(p.gender)
from likes l 
inner join profiles p on l.user_id = p.user_id
group by p.gender
order by count(p.gender) desc
limit 1;