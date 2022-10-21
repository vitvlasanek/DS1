SELECT email FROM customer WHERE active = 0


--Vypi�te n�zvy a popisy v�ech film� s klasifikac� G sestupn� podle n�zvu film�
SELECT title, description
FROM film
WHERE rating = 'G'
ORDER BY title DESC

--vypi�te v�echny �daje o platb�ch kter� prob�hly v roce 2006 neboo ��stka byla men�� ne� 2
SELECT * FROM payment WHERE amount < 2 AND payment_date >= '2006-01-01'

--vypi�te popisy v�ech film� klasifikovan�ch jako G nebo PG
SELECT description FROM film WHERE rating = 'G' OR rating = 'PG'
SELECT description FROM film WHERE rating IN ('G', 'PG');

--vypi�te v�echny �daje film�, jejich� d�lka p�esahuje 50 min a doba v�puj�ky je 3 nebo 5 dn�
SELECT * FROM film where length >50 AND rental_duration IN (3, 5)

--vypi�te n�zvy film�, kter� obsahuj� RAINBOW nebo za��naj� na TEXAS a jejich d�lka p�esahuje 70 min.
SELECT title FROM film WHERE title LIKE '%RAINBOW%' OR title LIKE 'TEXAS%' AND length > 70
SELECT title FROM film WHERE (title LIKE '%RAINBOW%' OR title LIKE 'TEXAS%') AND length > 70

--vypi�te n�zvy v�ech film�, v jejich� popisu se vyskytuje "and" a jejich d�lka spad� do intervalu 80 a 90 min a standartn� doba vyp�j�ky je lich� ��slo
SELECT title FROM film WHERE description LIKE '%And%' AND length BETWEEN 80 AND 90 AND rental_duration%2 = 1

--vypi�te vlastnosti v�ech film�, kde ��stka za n�hradu �kody je v intervalu 14 a 16. Zajist�te, aby se vlastnosti ve v�pisu neopakovaly. Set�i�te vybran� vlastnosti abecedn�.
SELECT DISTINCT special_features FROM film WHERE replacement_cost BETWEEN 14 AND 16 ORDER BY special_features

--Vypi�te v�echny �daje film�, jejich� standartn� doba v�p�j�ky je men�� ne� 4 dny, nebo jsou klasifikov�ny jako PG ne v�ak OB� z�rove�
SELECT * FROM film 
WHERE rental_duration < 4 AND rating != 'PG' 
OR rental_duration >= 4 AND rating = 'PG'

--vypi�te �daje o adres�ch, kter� maj� vypln�no PS�
SELECT * FROM address WHERE postal_code IS NOT NULL;

--vypi�te ID v�echz�kazn�k�, kte�� aktu�ln� maj� vyp�j�en� n�jak� film. Dok�zali byste spo��tat kolik takov�ch z�kazn�k� je
SELECT customer_id FROM rental WHERE return_date IS NULL

--Pro ka�d� ID platby vypi�te v samostatn�ch sloupc�ch rok, m�s�c a den, kdy platba prob�hla. sloupce vhodn� pojmenujte
SELECT payment_id, YEAR(payment_date) AS rok, MONTH(payment_date) as mesic, DAY(payment_date) AS den FROM payment

--vypi�te filmy, jejich� d�lka n�zvu nen� 20 znak�
SELECT * FROM film WHERE LEN(title) != 20;

--pro kazdou ukon�enou vypuj�ku (jej� ID) vypi�te dobu jej�ho trv�n� v minut�ch
SELECT rental_id, DATEDIFF(minute, rental_date, return_date) AS minuty
FROM rental WHERE return_date IS NOT NULL

--pro ka�d�ho aktivn�ho z�kazn�ka vypi�te cel� jeho jm�no v jednom sloupci. v�stup tedy bude obsahovat dva sloupce
SELECT customer_id, first_name + ' ' + last_name as full_name FROM customer WHERE active = 1

--PRO v�echny uzav�en� v�puj�ky vypi�te v jednom sloupci interval od - do, kdy p�j�ka prob�hla
SELECT rental_id, CAST(rental_date AS VARCHAR) +' - '+ CAST(return_date AS VARCHAR) AS od_do FROM rental WHERE return_date IS NOT NULL

--PRO v�echny uzav�en� v�puj�ky vypi�te v jednom sloupci interval od - do, kdy p�j�ka prob�hla. Pokud nebyla vr�cena, vypi�te pouze daum od
SELECT rental_id, CAST(rental_date AS VARCHAR) + COALESCE(' - '+ CAST(return_date AS VARCHAR), '') AS od_do FROM rental

--pro ka�dou adresu vypi�te PS�. Jestli�e PS� nebude vypln�no, bude se m�sto n�j zobrazovat text "(pr�zdn�)"
SELECT address, COALESCE(postal_code, '(pr�zdn�)') as PSC FROM address

--vypi�te po�et v�ech film� v datab�zi
SELECT COUNT(*) AS pocet_filmu FROM film

--vypi�te po�et r�zn�ch klasifikac� film� (atribut rating)
SELECT COUNT(DISTINCT rating) AS pocet_kategorii FROM film

--vypi�te jedn�m dotazem po�et adres, po�et adras s vypln�n�m PS� a po�et r�zn�ch PS�
SELECT COUNT(*) AS pocet_adres, COUNT(postal_code) AS adresy_s_PSC, COUNT(DISTINCT postal_code) AS ruzna_PSC  FROM address

--vypi�te nejmen��, nejv�t�� a pr�m�rnou d�lku v�ech film�. Ov��te si zji�t�nou pr�m�rnou d�lku pomoc� pod�lu sou�t� a po�tu
SELECT MIN(length) AS nejmensi, MAX(length) AS nejvetsi, AVG(CAST(length AS FLOAT)) as prumer, SUM((CAST(length AS FLOAT)))/COUNT((CAST(length AS FLOAT))) AS vypocteny_prumer FROM film

--vypiste pocet a soucet vsch plateb, kter� byly provedeny v roce 2005
SELECT COUNT(*) AS pocet, SUM(amount) AS soucet FROM payment WHERE YEAR(payment_date) = 2005

--vypiste celkov� po�et znak� v n�zvech v�ech film�
SELECT SUM(LEN(title)) as pocet_znaku FROM film
