DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамиль', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
	
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), # DEFAULT 'requested',
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзья
-- ALTER TABLE friend_requests 
-- ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    -- file BLOB,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk.media(id);

ALTER TABLE vk.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);

/*
 * Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)
 */
USE vk;

DROP TABLE IF EXISTS roles_description;
CREATE TABLE roles_description(
	id SERIAL,
	role_name VARCHAR(50),
    permissions TEXT
);

USE vk;

DROP TABLE IF EXISTS users_roles;
CREATE TABLE users_roles(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    role_id BIGINT UNSIGNED NOT NULL,
    granted_at DATETIME DEFAULT NOW()
);

ALTER TABLE vk.users_roles 
ADD CONSTRAINT user_role_fk 
FOREIGN KEY (user_id) REFERENCES vk.users(id);

ALTER TABLE vk.users_roles 
ADD CONSTRAINT role_desc_fk 
FOREIGN KEY (role_id) REFERENCES vk.roles_description(id);

/*
 * Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) (INSERT)
 * */

INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) 
VALUES 
('Karl', 'Karl', 'test1@example.net', '1'),
('Andrew', 'Andrew', 'test2@example.net', '2'),
('Andrey', 'Andrey', 'test3@example.net', '3'),
('Dmitriy', 'Dmitriy', 'test4@example.net', '4'),
('Danil', 'Danil', 'test5@example.net', '5'),
('Nikolay', 'Nikolay', 'test6@example.net', '6'),
('Fedor', 'Fedor', 'test7@example.net', '7'),
('Zakhar', 'Zakhar', 'test8@example.net', '8'),
('Anastasiya', 'Anastasiya', 'test9@example.net', '9'),
('Alena', 'Alena', 'test10@example.net', '10');

INSERT INTO `messages` (`from_user_id`, `to_user_id`, `body`) 
VALUES 
('1', '2', 'test1'),
('2', '1', 'test2'),
('3', '4', 'test3'),
('4', '1', 'test4'),
('6', '8', 'test5'),
('7', '5', 'test6'),
('9', '2', 'test7'),
('8', '5', 'test8'),
('3', '1', 'test9'),
('4', '5', 'test10');

/*
 *  Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = true).
 * При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0)
 * */

ALTER TABLE profiles ADD COLUMN is_active BIT default 0;

ALTER TABLE vk.media MODIFY COLUMN metadata json DEFAULT NULL;

INSERT INTO `media_types` (`name`) 
VALUES 
('image');

INSERT INTO `media`  (`media_type_id`, `user_id`, `body`, `filename`, `size`) 
VALUES 
('1', '1', 'text', 'test1', '10'),
('1', '2', 'text', 'test2', '10'),
('1', '3', 'text', 'test3', '10'),
('1', '4', 'text', 'test4', '10'),
('1', '5', 'text', 'test5', '10'),
('1', '6', 'text', 'test6', '10'),
('1', '7', 'text', 'test7', '10'),
('1', '8', 'text', 'test8', '10'),
('1', '9', 'text', 'test9', '10'),
('1', '10', 'text', 'test10', '10');

INSERT INTO `profiles` (`user_id`, `gender`, `birthday`, `photo_id`, `hometown`) 
VALUES 
('1', 'M', '1997-12-18', '1', 'Moscow'),
('2', 'M', '2001-11-12', '2', 'Nofosibirsk'),
('3', 'M', '2008-02-18', '3', 'Moscow'),
('4', 'M', '2009-01-08', '4', 'St. Peterburg'),
('5', 'M', '2010-12-18', '5', 'Novgorod'),
('6', 'M', '2015-03-11', '6', 'Perm'),
('7', 'M', '1994-07-06', '7', 'Moscow'),
('8', 'M', '1996-03-08', '8', 'Moscow'),
('9', 'F', '2016-10-13', '9', 'Nofosibirsk'),
('10', 'F', '2001-09-13', '10', 'Nofosibirsk');

UPDATE profiles as p, (select user_id from profiles where TIMESTAMPDIFF(YEAR, birthday, curdate()) < 18) as s
SET 
	p.is_active = 1 
WHERE p.user_id = s.user_id;

/*
 * Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
 */

delete from messages
where created_at > now();