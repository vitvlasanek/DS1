SELECT film_id, title 
	FROM film 
	WHERE film_id IN (SELECT film_id FROM film_actor WHERE actor_id = 1)

SELECT film_id, title FROM film WHERE film_id IN (SELECT film_id from film_actor where actor_id = 1) AND film_id IN (SELECT film_id from film_actor where actor_id = 10)

SELECT film_id, title FROM film f WHERE EXISTS (SELECT 1 FROM film_actor fa where actor_id = 1 and f.film_id = fa.film_id)

SELECT film_id, title 
	FROM film 
	WHERE film_id NOT IN 
	(SELECT film_id FROM film_actor JOIN actor ON film_actor.actor_id = actor.actor_id WHERE actor.first_name = 'PENELOPE' and actor.last_name = 'GUINESS')

SELECT film_id, title 
	FROM film f WHERE NOT EXISTS 
	(SELECT 1 FROM film_actor fa JOIN actor a ON a.actor_id = fa.actor_id WHERE a.first_name = 'PENELOPE' and a.last_name = 'GUINESS' and f.film_id = fa.film_id)

SELECT * FROM film WHERE film_id NOT IN (SELECT i.film_id FROM inventory i left join rental r   ON i.inventory_id = r.inventory_id group by i.inventory_id, i.film_id having count(*) < 5)

select f.title, (select count(*) from film_actor fa where f.film_id = fa.film_id) actors, (select count(*) from film_category fc where f.film_id = fc.film_id) categories from film f
