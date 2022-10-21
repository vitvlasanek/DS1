--vypište ID a názvy filmù ve kterých hrál herec s ID= 1. Dotaz vyøešte bez použití JOIN
SELECT film_id, title
FROM film
WHERE film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1)
--nebo
SELECT film_id, title
FROM film
WHERE EXISTS (SELECT * FROM film_actor WHERE film.film_id = film_actor.
film_id AND actor_id = 1)

--vypište ID filmù, ve kterých hrál herec s ID = 1
SELECT film_id
FROM film
WHERE film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1)
--nebo
SELECT film_id
FROM film_actor
WHERE actor_id = 1

--vypište ID a názvy filmù, ve kterých hrál herec s ID = 1 zároveò s hercem s ID= 10
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

--vypište ID a názvy filmù, ve kterých hrál herec s ID = 1 nebo herec s ID = 10
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


--vypište ID filmù kde nehrál herec ID = 1
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

--vypište ID a názvy filmù, ve kterých hrál herec s ID = 1 nebo herec s ID = 10, ale ne oba dohromady
SELECT film_id, title
FROM film
WHERE
film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1 OR actor_id = 10)
AND NOT
(film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1) AND film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 10))

--vypište ID a názvy filmù, ve kterých nehraje herec PENELOPE GUINESS zároveò s hercem CHRISTIAN GABLE
SELECT film_id, title
FROM film
WHERE film_id IN (SELECT film_id FROM actor JOIN film_actor ON actor.actor_id = film_actor.actor_id WHERE actor.first_name ='PENELOPE' AND actor.last_name = 'GUINESS')
AND film_id IN (SELECT film_id FROM actor JOIN film_actor ON actor.actor_id = film_actor.actor_id WHERE actor.first_name ='CHRISTIAN' AND actor.last_name = 'GABLE')

--vypište ID všech filmù, ve kterých nehraje PENELOPE GUINESS
SELECT film_id,title
FROM film
WHERE  film_id NOT IN (SELECT film_id FROM actor JOIN film_actor ON actor.actor_id = film_actor.actor_id WHERE actor.first_name ='PENELOPE' AND actor.last_name = 'GUINESS')

--vypište jména zákazníkù, kteøí si pùjèili všechny filmy ENEMY ODDS, POLLOCK DELIVERANCE a FALCON VOLUME
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'ENEMY ODDS')
AND customer_id IN (SELECT customer_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'POLLOCK DELIVERANCE')
AND customer_id IN (SELECT customer_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'FALCON VOLUME')

--vypište jména všech zákazníkù, kteøí si vypùjèili film GRIT CLOCKWORK v kvìtnu i èervnu (libovolného roku)
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (SELECT customer_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'GRIT CLOCKWORK' AND MONTH(rental.rental_date) = 5)
AND customer_id IN (SELECT customer_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id JOIN film ON inventory.film_id = film.film_id WHERE film.title = 'GRIT CLOCKWORK' AND MONTH(rental.rental_date) = 6);

--vypište jména a pøijímení zákazníkù, kteøí se pøijímením jmenují stejnì jako nìjaký herec
SELECT first_name, last_name
FROM customer
WHERE last_name IN (SELECT last_name FROM actor)
--nebo
SELECT first_name, last_name
FROM customer
WHERE EXISTS (SELECT * FROM actor where actor.last_name = customer.last_name)

--vypište jména filmù, které jsou stejnì dlouhé jako nìjaké jiné filmy
SELECT title
FROM film f1
WHERE length IN (SELECT length FROM film f2 WHERE f1.film_id != f2.film_id)
--nebo
SELECT title
FROM film f1
WHERE EXISTS (SELECT * FROM film f2 WHERE f1.length = f2.length AND f1.film_id != f2.film_id)

--vypište názvy filmù, které jsou kratší než nìjaký film, ve kterém hraje BURT POSEY
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

--vypište jména hercù, kteøí hráli v nìjakém filmu kratším než 50 minut
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

--naleznìte filmy, které byly pùjèeny alespoò 2x
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

--naleznìte filmy, které si pùjèily alespoò 2 rùzní zákazníci
SELECT film.title
FROM
film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id, film.title
HAVING COUNT(DISTINCT rental.customer_id) > 1

--vypište zákazníky, kteøí mìli v urèitou chvíli ve výpùjèce zároveò více rùzných filmù

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

--vypište jména a pøijímení zákazníkù, kteøí si pùjièili film GRIT CLOCKWORK v kvìtnu i èervnu téhož roku

--vypište názvy filmù, které jsou kratši než všechny filmy, ve kterých hraje BURT POSEY
SELECT title
FROM film
WHERE length < ALL (
SELECT film.length
FROM
actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE actor.first_name = ’BURT’ AND actor.last_name = ’POSEY’
)

--Vypište jména hercù, kteøí hráli jen ve filmech kratších než 180 minut
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

--vypište zákazníky, kteøí v žádném mìsíci nemìli více než 3 výpùjèky. Pro zjištìní poètu výpùjèek v jednotlivých mìsících použijte agregaèní funkci a shlukování


--vypište zákazníky, kteøí si pùjèovali filmy pouze v letních mìsícíh (èer-srp)
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
--vypište zákazníky, kteøí vždy vrátili film do 8-mi dnù. Výpùjèky, které dosud nevrátil ignorujte
SELECT *
FROM customer
WHERE NOT EXISTS (
SELECT *
FROM rental
WHERE
rental.customer_id = customer.customer_id
AND DATEDIFF(day, rental.rental_date, rental.return_date) > 8
) AND customer_id IN (SELECT customer_id FROM rental)

--vypište zákazníky, jejichž všechny výpùjèky byly delší než 1 den a pùjèili si film, kde hraje DEBBIE AKROYD

--vypište jména a pøijímení zákazníkù, kteøí provedli pøesnì jednu výpùjèku

--vypište názvy filmù, kde hraje jediný herec

--vypište všechny zákazníky (jm a pø) a jazyky, poukd si zákazník pùjèoval pouze filmy v daném jazyce

-- vypište názvy filmù, které si vždy pùjèovali jen zákazníci, kteøí si nikdy nepùjèili jiný film

--vypište jména a pøijímení všech zákazníkù, kteøí si pùjèovali pouze filmy, kde hrál CHRISTIAN GABLE

--Vypište herce, kteøí hráli vždy jen ve filmu, který pùjèovna vlastní alepoò ve 3 kopiích. Pro zjištìní poètu použíjte agregaèní funkci

--Naleznìte filmy, jejichž všechny kopie byly vypùjèeny alespoò 4x. Pro zjištìní poètu kopií v inventáøi použíjte agregaèní funkci
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
---vypište herce jejichž všechny filmy, kde hráli, jsou delší než filmy, ve kterých hrál herec CHRISTIAN GABLE
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
WHERE actor.first_name = ’CHRISTIAN’ AND
actor.last_name = ’GABLE’
)
) AND actor_id IN (SELECT actor_id FROM film_actor)

--vypoište herce, jejichž filmy delší než 180 min si pùjèovali vždy zákazníci ze stejné zemì

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