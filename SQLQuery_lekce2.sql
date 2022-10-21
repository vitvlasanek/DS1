-- vypi�te v�echny informace o m�stech v�etn� odpov�daj�c�ch informac� o st�tech, kde se tato m�sta nach�zej�
SELECT * FROM city ci JOIN country co ON ci.country_id = co.country_id

--vypi�te n�zvy v�ech film� v�etn� jazyka
SELECT f.title, lan.name FROM film f JOIN language lan ON f.language_id = lan.language_id

--vypi�te ID v�ech v�p�j�ek z�kazn�ka s p�ij�men�m simpson
SELECT rental_id FROM rental r JOIN customer c ON r.customer_id = c.customer_id WHERE c.last_name = 'SIMPSON'

--Vypi�te adresu (address.address) z�azn�ka s p�ij�men�m SIMPSON. Porovnejte tento p��klad s p�edchoz�m co do po�tu ��dk�
SELECT a.address FROM address a JOIN customer c ON a.address_id = c.address_id WHERE c.last_name = 'SIMPSON'

--pro ka�d�ho z�kazn�ka (jmeno, prijimeni) vypi�te adresu bydli�t� v�etn� n�zvu m�sta
SELECT c.first_name, c.last_name, a.address, a.postal_code, city.city  FROM customer c JOIN address a ON c.address_id = a.address_id JOIN city ON a.city_id = city.city_id 

--vypi�te ID v�ech v�p�j�ek v�etn� jm�na zam�stnance, jm�na z�kazn�ka a n�zvu filmu
SELECT r.rental_id, 
s.first_name + ' ' + s.last_name AS staff_name,
c.first_name +' ' + c.last_name AS customer_name,
f.title
FROM rental r 
JOIN staff s ON r.staff_id = s.staff_id 
JOIN customer c  ON r.customer_id = c.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id

--pro ka�d� film (jeho n�zev) vypi�te jm�na a p�ij�men� v�ech herc�, kter� ve filmu hr�j�.
SELECT f.title, a.first_name, a.last_name 
FROM film f 
JOIN film_actor fa ON f.film_id = fa.film_id 
JOIN actor a ON fa.actor_id = a.actor_id
ORDER BY f.title

--pro ka�d�ho herce (jm a p�) vypi�te jm�na film�, kde hr�l
SELECT actor.first_name, actor.last_name, film.title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
ORDER BY actor.last_name, actor.first_name

--vypi�te n�zvy v�ech film� v kategorii horor
Select f.title FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Horror'

--pro ka�d� sklad vypi�te jm�no a p�ij�men� spr�vce. d�le adresu skladu a adresu spr�vce.
SELECT st.store_id, sta.address AS store_address, sf.first_name +' '+ sf.last_name AS manager, sfa.address as manager_address
FROM store st
JOIN staff sf ON st.manager_staff_id = sf.staff_id
JOIN address sta ON st.address_id = sta.address_id
JOIN address sfa ON st.address_id = sfa.address_id

--pro ka�d� film vypi�te ID v�ech herc� a v�ech kategori�
SELECT film.film_id, film.title, actor_id, category_id
FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN film_category ON film_category.film_id = film.film_id
ORDER BY film.film_id

--vypi�te v�echny kombinace atribut� ID herce a ID kategorie, kde dan� herec hr�l ve filmu v dan� kategorii. Vysledek set�i�te dle ID_herce. dotaz d�le roz�i�te o v�pis jm�na a p�ij�men� herce a n�zvu kategorie
SELECT DISTINCT actor_id, category_id
FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN film_category ON film_category.film_id = film.film_id
ORDER BY film_actor.actor_id
--dotaz roz�i�te o v�pis jm�na a p�ij�men� herce a n�zev kategorie
SELECT DISTINCT actor.actor_id, actor.first_name, actor.last_name,
category.category_id, category.name
FROM film
JOIN film_actor ON film_actor.film_id = film.film_id
JOIN film_category ON film_category.film_id = film.film_id
JOIN actor ON film_actor.actor_id = actor.actor_id
JOIN category ON film_category.category_id = category.category_id
ORDER BY actor.actor_id

--vypi�te jm�na film�, kter� p�j�ovna vlastn� alespo� v jedn� kategorii
SELECT DISTINCT f.title FROM film f JOIN inventory i ON f.film_id = i.film_id

--zjist�te j�na herc�, kte�� hraj� v n�jak� komedii
SELECT DISTINCT a.actor_id, a.first_name +' '+ a.last_name AS actor 
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'

