SELECT product_name, manufacturer, price FROM geekbrains.mobile_phones
WHERE product_count > 2;

SELECT product_name, product_count, price FROM geekbrains.mobile_phones
WHERE manufacturer = 'Samsung';

SELECT * FROM geekbrains.mobile_phones
WHERE product_name
LIKE 'Iphone%';

SELECT * FROM geekbrains.mobile_phones
WHERE product_name
REGEXP 'Samsung';

SELECT * FROM geekbrains.mobile_phones
WHERE product_name
REGEXP '[0-9]';

SELECT * FROM geekbrains.mobile_phones
WHERE product_name
REGEXP '[8]';