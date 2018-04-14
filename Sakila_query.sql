--Connect to Sakila Database
USE sakila;


-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
	FROM actor
	LIMIT 5;

/* 1b. Display the first and last name of each actor in a
single column in upper case letters. Name the column Actor Name. */
SELECT UPPER(concat_ws(' ',first_name,last_name))
	AS `Actor Name`
	FROM actor
	LIMIT 5;

/*2a. You need to find the ID number, first name, and last name of an actor,
of whom you know only the first name, "Joe."
What is one query would you use to obtain this information?
*/
SELECT actor_id, first_name, last_name
	FROM actor
	WHERE first_name like 'Joe'
	LIMIT 5;

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT *
	FROM actor
	WHERE last_name like '%GEN%'
	LIMIT 5;

/* 2c. Find all actors whose last names contain the letters LI.
 This time, order the rows by last name and first name, in that order:
 */
SELECT *
	FROM actor
	WHERE last_name like '%LI%'
	order by last_name, first_name
	LIMIT 5;

/* 2d. Using IN, display the country_id and country columns of the
following countries: Afghanistan, Bangladesh, and China:
*/
SELECT country_id, country
	FROM country
	WHERE country IN ('Afghanistan', 'Bangladesh', 'China')
	LIMIT 5;

/*3a. Add a middle_name column to the table actor.
Position it between first_name and last_name.
Hint: you will need to specify the data type.
*/
ALTER TABLE actor
	ADD COLUMN `middle_name` varchar(50) AFTER first_name;

/*3b. You realize that some of these actors have tremendously long last names.
Change the data type of the middle_name column to blobs.
*/
Alter Table actor
	modify column middle_name blob;

-- 3c. Now delete the middle_name column.
ALTER TABLE actor
	DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS `Count of Actors w/ Same LastName`
	FROM actor
	group by last_name
	HAVING COUNT(last_name) > 0;

/* 4b. List last names of actors and the number of actors who have that last name,
but only for names that are shared by at least two actors
*/
SELECT last_name, COUNT(last_name) AS `Count of Actors w/ Same LastName`
	FROM actor
	group by last_name
	HAVING COUNT(last_name) > 1;

/* 4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table
as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher.
Write a query to fix the record.
*/
UPDATE actor
	SET first_name = 'HARPO'
	WHERE first_name = 'GROUCHO' AND last_name='WILLIAMS';


/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO.
It turns out that GROUCHO was the correct name after all!
In a single query, if the first name of the actor is currently HARPO,
change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO,
as that is exactly what the actor will be with the grievous error.
BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO,
HOWEVER! (Hint: update the record using a unique identifier.)
*/

UPDATE actor SET
	first_name = IF(first_name = 'HARPO', 'GROUCHO', IF (first_name = 'GROUCHO', "MUCHO GROUCHO", first_name ))
	WHERE last_name='WILLIAMS';


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
CREATE TABLE IF NOT EXISTS address (
	address_id SMALLINT(10) AUTO_INCREMENT NOT NULL,
	address VARCHAR(50),
    address_2 VARCHAR(50),
	district VARCHAR(50),
    city_id SMALLINT(10),
    postal_code int(10),
    phone INTEGER(15),
    location VARCHAR(50),
    last_update timestamp,
    PRIMARY KEY(address_id),
    CONSTRAINT FK_CityAddress FOREIGN KEY (city_id) REFERENCES CITY(city_id)
);

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT concat_ws(' ',S.first_name, S.last_name) AS Name, concat_ws(", " ,A.address, A.district)
	AS Address
	FROM staff AS S
	LEFT JOIN address AS A ON S.address_id = A.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT concat_ws(" " ,S.first_name, S.last_name)AS `Staff`,
	sum(P.amount) AS `Total Amount`
	FROM payment AS P
	JOIN staff AS S
	ON
		P.staff_id = S.staff_id
		WHERE year(P.payment_date) = 2005 and month(P.payment_date) = 8
		group by P.staff_id;


-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT F.title as `Film`, COUNT(FA.film_id)
	AS `Number of Actors`
	FROM film AS F
	INNER JOIN film_actor AS FA
	ON
		F.film_id = FA.film_id
		group by F.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT F.title as `Film`, COUNT(I.film_id)
	AS `Inventory Count`
	FROM film AS F
	INNER JOIN inventory AS I
	ON
	F.film_id = I.film_id
	WHERE F.title like	'Hunchback Impossible'
	GROUP BY F.film_id, F.title;

