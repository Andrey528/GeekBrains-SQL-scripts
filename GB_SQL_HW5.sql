/*
Создадим представление, подсчитывающие количество групп (сообществ), в которые вступил 
каждый пользователь.
*/
create or replace view v_group_per_user as
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
 * Выведите данные, используя написанное представление
 */

select *
from v_group_per_user;

/*
 * Удаление представления
 */

DROP VIEW v_group_per_user;

/*
 * Сколько новостей (записей в таблице media) у каждого пользователя? 
 * Вывести поля: news_count (количество новостей), user_id (номер 
 * пользователя), user_email (email пользователя). Попробовать решить с 
 * помощью CTE или с помощью обычного JOIN.
 */

with cte_news_per_user(user_id, news_count) as (
	select user_id, count(user_id) as news_count
	from media
	group by user_id
)
select c.*, u.email
from cte_news_per_user c
join users u on u.id = c.user_id;