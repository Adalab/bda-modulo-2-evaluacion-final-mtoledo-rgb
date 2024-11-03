USE sakila;
-- 1.
SELECT DISTINCT title
	FROM film;

-- 2. 
SELECT title
	FROM film
	WHERE rating = 'PG-13'; 

-- 3. 
SELECT title, description 
	FROM film
	WHERE description LIKE '% amazing %'; 
 -- use the % symbols and spaces on either side of the word to narrow and specify the search to exact matches.
 
-- 4. 
SELECT title, length
	FROM film
	WHERE length > 120;
 

-- 5. 
SELECT first_name, last_name
	FROM actor;


-- 6. 
SELECT first_name, last_name
	FROM actor
	WHERE last_name LIKE '%Gibson%';
--     -- extend the query to any Gibson match so that will return not only the identical data, but also the containers. 

-- 7. 
SELECT first_name, last_name
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20; 
    -- the BETWEEN clause is used to find matches within two values, including themselves

-- 8. 
SELECT title, rating
	FROM film
	WHERE NOT rating = 'R' AND NOT rating = 'PG-13';


-- 9. 
SELECT COUNT(film_id) AS total_films, rating 
	FROM film
	GROUP BY rating;
-- the COUNT function allows us to calculate the number of film registrations and to group them by each category, therefore giving us the total number of films for each of them. 


-- 10. 

SELECT r.customer_id, c.first_name, c.last_name, SUM(rental_id) AS total_rentals
	FROM rental AS r
		JOIN customer 
			AS c ON c.customer_id = r.customer_id
	GROUP BY r.customer_id; 
    /* the JOIN clause acts as a bridge to join the table that registers the rentals with the table that registers the clients' data. 
    in this way, together with the SUM function, we can obtain the number of times a customer has made a rental and group by results */


-- 11. 
-- ** control query: total number of films per category
SELECT COUNT(*) AS total_per_category,c.category_id, c.name
	FROM category AS c 
		JOIN film_category 
			AS fc ON fc.category_id = c.category_id
	GROUP BY c.category_id;

-- ** control query: total rented films
SELECT COUNT(r.rental_id) as total_rentals, i.film_id
	FROM rental AS r
		JOIN inventory 
			AS i ON i.inventory_id = r.inventory_id
	GROUP BY i.film_id;

-- FINAL RESULT
SELECT  c.name AS category, COUNT(r.rental_id) AS total_rentals
	FROM category AS c 
		JOIN film_category 
			AS fc ON fc.category_id = c.category_id
		JOIN inventory 
			AS i ON i.film_id = fc.film_id
		JOIN rental 
			AS r ON r.inventory_id = i.inventory_id  
	GROUP BY c.category_id;
	/* the intended result of this query is to find out which are the most demanded categories,
    to do this, we count the number of records in ‘rental_id’ and group them by category; 
    due to the database requirements, three JOINs were necessary to access the tables containing the data*/
    
-- BONUS RESULT WITH NO DUPLICATES FILMS
SELECT  c.name AS category, COUNT(r.rental_id) AS total_rentals, COUNT(DISTINCT i.film_id) AS total_unique_movies_rented
	FROM category AS c 
		JOIN film_category 
			AS fc ON fc.category_id = c.category_id
		JOIN inventory 
			AS i ON i.film_id = fc.film_id
		JOIN rental 
			AS r ON r.inventory_id = i.inventory_id  
	GROUP BY c.category_id;
-- in parallel to knowing which categories are most in demand, it may also be interesting to know how many times those demands have been unique to each category.    


-- 12. 
SELECT rating, ROUND(AVG(length)) AS average_length
	FROM film 
	GROUP BY rating;
    /* AVG is a function which returns the average length of the films, so that we can group them according to their classification. 
    and know which categories have the longest or the shortest duration */ 

-- 13. 
SELECT first_name, last_name, title
	FROM actor
		JOIN film_actor 
			USING (actor_id)
		JOIN film 
			USING (film_id)
	WHERE title = 'Indian Love';
