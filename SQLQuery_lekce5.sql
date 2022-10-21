--pro každý film vypište, kolik je v nìm hercù a v kolika kategoriích
SELECT f.film_id, f.title, COUNT(DISTINCT fa.actor_id) AS herci, COUNT(DISTINCT fc.category_id) AS kategorie
FROM film f
LEFT JOIN film_category fc ON f.film_id = fc.film_id
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY f.film_id, f.title
--univerzálnìji
SELECT film.film_id, film.title,
(SELECT COUNT(*) FROM film_actor WHERE film_actor.film_id = film.film_id) AS pocet_hercu,
(SELECT COUNT(*) FROM film_category WHERE film_category.film_id = film.film_id) AS pocet_kategorii
FROM film
--nebo
SELECT pocty_hercu.film_id, pocty_hercu.title, pocet_hercu,
pocet_kategorii
FROM (SELECT film.film_id, film.title, COUNT(film_actor.film_id) AS pocet_hercu
FROM film LEFT JOIN film_actor ON film.film_id = film_actor.film_id GROUP BY film.film_id, film.title) pocty_hercu
	JOIN (SELECT film.film_id, COUNT(film_category.film_id) AS pocet_kategorii 
FROM film LEFT JOIN film_category ON film.film_id = film_category.film_id 
	GROUP BY film.film_id, film.title) pocty_kategorii 
	ON pocty_hercu.film_id = pocty_kategorii.film_id


--pro každého zákazníka vypište poèet výpùjèek trvajících ménì než 5 dní a poèet výpùjèek trvajících ménì než 7 dní
SELECT first_name, last_name,
(SELECT COUNT(*) FROM rental WHERE rental.customer_id = customer.customer_id AND DATEDIFF(day, rental_date, return_date) <5) AS mensi_5,
(SELECT COUNT(*) FROM rental WHERE rental.customer_id = customer.customer_id AND DATEDIFF(day, rental_date, return_date) <7) AS mensi_7
FROM customer
--nebo
SELECT k5.first_name, k5.last_name, kratsi_5, kratsi_7
FROM (SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS kratsi_5
		FROM customer 
		LEFT JOIN rental 
		ON customer.customer_id = rental.customer_id AND DATEDIFF(day, rental_date, return_date) < 5 
		GROUP BY customer.customer_id, customer.first_name, customer.last_name) k5 
JOIN (SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental.rental_id) AS kratsi_7
		FROM customer
		LEFT JOIN rental 
		ON customer.customer_id = rental.customer_id AND DATEDIFF(day, rental_date, return_date) < 7
		GROUP BY customer.customer_id, customer.first_name, customer.last_name) k7 ON k5.customer_id = k7.customer_id

--pro každý sklad (ID) vypište poèet kopií filmù (položek v inventáøi) pro filmi v anglickém jazyce a pro filmy v anglickém jazyce
SELECT store.store_id,
	(SELECT COUNT(*) 
	FROM inventory 
	JOIN film on inventory.film_id = film.film_id
	join language ON film.language_id = language.language_id
	WHERE inventory.store_id = store.store_id AND language.name ='English') AS ENG,
	(SELECT COUNT(*) 
	FROM inventory 
	JOIN film on inventory.film_id = film.film_id
	join language ON film.language_id = language.language_id
	WHERE inventory.store_id = store.store_id AND language.name ='French') AS FRA
FROM store
--nebo

WITH t AS (SELECT inventory.store_id, language.name
			FROM inventory
			JOIN film ON inventory.film_id = film.film_id
			JOIN language ON film.language_id = language.language_id)
SELECT store_id,
	(SELECT COUNT(*) FROM t WHERE t.name = 'English' AND t.store_id = store.store_id) AS english,
	(SELECT COUNT(*) FROM t WHERE t.name = 'French' AND t.store_id = store.store_id) AS french