/*6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
List the customers alphabetically by last name:
    ![Total amount paid](Images/total_payment.png)
*/
SELECT C.last_name, C.first_name,concat_ws(" " ,C.first_name, C.last_name)AS `Customer`, sum(P.amount)
	AS `Total Amount Paid`
	FROM customer as C
	INNER JOIN payment as P
	ON
	C.customer_id = P.customer_id
	group by C.customer_id, C.first_name
	ORDER BY C.last_name ASC;

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
*/
SELECT title as `Movie Title`
FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%') AND
	(SELECT language_id
	FROM language
	WHERE name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT actor_id, concat_ws(' ',first_name,last_name) as `Actors in Movie`
FROM actor
WHERE actor_id in
	(Select actor_id
		from film_actor
		where film_id =
			(SELECT film_id
				from film
				where title like '%lon%rip'))
ORDER BY actor_id ASC;

/* 7c. You want to run an email marketing campaign in Canada,
for which you will need the names and email addresses of all Canadian customers.
Use joins to retrieve this information.
*/
SELECT concat_ws(' ',first_name,last_name) as Name, email
	FROM customer
	WHERE address_id in
		(SELECT address_id
			FROM address
			WHERE address_id in
				(SELECT city_id
					FROM city
					WHERE country_id = (SELECT country_id
							from country
							where country like '%anad%')));

/*7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
Identify all movies categorized as famiy films.
*/
SELECT film_id, title AS `Family Movies`, description as Description
	FROM film
	WHERE film_id in
		(SELECT film_id
		FROM film_category
		WHERE category_id = (
			SELECT category_id
					from category
					where name like '%amil%'));

-- 7e. Display the most frequently rented movies in descending order.
SELECT title AS Movie, COUNT(inventory.film_id) AS `# of Times Rented`
	FROM film

    RIGHT JOIN
		inventory ON
        film.film_id = inventory.film_id

			RIGHT JOIN
				rental ON
				inventory.inventory_id = rental.inventory_id
GROUP BY Movie
ORDER BY `# of Times Rented` DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT S.store_id, sum(P.amount) AS Revenue
	FROM store as S

		RIGHT JOIN
			customer AS C ON
            S.store_id = C.store_id

			RIGHT JOIN
				payment AS P ON
                C.customer_id = P.customer_id

GROUP BY S.store_id
ORDER BY Revenue DESC;

-- 7g. Write a query to display for each store its store ID, city, and country. store address  city country
SELECT S.store_id, C.city, CO.country
	FROM store AS S

		LEFT JOIN
			address AS A ON
            S.address_id = A.address_id

			LEFT JOIN
				city AS C ON
				A.city_id = C.city_id

				LEFT JOIN
					country AS CO ON
                    C.country_id = CO.country_id;

/*7h. List the top five genres in gross revenue in descending order.
(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
*/
SELECT name AS Genres, sum(payment.amount) as `Gross Revenue`
	FROM category

		LEFT JOIN
			film_category ON
            category.category_id = film_category.category_id

			LEFT JOIN
				film ON
                film_category.film_id = film.film_id

				LEFT JOIN
					inventory ON
                    film.film_id = inventory.film_id

					LEFT JOIN
						rental ON
                        inventory.inventory_id = rental.inventory_id

						LEFT JOIN
							payment ON
                            rental.rental_id = payment.rental_id

GROUP BY Genres
ORDER BY `Gross Revenue` DESC;

/* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue.
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
*/
CREATE VIEW `Top 5 Genres` AS
	(SELECT name, sum(payment.amount) as `Gross Revenue`
		FROM category

		LEFT JOIN
			film_category ON
			category.category_id = film_category.category_id

			LEFT JOIN
				film ON
				film_category.film_id = film.film_id

				LEFT JOIN
					inventory ON
					film.film_id = inventory.film_id

					LEFT JOIN
						rental ON
						inventory.inventory_id = rental.inventory_id

						LEFT JOIN
							payment ON
							rental.rental_id = payment.rental_id

	GROUP BY name
	ORDER BY `Gross Revenue` DESC
	LIMIT 5);

-- 8b. How would you display the view that you created in 8a?
SHOW CREATE VIEW `Top 5 Genres`;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW `Top 5 Genres`;
