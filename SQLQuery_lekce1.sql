SELECT email FROM customer WHERE active = 0


--Vypište názvy a popisy všech filmù s klasifikací G sestupnì podle názvu filmù
SELECT title, description
FROM film
WHERE rating = 'G'
ORDER BY title DESC

--vypište všechny údaje o platbách které probìhly v roce 2006 neboo èástka byla menší než 2
SELECT * FROM payment WHERE amount < 2 AND payment_date >= '2006-01-01'

--vypište popisy všech filmù klasifikovaných jako G nebo PG
SELECT description FROM film WHERE rating = 'G' OR rating = 'PG'
SELECT description FROM film WHERE rating IN ('G', 'PG');

--vypište všechny údaje filmù, jejichž délka pøesahuje 50 min a doba výpujèky je 3 nebo 5 dní
SELECT * FROM film where length >50 AND rental_duration IN (3, 5)

--vypište názvy filmù, které obsahují RAINBOW nebo zaèínají na TEXAS a jejich délka pøesahuje 70 min.
SELECT title FROM film WHERE title LIKE '%RAINBOW%' OR title LIKE 'TEXAS%' AND length > 70
SELECT title FROM film WHERE (title LIKE '%RAINBOW%' OR title LIKE 'TEXAS%') AND length > 70

--vypište názvy všech filmù, v jejichž popisu se vyskytuje "and" a jejich délka spadá do intervalu 80 a 90 min a standartní doba vypùjèky je liché èíslo
SELECT title FROM film WHERE description LIKE '%And%' AND length BETWEEN 80 AND 90 AND rental_duration%2 = 1

--vypište vlastnosti všech filmù, kde èástka za náhradu škody je v intervalu 14 a 16. Zajistìte, aby se vlastnosti ve výpisu neopakovaly. SetøiÏte vybrané vlastnosti abecednì.
SELECT DISTINCT special_features FROM film WHERE replacement_cost BETWEEN 14 AND 16 ORDER BY special_features

--Vypište všechny údaje filmù, jejichž standartní doba výpùjèky je menší než 4 dny, nebo jsou klasifikovány jako PG ne však OBÌ zároveò
SELECT * FROM film 
WHERE rental_duration < 4 AND rating != 'PG' 
OR rental_duration >= 4 AND rating = 'PG'

--vypište údaje o adresách, které mají vyplnìno PSÈ
SELECT * FROM address WHERE postal_code IS NOT NULL;

--vypište ID všechzákazníkù, kteøí aktuálnì mají vypùjèený nìjaký film. Dokázali byste spoèítat kolik takových zákazníkù je
SELECT customer_id FROM rental WHERE return_date IS NULL

--Pro každé ID platby vypište v samostatných sloupcích rok, mìsíc a den, kdy platba probìhla. sloupce vhodnì pojmenujte
SELECT payment_id, YEAR(payment_date) AS rok, MONTH(payment_date) as mesic, DAY(payment_date) AS den FROM payment

--vypište filmy, jejichž délka názvu není 20 znakù
SELECT * FROM film WHERE LEN(title) != 20;

--pro kazdou ukonèenou vypujèku (její ID) vypište dobu jejího trvání v minutách
SELECT rental_id, DATEDIFF(minute, rental_date, return_date) AS minuty
FROM rental WHERE return_date IS NOT NULL

--pro každého aktivního zákazníka vypište celé jeho jméno v jednom sloupci. výstup tedy bude obsahovat dva sloupce
SELECT customer_id, first_name + ' ' + last_name as full_name FROM customer WHERE active = 1

--PRO všechny uzavøené výpujèky vypište v jednom sloupci interval od - do, kdy pùjèka probìhla
SELECT rental_id, CAST(rental_date AS VARCHAR) +' - '+ CAST(return_date AS VARCHAR) AS od_do FROM rental WHERE return_date IS NOT NULL

--PRO všechny uzavøené výpujèky vypište v jednom sloupci interval od - do, kdy pùjèka probìhla. Pokud nebyla vrácena, vypište pouze daum od
SELECT rental_id, CAST(rental_date AS VARCHAR) + COALESCE(' - '+ CAST(return_date AS VARCHAR), '') AS od_do FROM rental

--pro každou adresu vypište PSÈ. Jestliže PSÈ nebude vyplnìno, bude se místo nìj zobrazovat text "(prázdné)"
SELECT address, COALESCE(postal_code, '(prázdné)') as PSC FROM address

--vypište poèet všech filmù v databázi
SELECT COUNT(*) AS pocet_filmu FROM film

--vypište poèet rùzných klasifikací filmù (atribut rating)
SELECT COUNT(DISTINCT rating) AS pocet_kategorii FROM film

--vypište jedním dotazem poèet adres, poèet adras s vyplnìným PSÈ a poèet rùzných PSÈ
SELECT COUNT(*) AS pocet_adres, COUNT(postal_code) AS adresy_s_PSC, COUNT(DISTINCT postal_code) AS ruzna_PSC  FROM address

--vypište nejmenší, nejvìtší a prùmìrnou délku všech filmù. Ovìøte si zjištìnou prùmìrnou délku pomocí podílu souètù a poètu
SELECT MIN(length) AS nejmensi, MAX(length) AS nejvetsi, AVG(CAST(length AS FLOAT)) as prumer, SUM((CAST(length AS FLOAT)))/COUNT((CAST(length AS FLOAT))) AS vypocteny_prumer FROM film

--vypiste pocet a soucet vsch plateb, které byly provedeny v roce 2005
SELECT COUNT(*) AS pocet, SUM(amount) AS soucet FROM payment WHERE YEAR(payment_date) = 2005

--vypiste celkový poèet znakù v názvech všech filmù
SELECT SUM(LEN(title)) as pocet_znaku FROM film