FROM store--pro každý film vypište následující údaje: a) poèet hercù ve filmu, b) poèet rùzných zákazníkù, kteøí si film pùjèili v srpnu, c) prùmìrnou èástku platby za výpùjèkuSELECT f.film_id, f.title, 	(SELECT COUNT(*) FROM film_actor fa WHERE f.film_id = fa.film_id) AS pocet_hercu,	(SELECT COUNT(DISTINCT r.customer_id) FROM inventory i JOIN rental r ON i.inventory_id = r.inventory_id) as pocet_zakazniku,	(SELECT AVG(amount) FROM payment 
	JOIN rental ON payment.rental_id = rental.rental_id 
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	WHERE inventory.film_id = f.film_id) AS prum_platbaFROM film f--vypište zákazníky, kteøí v mìsíci èervnu provedli více než 5 plateb a nejdelší film, který si pùjèili má alepsoò 185 minutSELECT first_name, last_name
FROM customer
WHERE	(SELECT COUNT(*)
			FROM payment
			WHERE payment.customer_id = customer.customer_id 
			AND MONTH (payment_date) = 6) > 5 
		AND
		(SELECT MAX(length) FROM film 
			JOIN inventory ON film.film_id = inventory.film_id
			JOIN rental ON inventory.inventory_id = rental.inventory_id
			WHERE rental.customer_id = customer.customer_id) >= 185;

--vypište zákazníky, jejichž vìtšina plateb je o èástce vìtší než 4
SELECT first_name, last_name
FROM customer
WHERE	(SELECT COUNT(*) FROM payment WHERE payment.customer_id = customer.customer_id AND amount > 4) 
		>
		(SELECT COUNT(*)FROM payment WHERE payment.customer_id = customer.customer_id AND amount <= 4);

--vypište herce, kteøí hrají více než 2x èastìji v komediích než v hororech
SELECT first_name, last_name
FROM actor
WHERE
(
	SELECT COUNT(*)
	FROM film_actor
	WHERE film_actor.actor_id = actor.actor_id AND film_id IN 
	(
		SELECT film_id
		FROM
		film_category
		JOIN category ON film_category.category_id = category.category_id
		WHERE category.name = 'comedy'
	)
)
>
(
	SELECT COUNT(*)
	FROM film_actor
	WHERE film_actor.actor_id = actor.actor_id AND film_id IN (
		SELECT film_id
		FROM
		film_category
		JOIN category ON film_category.category_id = category.category_id
		WHERE category.name = 'horror'
	)
) * 2

