/*
Написать функцию, которая удаляет всю информацию об указанном пользователе из 
БД vk. Пользователь задается по id. Удалить нужно все сообщения, лайки, медиа 
записи, профиль и запись из таблицы users. Функция должна возвращать номер 
пользователя.
*/
use vk;

ALTER TABLE likes
DROP CONSTRAINT likes_ibfk_2;

ALTER TABLE likes
ADD CONSTRAINT likes_ibfk_2
    FOREIGN KEY (media_id)
    REFERENCES media (id)
    ON DELETE CASCADE;
   
ALTER TABLE profiles 
DROP CONSTRAINT profiles_ibfk_2;

ALTER TABLE profiles 
ADD CONSTRAINT profiles_ibfk_2
    FOREIGN KEY (photo_id)
    REFERENCES media (id)
    ON DELETE CASCADE;
   
ALTER TABLE friend_requests  
DROP CONSTRAINT friend_requests_ibfk_1;

ALTER TABLE friend_requests 
ADD CONSTRAINT friend_requests_ibfk_1
    FOREIGN KEY (initiator_user_id)
    REFERENCES users (id)
    ON DELETE CASCADE;
   
ALTER TABLE users_communities  
DROP CONSTRAINT users_communities_ibfk_1;

ALTER TABLE users_communities  
ADD CONSTRAINT users_communities_ibfk_1
    FOREIGN KEY (user_id)
    REFERENCES users (id)
    ON DELETE CASCADE;

drop function if exists func_user_info_delete;

DELIMITER //
create function func_user_info_delete(user_id_for_delete bigint unsigned)
returns bigint DETERMINISTIC
	begin
		delete
		from messages
		where from_user_id = user_id_for_delete or to_user_id = user_id_for_delete;
	
		delete
		from media
		where user_id = user_id_for_delete;
	
		delete
		from profiles 
		where user_id  = user_id_for_delete;
	
		delete
		from likes 
		where user_id = user_id_for_delete;
	
		delete
		from friend_requests  
		where initiator_user_id  = user_id_for_delete or target_user_id = user_id_for_delete;			

		delete
		from users_communities  
		where user_id = user_id_for_delete;
	
		delete
		from users 
		where id = user_id_for_delete;
		
		return user_id_for_delete;
	end//
DELIMITER ;

select func_user_info_delete(2);
	
/*
Предыдущую задачу решить с помощью процедуры и обернуть используемые команды 
в транзакцию внутри процедуры
*/

DROP PROCEDURE IF EXISTS `delete_user_info`;

DELIMITER //
create procedure `delete_user_info` (delete_user_id bigint unsigned, out tran_result varchar(200))
begin
	DECLARE `_rollback` BOOL DEFAULT 0;
   	DECLARE code varchar(100);
   	DECLARE error_string varchar(100);
	DECLARE CONTINUE HANDLER FOR sqlexception
	
	begin
    	set `_rollback` = 1;
    	get stacked DIAGNOSTICS CONDITION 1
    		code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
    	set tran_result := concat('Error occured. Code: ', code, '. Text: ', error_string);
    end;
	
	start transaction;
		delete
		from messages
		where from_user_id = delete_user_id or to_user_id = delete_user_id;
	
		delete
		from media
		where user_id = delete_user_id;
	
		delete
		from profiles 
		where user_id  = delete_user_id;
	
		delete
		from likes 
		where user_id = delete_user_id;
	
		delete
		from friend_requests  
		where initiator_user_id  = delete_user_id or target_user_id = delete_user_id;			

		delete
		from users_communities  
		where user_id = delete_user_id;
	
		delete
		from users 
		where id = delete_user_id;
	
		if `_rollback` then
			rollback;
		else
			set tran_result := concat('Ok. Id: ', delete_user_id);
			commit;
		end if;
end//
delimiter ;

call delete_user_info(3, @tran_result);

select @tran_result;

/*
Написать триггер, который проверяет новое появляющееся сообщество. Длина 
названия сообщества (поле name) должна быть не менее 5 символов. Если 
требование не выполнено, то выбрасывать исключение с пояснением.
*/

drop TRIGGER if exists check_new_communities_name;

DELIMITER //

CREATE TRIGGER check_new_communities_name BEFORE INSERT ON communities
FOR EACH ROW
begin
    IF length(NEW.name) <= 5 THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Обновление отменено. Название нового сообщества должно быть 5 или более символов';
    END IF;
END//

DELIMITER ;

insert into `communities` (`id`, `name`)
values
('15', 'vgg');