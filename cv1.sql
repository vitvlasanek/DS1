--vyhledat všechny informace o všech hercích
SELECT * FROM actor;
-- vyhledat jména a přijímení  všech herců
SELECT first_name, last_name FROM actor;
--vyhledat jména a přijímení herců se jménem JOHNNY
SELECT first_name, last_name FROM actor WHERE first_name = 'JOHNNY';
--vyhledat jména a přijímení herců, jejichž jména začínají na 'J'
SELECT first_name, last_name FROM actor WHERE first_name LIKE 'J%';
SELECT first_name, last_name FROM actor WHERE first_name LIKE '%J';
SELECT first_name, last_name FROM actor WHERE first_name LIKE '%J%';
--vyhledat jména a přijímení herců, jejichž jména začínají na J a příjímení je PITT
SELECT first_name, last_name FROM actor WHERE first_name LIKE 'J%' AND (last_name='PITT' OR last_name = 'DAVIS');
SELECT first_name, last_name FROM actor WHERE first_name LIKE 'J%' AND (last_name='PITT' OR last_name = 'DAVIS');
--vyhledat herce, jejichž příjímení je PITT, DAVIS, CHASE nebo GUINESS;
SELECT first_name, last_name FROM actor WHERE last_name NOT IN ('PITT','DAVIS', 'CHASE', 'GUINESS');
SELECT first_name, last_name FROM actor WHERE last_name!='PITT' AND last_name!='DAVIS' AND last_name!='CHASE' AND last_name!='GUINESS'
--vyhledejte názvy filmů, které jsou delší než 60 minut, ale kratší než 90 minut.
SELECT title FROM film WHERE length>60 AND length<90;
SELECT title FROM film WHERE length BETWEEN 61 and 89;
--výsledek utřiďte od nejdelšího po nejkratší
SELECT title, length FROM film WHERE length>60 AND length<90 ORDER BY length DESC, title ASC;
--vypište vlastnosti všech filmů a utřiďte je od A-Z
SELECT special_features FROM film ORDER BY special_features ASC;
--odstraňte opakující se hodnoty
SELECT DISTINCT special_features, title FROM film ORDER BY special_features ASC;
--NULL
SELECT * FROM rental WHERE return_date IS NULL;
--vypište počet filmů v tabulce film
SELECT count(*) FROM film
SELECT count(length) FROM film
SELECT count(DISTINCT special_features) FROM film
--vypište minimální, maximální, průměrnou a celkovou délku všech filmů
SELECT MIN(length) AS minimální, MAX(length) AS maximální, AVG(length) as průměrná, SUM(length) as celková FROM film
--vypište názvy všech filmů 
SELECT title, name FROM film JOIN language ON film.language_id = language.language_id;