--vypište zákazníky, jejichž celkové uhrazené platby jsou menší než kolik by meli zaplatit dle film.rental_duration, film.rental_rate arozdílu rental_date a return_date. mùžete ignorovat nevrácené
SELECT first_name, last_name
FROM customer
WHERE
(
	SELECT SUM(amount)
	FROM rental
		JOIN payment ON rental.rental_id = payment.rental_id
	WHERE rental.customer_id = customer.customer_id
)
<
(
	SELECT SUM(film.rental_rate * DATEDIFF(day, rental.rental_date, rental.return_date) / film.rental_duration)
	FROM rental
		JOIN inventory ON rental.inventory_id = inventory.inventory_id
		JOIN film ON inventory.film_id = film.film_id
	WHERE rental.customer_id = customer.customer_id
)--zákazníci, kteøí si èastìj pùjèovali filmy s TOM MCKELLEN než GROUCHO SINATRASELECT first_name, last_name
FROM customer
WHERE
(
	SELECT COUNT(*)
	FROM rental
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	WHERE rental.customer_id = customer.customer_id AND film_id IN
	(
		SELECT film_id
		FROM actor
		JOIN film_actor ON actor.actor_id = film_actor.actor_id
		WHERE actor.first_name = 'TOM' AND actor.last_name = 'MCKELLEN'
	)
)
>
(
	SELECT COUNT(*)
	FROM rental
	JOIN inventory ON rental.inventory_id = inventory.inventory_id
	WHERE rental.customer_id = customer.customer_id AND film_id IN
	(
		SELECT film_id
		FROM
		actor
		JOIN film_actor ON actor.actor_id = film_actor.actor_id
		WHERE actor.first_name = 'GROUCHO' AND actor.last_name = 'SINATRA'
	)
)
--nebo
SELECT first_name, last_name
FROM customer
WHERE
(
	SELECT COUNT(*)
	FROM rental
		JOIN inventory ON rental.inventory_id = inventory.inventory_id
		JOIN film_actor ON inventory.film_id = film_actor.film_id
		JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE rental.customer_id = customer.customer_id AND actor.first_name =
	'TOM' AND actor.last_name = 'MCKELLEN'
)
>
(
	SELECT COUNT(*)
	FROM rental
		JOIN inventory ON rental.inventory_id = inventory.inventory_id
		JOIN film_actor ON inventory.film_id = film_actor.film_id
		JOIN actor ON film_actor.actor_id = actor.actor_id
	WHERE rental.customer_id = customer.customer_id AND actor.first_name =
	'GROUCHO' AND actor.last_name = 'SINATRA'
)--vypište zákazníky, kteøí si pùjèovali pouze filmy v anglickém jazyce a u každého napište kolik mají výpùjèekSELECT first_name, last_name,
(
	SELECT COUNT(*)
	FROM rental
	WHERE rental.customer_id = customer.customer_id
) 
AS pocet_vypujcek
FROM customer
WHERE NOT EXISTS 
(
	SELECT *
	FROM rental
		JOIN inventory ON rental.inventory_id = inventory.inventory_id
		JOIN film ON inventory.film_id = film.film_id
		JOIN language ON film.language_id = language.language_id
	WHERE rental.customer_id = customer.customer_id AND language.name != 'English'
) 
AND customer_id IN (SELECT customer_id FROM rental)
--nebo
SELECT first_name, last_name, COUNT(rental.rental_id) AS pocet_vypujcek
FROM customer
	JOIN rental ON customer.customer_id = rental.customer_id
WHERE NOT EXISTS 
	(
	SELECT *
	FROM rental
		JOIN inventory ON rental.inventory_id = inventory.inventory_id
		JOIN film ON inventory.film_id = film.film_id
		JOIN language ON film.language_id = language.language_id
	WHERE rental.customer_id = customer.customer_id AND language.name != 'English'
	)
GROUP BY customer.customer_id, first_name, last_name

--Vypište všechny zákazníky, kteøí si pùjèili film, ve kterém hraje alepoò 15 hercù, a u každého z nich vypište celkovou sumu z plateb
SELECT first_name, last_name,
	(
		SELECT SUM(amount)
		FROM payment
		WHERE payment.customer_id = customer.customer_id
	) AS celkem
FROM customer
WHERE customer_id IN
	(
		SELECT customer_id
		FROM
		rental
		JOIN inventory ON rental.inventory_id = inventory.inventory_id
		WHERE inventory.film_id IN
		(
			SELECT film_id
			FROM film_actor
			GROUP BY film_id
			HAVING COUNT(*) >= 15
		)
	)--vypište název nejdelšího filmuSELECT TOP 1 titleFROM film ORDER BY length DESC--neboSELECT title
FROM film
WHERE length = (
SELECT MAX(length)
FROM film
)
--nebo
SELECT title
FROM film
WHERE length >= ALL (
SELECT length
FROM film
)
--nebo
SELECT title
FROM film f1
WHERE NOT EXISTS (
SELECT *
FROM film f2
WHERE f2.length > f1.length
)

--vypište nejdelší název filmu pro každý rating
SELECT rating, title
FROM film f1
WHERE length = (SELECT MAX(length) FROM film f2 WHERE f1.rating = f2.rating)
ORDER BY rating--pro každého herce nejdelší název filmu, kde hrálSELECT actor.first_name, actor.last_name, film.title
FROM
actor
JOIN film_actor fa1 ON actor.actor_id = fa1.actor_id
JOIN film ON fa1.film_id = film.film_id
WHERE film.length >= ALL (
SELECT film.length
FROM
film
JOIN film_actor fa2 ON film.film_id = fa2.film_id
WHERE fa2.actor_id = fa1.actor_id
)

