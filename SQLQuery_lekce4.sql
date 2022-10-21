--vypi�te ID a n�zvy film� ve kter�ch hr�l herec s ID= 1. Dotaz vy�e�te bez pou�it� JOIN
SELECT film_id, title
FROM film
WHERE film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1)
--nebo
SELECT film_id, title
FROM film
WHERE EXISTS (SELECT * FROM film_actor WHERE film.film_id = film_actor.
film_id AND actor_id = 1)

--vypi�te ID film�, ve kter�ch hr�l herec s ID = 1
SELECT film_id
FROM film
WHERE film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1)
--nebo
SELECT film_id
FROM film_actor
WHERE actor_id = 1

--vypi�te ID a n�zvy film�, ve kter�ch hr�l herec s ID = 1 z�rove� s hercem s ID= 10
SELECT film_id, title
FROM film
WHERE
film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1)
AND
film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 10)
--nebo 
SELECT film_id, title
FROM film
WHERE
EXISTS (SELECT * FROM film_actor WHERE film.film_id = film_actor.film_id AND actor_id = 1) 
AND
EXISTS (SELECT * FROM film_actor WHERE film.film_id = film_actor.film_id AND actor_id = 10)

--vypi�te ID a n�zvy film�, ve kter�ch hr�l herec s ID = 1 nebo herec s ID = 10
SELECT film_id, title
FROM film
WHERE
film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1)
OR
film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 10)
--nebo
SELECT film_id, title
FROM film
WHERE film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1 OR actor_id = 10)
--nebo
SELECT DISTINCT film.film_id, title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = 1 OR film_actor.actor_id = 10


--vypi�te ID film� kde nehr�l herec ID = 1
------------------------------------------------------pozor, toto ne
SELECT film_id
FROM film_actor
WHERE actor_id != 1
--------------------------------------
SELECT film_id
FROM film
WHERE film_id NOT IN (SELECT film_id FROM film_actor WHERE actor_id = 1)
---nebo
SELECT film_id
FROM film
WHERE NOT EXISTS (SELECT film_id FROM film_actor WHERE film.film_id = film_actor.film_id AND actor_id = 1)

--vypi�te ID a n�zvy film�, ve kter�ch hr�l herec s ID = 1 nebo herec s ID = 10, ale ne oba dohromady
SELECT film_id, title
FROM film
WHERE
film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1 OR actor_id = 10)
AND NOT
(film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1) AND film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 10))

--vypi�te ID a n�zvy film�, ve kter�ch nehraje herec PENELOPE GUINESS z�rove� s hercem CHRISTIAN GABLE
SELECT film_id, title
FROM film
WHERE film_id IN (SELECT film_id FROM actor JOIN film_actor ON actor.actor_id = film_actor.actor_id WHERE actor.first_name ='PENELOPE' AND actor.last_name = 'GUINESS')
AND film_id IN (SELECT film_id FROM actor JOIN film_actor ON actor.actor_id = film_actor.actor_id WHERE actor.first_name ='CHRISTIAN' AND actor.last_name = 'GABLE')

--vypi�te ID v�ech film�, ve kter�ch nehraje PENELOPE GUINESS
SELECT film_id,title
FROM film
WHERE  film_id NOT IN (SELECT film_id FROM actor JOIN film_actor ON actor.actor_id = film_actor.actor_id WHERE actor.first_name ='PENELOPE' AND actor.last_name = 'GUINESS')

--vypi�te jm�na z�kazn�k�, kte�� si p�j�ili v�echny filmy ENEMY ODDS, POLLOCK DELIVERANCE a FALCON VOLUME
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'ENEMY ODDS')
AND customer_id IN (SELECT customer_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'POLLOCK DELIVERANCE')
AND customer_id IN (SELECT customer_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'FALCON VOLUME')

--vypi�te jm�na v�ech z�kazn�k�, kte�� si vyp�j�ili film GRIT CLOCKWORK v kv�tnu i �ervnu (libovoln�ho roku)
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'GRIT CLOCKWORK' AND MONTH(rental.rental_date) = 5)
AND customer_id IN (SELECT customer_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'GRIT CLOCKWORK' AND MONTH(rental.rental_date) = 6);

--vypi�te jm�na a p�ij�men� z�kazn�k�, kte�� se p�ij�men�m jmenuj� stejn� jako n�jak� herec
SELECT first_name, last_name
FROM customer
WHERE last_name IN (SELECT last_name FROM actor)
--nebo
SELECT first_name, last_name
FROM customer
WHERE EXISTS (SELECT * FROM actor where actor.last_name = customer.last_name)

