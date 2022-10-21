--vypi�te po�ty film� pro jednotliv� klasifikace
SELECT rating, COUNT(*) FROM film GROUP BY rating

--pro ka�d� ID z�kazn�ka vypi�te po�et jeho p�ij�men� je ve v�sledku n�co p�ekvapiv�ho
SELECT customer_id, COUNT(last_name) AS pocet FROM customer GROUP BY customer_id

--vypi�te ID z�kazn�k� set��zen� podle po�tu sou�tu v�ech plateb. z�kazn�ky, kte�� neprovedli ��dnou platbu neuva�ujte
SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id ORDER BY SUM(amount)

--pro ka�d� jm�no a p�ij�men� herce vypi�te po�et herc� s takov�m jm�nem a p�ij�men�m. V�sledek sed�i�te dle po�tu sestupn�
SELECT first_name, last_name, count(*) AS pocet
FROM actor
GROUP BY first_name, last_name
ORDER BY pocet DESC;

--vypi�te sou�ty v�ech plateb za jednotliv� roky a m�s�ce. V�sledek uspo��dejte podle rok� a m�s�c�
SELECT YEAR(payment_date) AS rok, MONTH(payment_date) as mesic, SUM(amount) as suma
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER by rok, mesic

----vypi�te ID sklad� s v�ce ne� 2300 kopiemi film�
SELECT store_id, COUNT(*)
FROM inventory
GROUP BY store_id
HAVING COUNT(*)>2300

--vypi�te ID jazyk�, pro kter� je nejkrat�� film del�� ne� 46 minu
SELECT language_id, MIN(length)
FROM film
GROUP BY language_id
HAVING MIN(length) > 46

--vypi�te roky a m�s�ce plateb, kdy byl sou�et plateb v�t�� ne� 20 000
SELECT YEAR(payment_date) AS rok, MONTH(payment_date) AS mesic, SUM(amount) AS soucet
FROM payment
GROUP by YEAR(payment_date), MONTH(payment_date)
HAVING SUM(amount) > 20000

--vypi�te klasifikace film� (atribut rating), jejich� d�lka je men�� ne� 50 minut a celkov� d�lka v dan� klasifikaci je v�t�� ne� 250 minut. V�sledek set�i�te sestupn� podle abecedy.
SELECT rating
FROM film
WHERE length < 50
GROUP BY rating
HAVING SUM(length) > 250
ORDER BY rating DESC

--vypi�te jednotliv� ID jazyk� a po�et film�. Vynechejte jyzyky, kter� nemaj� ��dn� film
SELECT language_id, COUNT(*) AS pocet_filmu
FROM film
GROUP BY language_id

--vypi�te n�zvy jazyk� a k nim po�et film�. VE v�sledku budou i jazyky, kter� nemaj� ��dn� film
SELECT l.language_id, l.name, COUNT(f.film_id) AS pocet_filmu
FROM language l
LEFT JOIN film f ON l.language_id = f.language_id
GROUP BY l.language_id, l.name

--vypi�te pro jednotliv� z�kazn�ky (ID, jmeno, prijmeni) po�ty jejich v�p�j�ek.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) as pocet_vypujcek
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name

--vypi�te pro jednotliv� z�kazn�ky (ID, jm, prij) pocty ruznych film�, kter� si vyp�jcili
SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT i.film_id) as pocet_filmu
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name

--vypi�te jm�na a p�ij�men� herc�, kte�� hr�li ve v�ce ne� 20-ti filmech
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name,a.last_name
HAVING COUNT(fa.film_id) > 20

--Pro ka�d�ho z�kazn�ka vypi�te, kolik celkem utratil za v�p�j�ky film� a jak� byla jeho nejmen��, nejv�t�� a pr�m�rn� ��stka
SELECT c.first_name, c.last_name, SUM(p.amount) AS suma, MIN(p.amount) AS minimalni_castka, MAX(p.amount) AS maximalni_castka, AVG(CAST(p.amount AS FLOAT)) AS prumerna_castka
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.first_name,c.last_name

--vypi�te por ka�dou ktaegorii pr�m�rnou d�lku filmu
SELECT c.category_id, c.name, AVG(CAST(f.length AS FLOAT)) AS prumerna_delka
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name