--pro každého zákazníka poslední pùjèený film, kde hrál PENELOPE GUINESS, pokud nepùjèil nebude vypsán
SELECT customer.customer_id, first_name, last_name, film.title
FROM
customer
JOIN rental r1 ON customer.customer_id = r1.customer_id
JOIN inventory i1 ON r1.inventory_id = i1.inventory_id
JOIN film ON i1.film_id = film.film_id
WHERE
film.film_id IN (
SELECT film_id
FROM film_actor JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE actor.first_name = ’PENELOPE’ AND actor.last_name = ’GUINESS’
) AND r1.rental_date = (
SELECT MAX(rental_date)
FROM rental r2 JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
WHERE r1.customer_id = r2.customer_id AND i2.film_id IN (
SELECT film_id
FROM film_actor JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE actor.first_name = ’PENELOPE’ AND actor.last_name = ’GUINESS’
)
)
ORDER BY customer.customer_id--zákazníci, kteøí si pùjèili nejkratší a zároveò nejdelší filmSELECT first_name, last_name
FROM customer
WHERE
customer_id IN
(
SELECT rental.customer_id
FROM
rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE film.length = (SELECT MIN(length) FROM film)
)
AND customer_id IN
(
SELECT rental.customer_id
FROM
rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE film.length = (SELECT MAX(length) FROM film)
)

--film, který si alespoò 2 zákazníci pùjèili naposled
SELECT film_id, title
FROM
(
SELECT film.film_id, film.title, customer_id
FROM
rental r1
JOIN inventory ON r1.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE r1.rental_date = (
SELECT MAX(rental_date)
FROM rental r2
WHERE r1.customer_id = r2.customer_id
)
) t
GROUP BY film_id, title
HAVING COUNT(*) >= 2--zákazníci s nejvìtším poètem výpùjèekSELECT customer.first_name, customer.last_name, COUNT(rental.rental_id) as
pocet
FROM
customer
LEFT JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
HAVING COUNT(rental.rental_id) = (
SELECT MAX(pocet)
FROM
(
SELECT COUNT(rental.rental_id) as pocet
FROM
customer
LEFT JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY customer.customer_id
) t
)--filmy, které byly pùjèovány nejèastìji, vèetnì poètu pùjèeníSELECT film.film_id, film.title, COUNT(rental.rental_id) AS pocet
FROM
film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id, film.title
HAVING COUNT(rental.rental_id) = (
SELECT MAX(pocet)
FROM
(
SELECT COUNT(rental.rental_id) AS pocet
FROM
film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id
) t
)--poèet filmù s nadprùmìrným poètem výpùjèekSELECT film.film_id, film.title, COUNT(rental.rental_id) AS pocet
FROM
film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id, film.title
HAVING COUNT(rental.rental_id) > (
SELECT AVG(pocet)
FROM
(
SELECT COUNT(rental.rental_id) AS pocet
FROM
film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id
) t
)--pro každé mìsto zákazníka s nejvìtším poètem výpùjèekSELECT c1.city_id, city, customer.customer_id, first_name, last_name,
COUNT(rental.rental_id) AS pocet
FROM
city c1
LEFT JOIN address ON c1.city_id = address.city_id
LEFT JOIN customer ON address.address_id = customer.customer_id
LEFT JOIN rental ON customer.customer_id = rental.customer_id
GROUP BY c1.city_id, city, customer.customer_id, first_name, last_name
HAVING COUNT(rental.rental_id) =
(
SELECT MAX(pocet)
FROM
(
SELECT COUNT(rental.rental_id) AS pocet
FROM
city c2
LEFT JOIN address ON c2.city_id = address.city_id
LEFT JOIN customer ON address.address_id = customer.customer_id
LEFT JOIN rental ON customer.customer_id = rental.customer_id
WHERE c2.city_id = c1.city_id
GROUP BY customer.customer_id
) t
)