--vypi�te jm�na film�, kter� jsou stejn� dlouh� jako n�jak� jin� filmy
SELECT title
FROM film f1
WHERE length IN (SELECT length FROM film f2 WHERE f1.film_id != f2.film_id)
--nebo
SELECT title
FROM film f1
WHERE EXISTS (SELECT * FROM film f2 WHERE f1.length = f2.length AND f1.film_id != f2.film_id)

--vypi�te n�zvy film�, kter� jsou krat�� ne� n�jak� film, ve kter�m hraje BURT POSEY
SELECT title FROM film
WHERE length < ANY	(SELECT film.length 
					FROM actor 
					JOIN film_actor ON actor.actor_id = film_actor.actor_id
					JOIN film on film_actor.film_id = film.film_id
					WHERE actor.first_name= 'BURT' AND actor.last_name ='POSEY')
--nebo
SELECT title
FROM film f1
WHERE EXISTS (SELECT * FROM actor
				JOIN film_actor ON actor.actor_id = film_actor.actor_id
				JOIN film f2 ON film_actor.film_id = f2.film_id
				WHERE actor.first_name = 'BURT' AND actor.last_name = 'POSEY'
				AND f1.length < f2.length)

--vypi�te jm�na herc�, kte�� hr�li v n�jak�m filmu krat��m ne� 50 minut
SELECT first_name, last_name
FROM actor
WHERE 50 > ANY (SELECT length FROM film 
				JOIN film_actor ON film.film_id = film_actor.film_id 
				WHERE film_actor.actor_id = actor.actor_id)
--nebo 
SELECT DISTINCT first_name, last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.length < 50
--nebo 
SELECT actor.first_name, actor.last_name
FROM actor
WHERE EXISTS (SELECT * FROM film 
				JOIN film_actor ON film.film_id = film_actor.film_id
				WHERE film_actor.actor_id = actor.actor_id AND film.length < 50)

--nalezn�te filmy, kter� byly p�j�eny alespo� 2x
SELECT DISTINCT f1.title
FROM rental r1
JOIN inventory i1 ON r1.inventory_id = i1.inventory_id
JOIN film f1 ON i1.film_id = f1.film_id
WHERE EXISTS	(SELECT * FROM rental r2
				JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
				WHERE i2.film_id = i1.film_id AND r1.rental_id != r2.rental_id) 

--nebo
SELECT film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id, film.title
HAVING COUNT(rental.customer_id) > 1

--nalezn�te filmy, kter� si p�j�ily alespo� 2 r�zn� z�kazn�ci
SELECT film.title
FROM
film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id, film.title
HAVING COUNT(DISTINCT rental.customer_id) > 1

--vypi�te z�kazn�ky, kte�� m�li v ur�itou chv�li ve v�p�j�ce z�rove� v�ce r�zn�ch film�

SELECT DISTINCT customer.customer_id, customer.first_name, customer.
last_name
FROM
rental r1
JOIN inventory i1 ON r1.inventory_id = i1.inventory_id
JOIN customer ON r1.customer_id = customer.customer_id
WHERE EXISTS (
SELECT *
FROM
rental r2
JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
WHERE
r1.customer_id = r2.customer_id AND
i1.film_id != i2.film_id AND
r1.return_date >= r2.rental_date AND
r1.rental_date <= r2.return_date
)

--vypi�te jm�na a p�ij�men� z�kazn�k�, kte�� si p�ji�ili film GRIT CLOCKWORK v kv�tnu i �ervnu t�ho� roku

--vypi�te n�zvy film�, kter� jsou krat�i ne� v�echny filmy, ve kter�ch hraje BURT POSEY
SELECT title
FROM film
WHERE length < ALL (
SELECT film.length
FROM
actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE actor.first_name = �BURT� AND actor.last_name = �POSEY�
)

--Vypi�te jm�na herc�, kte�� hr�li jen ve filmech krat��ch ne� 180 minut
SELECT actor.first_name, actor.last_name
FROM actor
WHERE
180 > ALL (
SELECT length
FROM film JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = actor.actor_id
)
AND actor_id IN (SELECT actor_id FROM film_actor)--nebo
SELECT actor.first_name, actor.last_name
FROM actor
WHERE
NOT EXISTS (
SELECT *
FROM film JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = actor.actor_id AND film.length >= 180
)
AND actor_id IN (SELECT actor_id FROM film_actor)

--vypi�te z�kazn�ky, kte�� v ��dn�m m�s�ci nem�li v�ce ne� 3 v�p�j�ky. Pro zji�t�n� po�tu v�p�j�ek v jednotliv�ch m�s�c�ch pou�ijte agrega�n� funkci a shlukov�n�


--vypi�te z�kazn�ky, kte�� si p�j�ovali filmy pouze v letn�ch m�s�c�h (�er-srp)
SELECT first_name, last_name
FROM customer
WHERE NOT EXISTS (
SELECT *
FROM rental
WHERE
customer.customer_id = rental.customer_id AND
MONTH(rental.rental_date) NOT BETWEEN 6 AND 8
) AND customer_id IN (SELECT customer_id FROM rental)--neboSELECT first_name, last_name
FROM customer
WHERE customer_id NOT IN
(
SELECT customer_id
FROM rental
WHERE MONTH(rental.rental_date) NOT BETWEEN 6 AND 8
) AND customer_id IN (SELECT customer_id FROM rental)
--vypi�te z�kazn�ky, kte�� v�dy vr�tili film do 8-mi dn�. V�p�j�ky, kter� dosud nevr�til ignorujte
SELECT *
FROM customer
WHERE NOT EXISTS (
SELECT *
FROM rental
WHERE
rental.customer_id = customer.customer_id
AND DATEDIFF(day, rental.rental_date, rental.return_date) > 8
) AND customer_id IN (SELECT customer_id FROM rental)

--vypi�te z�kazn�ky, jejich� v�echny v�p�j�ky byly del�� ne� 1 den a p�j�ili si film, kde hraje DEBBIE AKROYD

--vypi�te jm�na a p�ij�men� z�kazn�k�, kte�� provedli p�esn� jednu v�p�j�ku

--vypi�te n�zvy film�, kde hraje jedin� herec

--vypi�te v�echny z�kazn�ky (jm a p�) a jazyky, poukd si z�kazn�k p�j�oval pouze filmy v dan�m jazyce

-- vypi�te n�zvy film�, kter� si v�dy p�j�ovali jen z�kazn�ci, kte�� si nikdy nep�j�ili jin� film

--vypi�te jm�na a p�ij�men� v�ech z�kazn�k�, kte�� si p�j�ovali pouze filmy, kde hr�l CHRISTIAN GABLE

--Vypi�te herce, kte�� hr�li v�dy jen ve filmu, kter� p�j�ovna vlastn� alepo� ve 3 kopi�ch. Pro zji�t�n� po�tu pou��jte agrega�n� funkci

--Nalezn�te filmy, jejich� v�echny kopie byly vyp�j�eny alespo� 4x. Pro zji�t�n� po�tu kopi� v invent��i pou��jte agrega�n� funkci
SELECT title
FROM film
WHERE film_id NOT IN
(
SELECT inventory.film_id
FROM
inventory
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY inventory.inventory_id, inventory.film_id
HAVING COUNT(rental.rental_id) < 4
)
AND film_id IN (SELECT film_id FROM inventory)
---vypi�te herce jejich� v�echny filmy, kde hr�li, jsou del�� ne� filmy, ve kter�ch hr�l herec CHRISTIAN GABLE
SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
SELECT film_actor.actor_id
FROM
film_actor
JOIN film ON film_actor.film_id = film.film_id
WHERE film.length < SOME (
SELECT film.length
FROM
actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE actor.first_name = �CHRISTIAN� AND
actor.last_name = �GABLE�
)
) AND actor_id IN (SELECT actor_id FROM film_actor)

--vypoi�te herce, jejich� filmy del�� ne� 180 min si p�j�ovali v�dy z�kazn�ci ze stejn� zem�

SELECT actor.actor_id, first_name, last_name
FROM actor
WHERE NOT EXISTS (
SELECT film_actor.actor_id
FROM
film_actor
JOIN film ON film_actor.film_id = film.film_id
JOIN inventory i1 ON film.film_id = i1.film_id
JOIN rental r1 ON i1.inventory_id = r1.inventory_id
JOIN customer c1 ON r1.customer_id = c1.customer_id
JOIN address a1 ON c1.address_id = a1.address_id
JOIN city ct1 ON a1.city_id = ct1.city_id
WHERE film_actor.actor_id = actor.actor_id AND film.length > 180 AND
EXISTS (
SELECT *
FROM
inventory i2
JOIN rental r2 ON i2.inventory_id = r2.inventory_id
JOIN customer c2 ON r2.customer_id = c2.customer_id
JOIN address a2 ON c2.address_id = a2.address_id
JOIN city ct2 ON a2.city_id = ct2.city_id
WHERE i2.film_id = i1.film_id AND ct2.country_id != ct1.country_id
)
)
--