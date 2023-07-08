/*
Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров, количество которых превышает 2
*/
SELECT product_name, manufacturer, price FROM geekbrains.mobile_phones
WHERE product_count > 2;

/*
Выведите SELECT-запросом весь ассортимент товаров марки “Samsung”
*/
SELECT product_name, product_count, price FROM geekbrains.mobile_phones
WHERE manufacturer = 'Samsung';

/*
Товары, в которых есть упоминание "Iphone"
*/
SELECT * FROM geekbrains.mobile_phones
WHERE product_name
LIKE '%Iphone%';

/*
Товары, в которых есть упоминание "Samsung"
*/
SELECT * FROM geekbrains.mobile_phones
WHERE product_name
REGEXP 'Samsung';

/*
Товары, в названии которых есть ЦИФРЫ
*/
SELECT * FROM geekbrains.mobile_phones
WHERE product_name
REGEXP '[0-9]';

/*
Товары, в названии которых есть ЦИФРА "8"
*/
SELECT * FROM geekbrains.mobile_phones
WHERE product_name
REGEXP '[8]';