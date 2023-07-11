/*
Написать скрипт, возвращающий список имен (только firstname) пользователей 
без повторений в алфавитном порядке. [ORDER BY]
*/

use vk;

select distinct firstname
from users
order by firstname;

/*
 * Выведите количество мужчин старше 35 лет [COUNT].
*/

select count(*) 
from profiles
WHERE (birthday + INTERVAL 35 YEAR) > NOW();

/*
 * Сколько заявок в друзья в каждом статусе? (таблица friend_requests) 
 * [GROUP BY]
*/

select status, count(*)
from friend_requests
group by status;

/*
 * Выведите номер пользователя, который отправил больше всех заявок в друзья 
 * (таблица friend_requests) [LIMIT].
*/

select initiator_user_id, count(initiator_user_id) 
from friend_requests
group by initiator_user_id 
order by count(initiator_user_id) desc
limit 1;

/*
 * Выведите названия и номера групп, имена которых состоят из 
 * 5 символов [LIKE].
*/

select id, name
from communities
where name like '_____'