-- finds the data by joining the tables that contain it and applies a condition that must be met in the WHERE clause.

-- 14. 
SELECT title
	FROM film
	WHERE description LIKE '% dog %' 
		OR description LIKE '% cat %';
 -- the OR condition opens the search frame to all entries that meet one or the other condition.        
        
-- 15.
-- FINAL RESULT
SELECT fa.actor_id, a.first_name, a.last_name, f.title 
	FROM film_actor AS fa
		LEFT JOIN film AS f 
			USING (film_id)
		JOIN actor AS a 
			USING (actor_id)
	WHERE actor_id IS NULL;
	/* IS NULL is a boolean condition, if it is met it will return the results of actors or actresses that are not in any movie in the list; 
    as long as it is not fulfilled, that table will be empty.*/

-- ** control query: 
SELECT fa.actor_id, a.first_name, a.last_name, f.title 
	FROM film_actor AS fa
		LEFT JOIN film AS f 
			USING (film_id)
		JOIN actor AS a 
			USING (actor_id)
	WHERE actor_id IS NOT NULL;
       -- the fact that the previous query is empty indicates that currently there are no results that meet these conditions, but there may be in the future and this query will be very useful.
-- in next steps we could include a query that gives us the individual matches of actors to each film.

-- 16. 
SELECT title
	FROM film
	WHERE release_year BETWEEN 2004 AND 2010;

-- 17. 
SELECT f.title
	FROM film AS f
		JOIN film_category AS fc 
			USING(film_id)
		JOIN category AS c 
			USING(category_id)             
	WHERE name = 'Family';
          
          
-- 18. 
SELECT a.first_name, a.last_name
	FROM actor AS a
		JOIN film_actor USING(actor_id)
		JOIN film AS f USING(film_id)
	GROUP BY  actor_id
		HAVING COUNT(f.film_id) > 10
	ORDER BY COUNT(f.film_id) ASC;
	/* the implementation of the COUNT function in the condition specified by the HAVING clause, allows us to know the result of the result from the sum of them films in which the actors appear, as long as this sum is greater than 10. 
    of the films in which the actors appear, provided that this sum is greater than 10. */

-- 19. 
SELECT title
	FROM film
	WHERE rating = 'R' AND length > 120
		ORDER BY length;
       /* the AND clause determines that the query will only return film titles whose 
       rating and duration match the detailed requirements.*/

-- 20. 
SELECT fc.category_id,c.name, ROUND(AVG(f.length)) AS avg_length
	FROM film AS f
		JOIN film_category AS fc 
			USING(film_id)
        JOIN category AS c
			USING(category_id)
	GROUP BY category_id
		HAVING AVG(f.length) > 120;


-- 21.
SELECT a.first_name, a.last_name , COUNT(f.film_id) AS total_films_per_actor
	FROM film AS f
		JOIN film_actor AS fa
			USING (film_id)
		JOIN actor AS a
			USING (actor_id)
	GROUP BY actor_id
		HAVING COUNT(f.film_id) > 5
	ORDER BY COUNT(f.film_id);

-- 22. 
-- **control query: rental_id which rentals were longer than 5 days
SELECT rental_id, 
		DATEDIFF(return_date,rental_date) AS rental_duration -- DATEDIFF es una función que permite cuantificar la diferencia que hay entre dos fechas, por defecto contará los días, a no ser que se le indiquen parámetros concretos. 
	FROM rental
	WHERE DATEDIFF(return_date,rental_date) > 5;

-- control query: relationship query for all other data
SELECT f.title
	FROM film AS f
		JOIN inventory AS i 
			USING(film_id)
		JOIN rental AS r 
			USING (inventory_id);

