USE sakila;
-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
SELECT DISTINCT title
	FROM film;

-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
SELECT title
	FROM film
	WHERE rating = 'PG-13'; 

-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title, description 
	FROM film
	WHERE description LIKE '% amazing %'; 
    -- utilizamos los símbolos % y espacios a cada lado de la palabra para acotar y especificar la búsqueda a las coincidencias exactas.

-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
SELECT title, length
	FROM film
	WHERE length > 120;
 

-- 5. Recupera los nombres de todos los actores.
SELECT first_name, last_name
	FROM actor;


-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
	FROM actor
	WHERE last_name LIKE '%Gibson%';
    -- abrimos la consulta a cualquier coincidencia con Gibson para que no devuelva únicamente los datos idénticos, sino también los contenededores. 


-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT first_name, last_name
	FROM actor
	WHERE actor_id BETWEEN 10 AND 20; 
    -- la claúsula BETWEEN nos sirve para encontrar coincidencias entre dos valores, incluyendo a éstos en los resultados

-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
SELECT title, rating
	FROM film
	WHERE NOT rating = 'R' AND NOT rating = 'PG-13';


-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT COUNT(film_id) AS total_films, rating 
	FROM film
	GROUP BY rating;
    -- la función COUNT nos permite contar el número de registros de películas y agruparlas por cada categoría, obteniendo así el número total de películas por cada una de ellas. 

-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- customer, rental 
SELECT r.customer_id, c.first_name, c.last_name, SUM(rental_id) AS total_rentals
	FROM rental AS r
		JOIN customer 
			AS c ON c.customer_id = r.customer_id
	GROUP BY r.customer_id; 
    /* la clausula JOIN nos sirve de puente para unir la tabla que registra los alquileres con la que registra los datos de clientes 
    de esta forma, junto con la funcion SUM, podemos obtener las veces que un cliente ha realizado un alquiler y agrupar por resultados */

-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

-- ** consulta de control: total de películas por categoría
SELECT COUNT(*) AS total_per_category,c.category_id, c.name
	FROM category AS c 
		JOIN film_category 
			AS fc ON fc.category_id = c.category_id
	GROUP BY c.category_id;

-- ** consulta de control: total películas alquiladas
SELECT COUNT(r.rental_id) as total_rentals, i.film_id
	FROM rental AS r
		JOIN inventory 
			AS i ON i.inventory_id = r.inventory_id
	GROUP BY i.film_id;

-- RESULTADO TOTAL
SELECT  c.name AS category, COUNT(r.rental_id) AS total_rentals
	FROM category AS c 
		JOIN film_category 
			AS fc ON fc.category_id = c.category_id
		JOIN inventory 
			AS i ON i.film_id = fc.film_id
		JOIN rental 
			AS r ON r.inventory_id = i.inventory_id  
	GROUP BY c.category_id;
    /* el resultado deseado de esta consulta es de conocer cuáles son las categorías más demandadas,
    para ello contamos la cantidad de registros en "rental_id" y los agrupamos por categorías; 
    por exigencias de la base de datos, fueron necesarios tres JOINs para acceder a las tablas contenedoras de los datos*/
-- RESULTADO EXTRA SIN DUPLICADOS DE PELÍCULAS
SELECT  c.name AS category, COUNT(r.rental_id) AS total_rentals, COUNT(DISTINCT i.film_id) AS total_unique_movies_rented
	FROM category AS c 
		JOIN film_category 
			AS fc ON fc.category_id = c.category_id
		JOIN inventory 
			AS i ON i.film_id = fc.film_id
		JOIN rental 
			AS r ON r.inventory_id = i.inventory_id  
	GROUP BY c.category_id;
    -- además de saber cuáles son las categorías más demandadas, también puede ser interesante conocer las veces que esas demandas han sido únicas para cada categoría. 
    

-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT rating, ROUND(AVG(length)) AS average_length
	FROM film 
	GROUP BY rating;
    /* AVG es una función que nos devuelve el promedio de la duración de las películas, para poder agruparlas según su clasificación 
    y conocer qué categorías ostentan las duraciones más largas o cortas */ 