--vypi�te jm�na v�ech z�kazn�k�, kte�� poch�z� z it�lie a n�kdy m�li p�j�en� film s n�zvem "MOTION DETAILS"
SELECT DISTINCT customer.first_name, customer.last_name
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE country.country = 'Italy' AND film.title = 'MOTIONS DETAILS'--zjist�te jm�na s p�ij�men� v�ech z�kazn�k�, kte�� maj� aktu�ln� vyp�j�en� n�jak� film, kde hraje herec SEAN GUINESSSELECT DISTINCT customer.first_name, customer.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN customer ON rental.customer_id = customer.customer_id
WHERE actor.first_name = 'SEAN' AND actor.last_name = 'GUINESS' AND rental.return_date IS NULL

--vypi�te ID a ��stku v�ech plateb a u ka�d� platby uve�te datum v�p�j�ky, tj. hodnotu atributu rental_date v tabulce rental.
--U plateb, kter� se nevztahuj� k ��dn� v�p�j�ce bude datum v�p�j�ky NULL.
SELECT p.payment_id, p.amount, r.rental_date
FROM payment p
LEFT JOIN rental r ON p.rental_id = r.rental_id

--Pro ka�d� jazyk vypi�te n�zvy v�ech film� v dan�m jazyce. Zajist�te, aby byl ka�d� jazyk ve v�sledku obsa�en, i kdy� k n�mu nebude existovat film
SELECT l.name, f.title
FROM film f
RIGHT JOIN language l ON f.language_id = l.language_id
--nebo
SELECT language.name, film.title
FROM
language
LEFT JOIN film ON language.language_id = film.language_id

--pro ka�d� film(ID a n�zev) vypi�te jeho jazyk a jeho p�vodn� jazyk
SELECT f.film_id, f.title, l.name AS language, ol.name AS original_language
FROM film f
JOIN language l ON f.language_id = l.language_id
LEFT JOIN language ol ON f.original_language_id = ol.language_id

--vypi�te n�zvy film�, kter� p�j�ovna nevlastn� ani v jedn� kopii
SELECT film.title
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
WHERE inventory.inventory_id IS NULL

--vypi�te jm�na a p�ij�men� v�ech z�kazn�k�, kte�� maj� n�jakou nezaplacenou v�p�j�ku
SELECT DISTINCT first_name, last_name
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
LEFT JOIN payment ON rental.rental_id = payment.rental_id
WHERE payment.payment_id IS NULL

--u ka�d�ho n�zvu filmu vypi�te jazyk filmu, pokud jazyk za��n� p�smenem "I", v opa�n�m p��pad� bude jazyk NULL
SELECT f.title, l.name
FROM film f
LEFT JOIN language l ON f.language_id = l.language_id AND l.name LIKE 'I%'

--Pro ka�d�ho z�kazn�ka vypi�te ID v�ech plateb s ��stkou v�t�� e� 9. U z�kazn�k�, kte�� takov�to platby nemaj�, bude payment_id rovno NULL.
SELECT first_name, last_name, payment.payment_id
FROM customer
LEFT JOIN payment ON customer.customer_id = payment.customer_id AND payment.amount > 9

--Pro ka�dou v�p�j�ku (jej� ID) vypi�te n�zev filmu, pokud obsahuje p�smeno "U", a m�sto a st�t z�kazn�ka, jeho� adresa obsahuje p�smeno "A".
-- Podobn� jako v p�edchoz�ch �loh�ch - jestli�e �daj nespl�uje danou podm�nku bude NULL

SELECT r.rental_id, f.title, city.city, country.country
FROM rental r
LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
LEFT JOIN film f ON i.film_id = f.film_id AND f.title LIKE '%U%'
LEFT JOIN customer c ON r.customer_id = c.customer_id
LEFT JOIN address a ON c.address_id = a.address_id AND a.address LIKE '%A%'
LEFT JOIN city ON a.city_id = city.city_id
LEFT JOIN country  ON city.country_id = country.country_id

--vypi�te v�echny dvoujce n�zev filmu a p�ij�men� z�kazn�ka, kde si z�kazn�k vyp�j�il dan� film. 
--Pokud v�p�j�ka prob�hla po datu 1.1.2006, bude p�ij�men� z�kazn�ka NULL.
-- z v�sledku odstra�te duplicitn� ��dky
SELECT DISTINCT f.title, c.last_name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN customer c ON r.customer_id = c.customer_id AND r.rental_date <='2006-01-01'