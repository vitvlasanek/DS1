--vypište poèty filmù pro jednotlivé klasifikace
SELECT rating, COUNT(*) FROM film GROUP BY rating

--pro každé ID zákazníka vypište poèet jeho pøijímení je ve výsledku nìco pøekvapivého
SELECT customer_id, COUNT(last_name) AS pocet FROM customer GROUP BY customer_id

--vypište ID zákazníkù setøízená podle poètu souètu všech plateb. zákazníky, kteøí neprovedli žádnou platbu neuvažujte
SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id ORDER BY SUM(amount)

--pro každé jméno a pøijímení herce vypište poèet hercù s takovým jménem a pøijímením. Výsledek sedøiïte dle poètu sestupnì
SELECT first_name, last_name, count(*) AS pocet
FROM actor
GROUP BY first_name, last_name
ORDER BY pocet DESC;

--vypište souèty všech plateb za jednotlivé roky a mìsíce. Výsledek uspoøádejte podle rokù a mìsícù
SELECT YEAR(payment_date) AS rok, MONTH(payment_date) as mesic, SUM(amount) as suma
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER by rok, mesic

----vypište ID skladù s více než 2300 kopiemi filmù
SELECT store_id, COUNT(*)
FROM inventory
GROUP BY store_id
HAVING COUNT(*)>2300

--vypište ID jazykù, pro které je nejkratší film delší než 46 minu
SELECT language_id, MIN(length)
FROM film
GROUP BY language_id
HAVING MIN(length) > 46

--vypište roky a mìsíce plateb, kdy byl souèet plateb vìtší než 20 000
SELECT YEAR(payment_date) AS rok, MONTH(payment_date) AS mesic, SUM(amount) AS soucet
FROM payment
GROUP by YEAR(payment_date), MONTH(payment_date)
HAVING SUM(amount) > 20000

--vypište klasifikace filmù (atribut rating), jejichž délka je menší než 50 minut a celková délka v dané klasifikaci je vìtší než 250 minut. Výsledek setøiïte sestupnì podle abecedy.
SELECT rating
FROM film
WHERE length < 50
GROUP BY rating
HAVING SUM(length) > 250
ORDER BY rating DESC

--vypište jednotlivá ID jazykù a poèet filmù. Vynechejte jyzyky, které nemají žádný film
SELECT language_id, COUNT(*) AS pocet_filmu
FROM film
GROUP BY language_id

--vypište názvy jazykù a k nim poèet filmù. VE výsledku budou i jazyky, které nemají žádný film
SELECT l.language_id, l.name, COUNT(f.film_id) AS pocet_filmu
FROM language l
LEFT JOIN film f ON l.language_id = f.language_id
GROUP BY l.language_id, l.name

--vypište pro jednotlivé zákazníky (ID, jmeno, prijmeni) poèty jejich výpùjèek.
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) as pocet_vypujcek
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name

--vypište pro jednotlivé zákazníky (ID, jm, prij) pocty ruznych filmù, které si vypùjcili
SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT i.film_id) as pocet_filmu
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name

--vypište jména a pøijímení hercù, kteøí hráli ve více než 20-ti filmech
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.first_name,a.last_name
HAVING COUNT(fa.film_id) > 20

--Pro každého zákazníka vypište, kolik celkem utratil za výpùjèky filmù a jaká byla jeho nejmenší, nejvìtší a prùmìrná èástka
SELECT c.first_name, c.last_name, SUM(p.amount) AS suma, MIN(p.amount) AS minimalni_castka, MAX(p.amount) AS maximalni_castka, AVG(CAST(p.amount AS FLOAT)) AS prumerna_castka
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.first_name,c.last_name

--vypište por každou ktaegorii prùmìrnou délku filmu
SELECT c.category_id, c.name, AVG(CAST(f.length AS FLOAT)) AS prumerna_delka
FROM category c
LEFT JOIN film_category fc ON c.category_id = fc.category_id
LEFT JOIN film f ON fc.film_id = f.film_id
GROUP BY c.category_id, c.name

--pro každý film vypište, jaký byl celkový pøíjem z výpùjèek. Vypište jen filmy, kde byl celkový pøíjem vìtší než 100
SELECT f.film_id, f.title, SUM(p.amount) AS celkovy_prijem
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.film_id, f.title
HAVING SUM(p.amount) > 100

--pro každého herce vypište, v kolika rùzných kategoriích filmù hraje
SELECT a.actor_id, a.first_name, a.last_name, COUNT(DISTINCT fc.category_id)
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film_category fc ON fa.film_id = fc.film_id
GROUP BY a.actor_id, a.first_name, a.last_name

--vypište adresy zákazníkù (address.address) vèetnì názvu mìsta a státu, kde ve filmech, které si pùjèili zákazníci hrálo dohromady alespoò 40 rùzných hercù
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

--Pro všechny filmy (id, nazev) spadající do kategorie "horror" uveïte, v kolika rùzných mìstech bydlí zákazníci, kteøí si daný film pùjèili
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

--pro všechny zíkazníky z polska vypište, do  kolika rùzných kategorií spadají filmy, které si tito zákazníi vypùjèili
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
WHERE country.country = ’Poland’
GROUP BY customer.customer_id, customer.first_name, customer.last_name

--vypište názvy všech jazykù k nim poèty filmùv daném jazyce, které jsou delší než 350 minut.
SELECT l.name, COUNT(f.film_id) as pocet_filmu
FROM language l
LEFT JOIN film f ON l.language_id = f.language_id
WHERE f.length > 350
GROUP BY l.name

--vypište kolik jednotliví zákazníci utratili za výpùjèky, které zaèali v mìsíci èervnu
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS suma
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id AND MONTH(r.rental_date) = 6
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name


--Vypište seznam kategorií setøízený podle poètu filmù jejichž jazyk zaèíná na "E"
SELECT
category.name
FROM category
LEFT JOIN film_category ON category.category_id = film_category.category_id
LEFT JOIN film ON film_category.film_id = film.film_id
LEFT JOIN language ON film.language_id = language.language_id
AND language.name LIKE 'E%'
GROUP BY category.name
ORDER BY COUNT(language.language_id)

--vypiššte názvy filmù s délkou menší než 5O minut, které si zákazníci s pøijímením BELL pùjèili pøesnì 1x
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