-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT first_name, last_name, title
	FROM actor
		JOIN film_actor 
			USING (actor_id)
		JOIN film 
			USING (film_id)
	WHERE title = 'Indian Love';
	-- encontramos los datos uniendo las tablas que los contengan y le aplicamos una condición que debe cumplir en la clausula WHERE.

-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title
	FROM film
	WHERE description LIKE '% dog %' 
		OR description LIKE '% cat %';
        -- la condición OR abre el marco de la búsqueda a todas las entradas que cumplan una u otra condición.
        
        
-- 15. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.

-- RESULTADO FINAL 
SELECT fa.actor_id, a.first_name, a.last_name, f.title 
	FROM film_actor AS fa
		LEFT JOIN film AS f 
			USING (film_id)
		JOIN actor AS a 
			USING (actor_id)
	WHERE actor_id IS NULL;
	/* IS NULL es una condición booleana, si se cumple nos devolverá los resultados de actores o actrices que no participen en ninguna película de la lista; 
    mientras no se cumpla, esa tabla estará vacía.*/

-- **consulta de control: 
SELECT fa.actor_id, a.first_name, a.last_name, f.title 
	FROM film_actor AS fa
		LEFT JOIN film AS f 
			USING (film_id)
		JOIN actor AS a 
			USING (actor_id)
	WHERE actor_id IS NOT NULL;
    -- que la consulta anterior esté vacía nos indica que POR EL MOMENTO no existen resultados que cumplan esas condiciones, pero puede haberlos en el futuro y esa consulta será de gran utilidad.
-- en next steps se podría incluir una consulta que nos duelva las coincidencias individuales de actores con cada película

-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title
	FROM film
	WHERE release_year BETWEEN 2004 AND 2010;

-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT f.title
	FROM film AS f
		JOIN film_category AS fc 
			USING(film_id)
		JOIN category AS c 
			USING(category_id)             
	WHERE name = 'Family';
          
          
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT a.first_name, a.last_name
	FROM actor AS a
		JOIN film_actor USING(actor_id)
		JOIN film AS f USING(film_id)
	GROUP BY  actor_id
		HAVING COUNT(f.film_id) > 10
	ORDER BY COUNT(f.film_id) ASC;
	/* la aplicación de la función COUNT en la condición especificada por la clausula HAVING, nos permite conocer el resultado de la suma 
    de las películas en las que aparecen los actores, siempre y cuando esa suma sea superior a 10. */

-- 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title
	FROM film
	WHERE rating = 'R' AND length > 120
		ORDER BY length;
        /* la clausula AND determina que la consulta solo nos devolverá los títulos de películas cuya clasificación y duración
        coincidan con los requisitos detallados.*/

-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT fc.category_id,c.name, ROUND(AVG(f.length)) AS avg_length
	FROM film AS f
		JOIN film_category AS fc 
			USING(film_id)
        JOIN category AS c
			USING(category_id)
	GROUP BY category_id
		HAVING AVG(f.length) > 120;


-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
SELECT a.first_name, a.last_name , COUNT(f.film_id) AS total_films_per_actor
	FROM film AS f
		JOIN film_actor AS fa
			USING (film_id)
		JOIN actor AS a
			USING (actor_id)
	GROUP BY actor_id
		HAVING COUNT(f.film_id) > 5
	ORDER BY COUNT(f.film_id);

-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.

-- **consulta de control: rental_id con alquileres de una duración superior a 5 días
SELECT rental_id, 
		DATEDIFF(return_date,rental_date) AS rental_duration -- DATEDIFF es una función que permite cuantificar la diferencia que hay entre dos fechas, por defecto contará los días, a no ser que se le indiquen parámetros concretos. 
	FROM rental
	WHERE DATEDIFF(return_date,rental_date) > 5;

-- **consulta de control: consulta de relación para el resto de datos
SELECT f.title
	FROM film AS f
		JOIN inventory AS i 
			USING(film_id)
		JOIN rental AS r 
			USING (inventory_id);