--pro ka�d� film vypi�te, jak� byl celkov� p��jem z v�p�j�ek. Vypi�te jen filmy, kde byl celkov� p��jem v�t�� ne� 100
SELECT f.film_id, f.title, SUM(p.amount) AS celkovy_prijem
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title
HAVING SUM(p.amount) > 100

--pro ka�d�ho herce vypi�te, v kolika r�zn�ch kategori�ch film� hraje
SELECT a.actor_id, a.first_name, a.last_name, COUNT(DISTINCT fc.category_id)
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film_category fc ON fa.film_id = fc.film_id
GROUP BY a.actor_id, a.first_name, a.last_name

--vypi�te adresy z�kazn�k� (address.address) v�etn� n�zvu m�sta a st�tu, kde ve filmech, kter� si p�j�ili z�kazn�ci hr�lo dohromady alespo� 40 r�zn�ch herc�
SELECT address.address, city.city, country.country
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
LEFT JOIN rental ON customer.customer_id = rental.customer_id
LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film_actor ON inventory.film_id = film_actor.film_id
GROUP BY address.address, city.city, country.country
HAVING COUNT(DISTINCT film_actor.actor_id) >= 40

--Pro v�echny filmy (id, nazev) spadaj�c� do kategorie "horror" uve�te, v kolika r�zn�ch m�stech bydl� z�kazn�ci, kte�� si dan� film p�j�ili
SELECT f.film_id, f.title, COUNT(DISTINCT ad.city_id) as pocet_mest
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN customer cus ON r.customer_id = cus.customer_id
LEFT JOIN address ad ON cus.address_id = ad.address_id
WHERE cat.name = 'Horror'
GROUP BY f.film_id, f.title

--pro v�echny z�kazn�ky z polska vypi�te, do  kolika r�zn�ch kategori� spadaj� filmy, kter� si tito z�kazn�i vyp�j�ili
SELECT customer.customer_id, customer.first_name, customer.last_name,
COUNT(DISTINCT film_category.category_id) AS pocet_kategorii
FROM
country
JOIN city ON country.country_id = city.country_id
JOIN address ON city.city_id = address.city_id
JOIN customer ON address.address_id = customer.address_id
LEFT JOIN rental ON customer.customer_id = rental.customer_id
LEFT JOIN inventory ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film ON inventory.film_id = film.film_id
LEFT JOIN film_category ON film.film_id = film_category.film_id
WHERE country.country = �Poland�
GROUP BY customer.customer_id, customer.first_name, customer.last_name

--vypi�te n�zvy v�ech jazyk� k nim po�ty film�v dan�m jazyce, kter� jsou del�� ne� 350 minut.
SELECT l.name, COUNT(f.film_id) as pocet_filmu
FROM language l
LEFT JOIN film f ON l.language_id = f.language_id
WHERE f.length > 350
GROUP BY l.name

--vypi�te kolik jednotliv� z�kazn�ci utratili za v�p�j�ky, kter� za�ali v m�s�ci �ervnu
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS suma
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id AND MONTH(r.rental_date) = 6
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name


--Vypi�te seznam kategori� set��zen� podle po�tu film� jejich� jazyk za��n� na "E"
SELECT
category.name
FROM category
LEFT JOIN film_category ON category.category_id = film_category.category_id
LEFT JOIN film ON film_category.film_id = film.film_id
LEFT JOIN language ON film.language_id = language.language_id
AND language.name LIKE 'E%'
GROUP BY category.name
ORDER BY COUNT(language.language_id)

--vypi��te n�zvy film� s d�lkou men�� ne� 5O minut, kter� si z�kazn�ci s p�ij�men�m BELL p�j�ili p�esn� 1x
SELECT film.film_id, film.title, customer.last_name, COUNT(customer.
customer_id)
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
LEFT JOIN customer ON rental.customer_id = customer.customer_id 
AND customer.last_name = 'BELL'
WHERE film.length < 50
GROUP BY film.film_id, film.title, customer.last_name
HAVING COUNT(customer.customer_id) = 1--neboSELECT film.film_id, film.title, customer.last_name, COUNT(customer.
customer_id)
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN customer ON rental.customer_id = customer.customer_id
WHERE film.length < 50 AND customer.last_name = 'BELL'
GROUP BY film.film_id, film.title, customer.last_name
HAVING COUNT(customer.customer_id) = 1