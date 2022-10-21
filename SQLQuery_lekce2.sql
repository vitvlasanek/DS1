-- vypište všechny informace o mìstech vèetnì odpovídajících informací o státech, kde se tato mìsta nacházejí
SELECT * FROM city ci JOIN country co ON ci.country_id = co.country_id

--vypište názvy všech filmù vèetnì jazyka
SELECT f.title, lan.name FROM film f JOIN language lan ON f.language_id = lan.language_id

--vypište ID všech výpùjèek zákazníka s pøijímením simpson
SELECT rental_id FROM rental r JOIN customer c ON r.customer_id = c.customer_id WHERE c.last_name = 'SIMPSON'

--Vypište adresu (address.address) záazníka s pøijímením SIMPSON. Porovnejte tento pøíklad s pøedchozím co do poètu øádkù
SELECT a.address FROM address a JOIN customer c ON a.address_id = c.address_id WHERE c.last_name = 'SIMPSON'

--pro každého zákazníka (jmeno, prijimeni) vypište adresu bydlištì vèetnì názvu mìsta
SELECT c.first_name, c.last_name, a.address, a.postal_code, city.city  FROM customer c JOIN address a ON c.address_id = a.address_id JOIN city ON a.city_id = city.city_id 

--vypište ID všech výpùjèek vèetnì jména zamìstnance, jména zákazníka a názvu filmu
SELECT r.rental_id, 
s.first_name + ' ' + s.last_name AS staff_name,
c.first_name +' ' + c.last_name AS customer_name,
f.title
FROM rental r 
JOIN staff s ON r.staff_id = s.staff_id 
JOIN customer c  ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id

--pro každý film (jeho název) vypište jména a pøijímení všech hercù, kterí ve filmu hrájí.
SELECT f.title, a.first_name, a.last_name 
FROM film f 
JOIN film_actor fa ON f.film_id = fa.film_id 
JOIN actor a ON fa.actor_id = a.actor_id
ORDER BY f.title

--pro každého herce (jm a pø) vypište jména filmù, kde hrál
SELECT actor.first_name, actor.last_name, film.title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
ORDER BY actor.last_name, actor.first_name

--vypište názvy všech filmù v kategorii horor
Select f.title FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Horror'

--pro každý sklad vypište jméno a pøijímení správce. dále adresu skladu a adresu správce.
SELECT st.store_id, sta.address AS store_address, sf.first_name +' '+ sf.last_name AS manager, sfa.address as manager_address
FROM store st
JOIN staff sf ON st.manager_staff_id = sf.staff_id
JOIN address sta ON st.address_id = sta.address_id
JOIN address sfa ON st.address_id = sfa.address_id

--pro každý film vypište ID všech hercù a všech kategorií
SELECT film.film_id, film.title, actor_id, category_id
FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN film_category ON film_category.film_id = film.film_id
ORDER BY film.film_id

--vypište všechny kombinace atributù ID herce a ID kategorie, kde daný herec hrál ve filmu v dané kategorii. Vysledek setøiïte dle ID_herce. dotaz dále rozšiøte o výpis jména a pøijímení herce a názvu kategorie
SELECT DISTINCT actor_id, category_id
FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN film_category ON film_category.film_id = film.film_id
ORDER BY film_actor.actor_id
--dotaz rozšiøte o výpis jména a pøijímení herce a název kategorie
SELECT DISTINCT actor.actor_id, actor.first_name, actor.last_name,
category.category_id, category.name
FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN film_category ON film_category.film_id = film.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
JOIN category ON film_category.category_id = category.category_id
ORDER BY actor.actor_id

--vypište jména filmù, které pùjèovna vlastní alespoò v jedné kategorii
SELECT DISTINCT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id

--zjistìte jéna hercù, kteøí hrají v nìjaké komedii
SELECT DISTINCT a.actor_id, a.first_name +' '+ a.last_name AS actor 
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'