-- RESULTADO COMPLETO
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
/* esta consulta nos devolverá los títulos de las películas cuya tiempo de alquiler sea superior a 5 días, utilizando la función DATEDIFF 
para obtener la diferencia de días entre dos fechas, varios JOINs para comunicarnos entre varias tablas y una subconsulta en la clausula WHERE que cumpla 
con las condiciones que deben cumplir las películas antes de ser devueltas entre los resultados. */

-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.
-- **consulta de control: actores que han trabajado en una película de 'horror'
SELECT a.actor_id
FROM actor AS a
JOIN film_actor AS fa USING (actor_id)
JOIN film_category AS fc USING (film_id)
JOIN category AS c USING (category_id)
WHERE c.name = 'Horror';

-- RESULTADO FINAL
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
-- aquí la subconsulta desarrolla el filtro que queremos que cumpla para que, mediante la clausula NOT IN nos devuelva justo lo contrario a lo que la subconsulta pide. 

-- 24. BONUS: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.
SELECT f.title
	FROM film AS f
		JOIN film_category AS fc 
			USING (film_id)
		JOIN category AS c 
			USING (category_id) 
	WHERE c.name = 'Comedy' AND length > 180
	ORDER BY f.length;


-- 25. BONUS: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
                        
-- **consulta de control: actores que han trabajado en la misma película
SELECT  FA1.actor_id AS actor1_id, 
		FA2.actor_id AS actor2_id, 
		FA1.film_id
	FROM film_actor AS FA1
		JOIN film_actor AS FA2 
			ON FA1.film_id = FA2.film_id 
            AND FA1.actor_id < FA2.actor_id;
-- realizamos una consulta de control para acceder a los datos que se van a realicionar directamente: actor_id y film_id

-- **consulta de control: CTE nombres y apellidos
SELECT  a1.first_name AS actor1_name, 
		a1.last_name AS actor1_last, 
		a2.first_name AS actor2_name, 
        a2.last_name AS actor2_last
	FROM actor as a1 
	JOIN actor as a2 
		ON a1.actor_id <> actor_id; 
/* diseñamos la que será la CTE que servirá de base para aplicar las condiciones que deben tener los resultados, es decir, crear pares de "actor_id" distintos 
que aparezcan participando en un mismo "film_id"*/

-- RESULTADO FINAL -- !! IMPORTANTE: LA CONSULTA NO SIEMPRE SE EJECUTA, PERO SE HA COMPRADO SU FUNCIONAMIENTO CON OTRAS HERRAMIENTAS 
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
		/* PASOS:
        - Creamos los pares de actores con diferente id que hayan participado en la misma película -- CTE
        - Creamos la consulta con los datos que queremos que contenga la tabla: nombres y apellidos de cada actor que ha participado en la película, y título de la película -- SELECT
        - Especificamos que queremos que busque entre los pares de actores que nos devuelve la CTE -- FROM
        - Hacemos las uniones necesarias para acceder a todos los datos que queremos que aparezcan -- JOINs*/
    

/* BONUS DE MIREIA TOLEDO MOYA - ANALISTA DE DATOS EN PROCESO:
-- CTE = ¿está en el actor en la película?
-- se pueden hacer dos líneas de con los mismos datos diferenciándolos, usa una cte para una de las comparaciones, así solo hay un join, el truco está en que 1 sea 
-- CTE = actor_a
SELECT a1.first_name AS firts_name_a, a1.last_name AS last_name_a
FROM actor;

SELECT a2.first_name AS first_name_b, a2.last_name AS last_name_b, f.title
FROM film
JOIN film_actor AS fa USING(actor_id)
WHERE actor_id IN (SELECT film_id
					FROM film);

-- que el actor 1 y el actor 2 hayan participado en la misma película 
SELECT actor_id, film_id
FROM film_actor AS A1
WHERE A1.actor_id = ALL (SELECT A2.actor_id
						FROM film_actor AS A2
                        WHERE A1.film_id = A2.film_id); */