-- FINAL RESULT
SELECT f.title,r.rental_id, DATEDIFF(r.return_date,r.rental_date) AS rental_duration
	FROM film AS f
		JOIN inventory AS i 
			USING(film_id)
		JOIN rental AS r 
			USING (inventory_id)
	WHERE rental_id IN 
					(SELECT rental_id
						FROM rental
						WHERE DATEDIFF(return_date,rental_date) > 5)
	ORDER BY rental_duration ASC;
/* This query will return the titles of the films whose rental time is longer than 5 days, using the DATEDIFF function 
to obtain the difference of days between two dates, several JOINs to communicate between multiple tables and a subquery 
in the WHERE clause that fulfils the conditions that the movies must accomplish before being returned among the results.*/

-- 23. 
-- **control query: actors who have worked in a ‘horror’ film
SELECT a.actor_id
FROM actor AS a
JOIN film_actor AS fa USING (actor_id)
JOIN film_category AS fc USING (film_id)
JOIN category AS c USING (category_id)
WHERE c.name = 'Horror';

-- FINAL RESULT
SELECT a.first_name, a.last_name, c.name AS category
	FROM actor AS a
		JOIN film_actor AS fa
			USING (actor_id)
		JOIN film_category AS fc 
			USING (film_id)
		JOIN category AS c 
			USING (category_id)
	WHERE a.actor_id NOT IN (SELECT a.actor_id
							FROM actor
							WHERE c.name = 'Horror');
-- here the subquery develops the filter that we want it to fulfil so that, by using the clause NOT IN, it returns just the opposite of what the subquery asks for.

-- 24. BONUS.
SELECT f.title
	FROM film AS f
		JOIN film_category AS fc 
			USING (film_id)
		JOIN category AS c 
			USING (category_id) 
	WHERE c.name = 'Comedy' AND length > 180
	ORDER BY f.length;


-- 25. BONUS.
-- **control query: actors who have worked in the same film
SELECT  FA1.actor_id AS actor1_id, 
		FA2.actor_id AS actor2_id, 
		FA1.film_id
	FROM film_actor AS FA1
		JOIN film_actor AS FA2 
			ON FA1.film_id = FA2.film_id 
            AND FA1.actor_id < FA2.actor_id;
-- this control query is design to access the data directly related: actor_id and film_id


-- ** control query: CTW names and last names
SELECT  a1.first_name AS actor1_name, 
		a1.last_name AS actor1_last, 
		a2.first_name AS actor2_name, 
        a2.last_name AS actor2_last
	FROM actor as a1 
	JOIN actor as a2 
		ON a1.actor_id <> actor_id; 
/* We design what will be the CTE that will serve as the basis for applying the conditions that the results
must have, which means, to create pairs of different ‘actor_id’ whose participate in the same ‘film_id ’*/

-- FINAL RESULT -- ! IMPORTANT: THE QUERY DOES NOT ALWAYS RUN, BUT HAS BEEN TESTED WITH OTHER TOOLS.  
WITH actor_pairs 
			AS (SELECT FA1.actor_id AS actor1_id, FA2.actor_id AS actor2_id, FA1.film_id
			FROM film_actor AS FA1
			JOIN film_actor AS FA2 ON FA1.film_id = FA2.film_id AND FA1.actor_id < FA2.actor_id)
	SELECT  a1.first_name AS actor1_name, 
		a1.last_name AS actor1_last, 
        a2.first_name AS actor2_name, 
        a2.last_name AS actor2_last, 
        f.title AS film_tilte
		FROM actor_pairs 
			JOIN actor AS a1 
				ON actor_pairs.actor1_id = actor1_id
			JOIN actor AS a2 
				ON actor_pairs.actor2_id = actor2_id
			JOIN film AS f 
				ON actor_pairs.film_id = f.film_id;        
	/* STEPS:
        - create the pairs of actors with different ids that have participated in the same movie -- CTE
        - create the query with the data we want it to include: first and last names of each actor who has participated in the film, and the title of the film -- SELECT
        - specify what we want to search among the pairs of actors returned by the CTE -- FROM
        - make the necessary joins to access all the data that we want to appear -- JOINs*/