--vypište jména všech zákazníkù, kteøí pochází z itálie a nìkdy mìli pùjèený film s názvem "MOTION DETAILS"
SELECT DISTINCT customer.first_name, customer.last_name
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE country.country = 'Italy' AND film.title = 'MOTIONS DETAILS'--zjistìte jména s pøijímení všech zákazníkù, kteøí mají aktuálnì vypùjèený nìjaký film, kde hraje herec SEAN GUINESSSELECT DISTINCT customer.first_name, customer.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN customer ON rental.customer_id = customer.customer_id
WHERE actor.first_name = 'SEAN' AND actor.last_name = 'GUINESS' AND rental.return_date IS NULL

--vypište ID a èástku všech plateb a u každé platby uveïte datum výpùjèky, tj. hodnotu atributu rental_date v tabulce rental.
--U plateb, které se nevztahují k žádné výpùjèce bude datum výpùjèky NULL.
SELECT p.payment_id, p.amount, r.rental_date
FROM payment p
LEFT JOIN rental r ON p.rental_id = r.rental_id

--Pro každý jazyk vypište názvy všech filmù v daném jazyce. Zajistìte, aby byl každý jazyk ve výsledku obsažen, i když k nìmu nebude existovat film
SELECT l.name, f.title
FROM film f
RIGHT JOIN language l ON f.language_id = l.language_id
--nebo
SELECT language.name, film.title
FROM
language
LEFT JOIN film ON language.language_id = film.language_id

--pro každý film(ID a název) vypište jeho jazyk a jeho pùvodní jazyk
SELECT f.film_id, f.title, l.name AS language, ol.name AS original_language
FROM film f
JOIN language l ON f.language_id = l.language_id
LEFT JOIN language ol ON f.original_language_id = ol.language_id

--vypište názvy filmù, které pùjèovna nevlastní ani v jedné kopii
SELECT film.title
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
WHERE inventory.inventory_id IS NULL

--vypište jména a pøijímení všech zákazníkù, kteøí mají nìjakou nezaplacenou výpùjèku
SELECT DISTINCT first_name, last_name
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
LEFT JOIN payment ON rental.rental_id = payment.rental_id
WHERE payment.payment_id IS NULL

--u každého názvu filmu vypište jazyk filmu, pokud jazyk zaèíná písmenem "I", v opaèném pøípadì bude jazyk NULL
SELECT f.title, l.name
FROM film f
LEFT JOIN language l ON f.language_id = l.language_id AND l.name LIKE 'I%'

--Pro každého zákazníka vypište ID všech plateb s èástkou vìtší ež 9. U zákazníkù, kteøí takovéto platby nemají, bude payment_id rovno NULL.
SELECT first_name, last_name, payment.payment_id
FROM customer
LEFT JOIN payment ON customer.customer_id = payment.customer_id AND payment.amount > 9

--Pro každou výpùjèku (její ID) vypište název filmu, pokud obsahuje písmeno "U", a mìsto a stát zákazníka, jehož adresa obsahuje písmeno "A".
-- Podobnì jako v pøedchozích úlohách - jestliže údaj nesplòuje danou podmínku bude NULL

SELECT r.rental_id, f.title, city.city, country.country
FROM rental r
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film f ON i.film_id = f.film_id AND f.title LIKE '%U%'
LEFT JOIN customer c ON r.customer_id = c.customer_id
LEFT JOIN address a ON c.address_id = a.address_id AND a.address LIKE '%A%'
LEFT JOIN city ON a.city_id = city.city_id
LEFT JOIN country  ON city.country_id = country.country_id

--vypište všechny dvoujce název filmu a pøijímení zákazníka, kde si zákazník vypùjèil daný film. 
--Pokud výpùjèka probìhla po datu 1.1.2006, bude pøijímení zákazníka NULL.
-- z výsledku odstraòte duplicitní øádky
SELECT DISTINCT f.title, c.last_name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN customer c ON r.customer_id = c.customer_id AND r.rental_date <='2006-01-01'