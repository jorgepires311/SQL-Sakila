USE sakila;
-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name AS 'First Name',last_name AS 'Last Name' FROM actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(first_name," ",last_name) as "Actor Name" FROM actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id,first_name,last_name FROM actor WHERE first_name='Joe';
-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id,first_name,last_name FROM actor WHERE last_name LIKE '%Gen%';
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT actor_id,first_name,last_name FROM actor WHERE last_name LIKE '%Li%' ORDER BY last_name,first_name;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id,country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor ADD COLUMN `description` BLOB;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
ALTER TABLE actor DROP COLUMN description;
SELECT * FROM actor;
-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,COUNT(*) FROM actor GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name HAVING COUNT(last_name) > 1;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor SET first_name='HARPO' WHERE last_name='Williams' AND first_name='Harpo';
SELECT * FROM actor WHERE last_name='Williams';
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor SET first_name='GROUCHO' WHERE last_name='Williams' AND first_name='HARPO';
SELECT * FROM actor WHERE last_name='Williams';
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'address';
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT s.first_name, s.last_name,a.address,a.address2 FROM staff s INNER JOIN address a USING (address_id);
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT s.staff_id, SUM(p.amount) AS 'Total Sales' FROM staff s INNER JOIN payment p USING (staff_id)  WHERE YEAR(p.payment_date) = 2005 AND MONTH(p.payment_date) = 08 GROUP BY s.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title AS 'Film Title', SUM(fa.actor_id) AS 'Number of Actors' FROM film f INNER JOIN film_actor fa USING (film_id) GROUP BY f.film_id;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title,SUM(f.film_id) as 'Total Sold' FROM film f INNER JOIN inventory USING (film_id) WHERE f.title = 'Hunchback Impossible';
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.first_name,c.last_name, SUM(p.amount) as 'Total Amount Paid' FROM payment p INNER JOIN customer c USING (customer_id) GROUP BY c.customer_id ORDER BY c.last_name ASC;
-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT f.title FROM film f WHERE (f.title LIKE 'K%' OR f.title LIKE 'Q%') AND (f.language_id IN (
	SELECT language_id FROM language l WHERE l.name = 'English'));
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT a.first_name as 'First Name',a.last_name as 'Last Name' FROM actor a WHERE a.actor_id IN (
	SELECT fa.actor_id FROM film_actor fa WHERE fa.film_id IN(
		SELECT f.film_id FROM film f WHERE title = "Alone Trip"));
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.first_name,c.last_name, c.email FROM customer c  WHERE c.address_id IN(
	SELECT a.address_id FROM address a WHERE a.city_id IN(
		SELECT cy.city_id FROM city cy INNER JOIN country ctry USING (country_id) WHERE ctry.country = 'Canada'));
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title FROM film f WHERE f.film_id IN (
	SELECT fc.film_id FROM film_category fc WHERE fc.category_id IN (
		SELECT c.category_id FROM category c WHERE name ='Family'));
-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title FROM film f WHERE f.film_id IN(
	SELECT i.film_id FROM inventory i WHERE i.inventory_id IN(
		SELECT r.inventory_id FROM rental r GROUP BY r.inventory_id ORDER BY COUNT(r.inventory_id) ASC));
			SELECT r.inventory_id,COUNT(r.inventory_id) FROM rental r GROUP BY r.inventory_id ORDER BY COUNT(r.inventory_id) DESC;
-- 7f. Write a query to display how much business, in dollars, each store brought in.payment
SELECT s.store_id as 'Store',SUM(p.amount) as 'Sales ($)' FROM payment p, staff s WHERE s.staff_id = p.staff_id GROUP BY s.store_id;
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id AS 'Store ID', ct.city AS 'City', c.country AS 'Country' FROM store s,address a,city ct,country c 
	WHERE s.address_id = a.address_id AND a.city_id = ct.city_id AND ct.country_id = c.country_id;
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue' FROM category c 
	JOIN film_category fc USING (category_id )
		JOIN inventory i USING (film_id)
			JOIN rental r USING (inventory_id)
				JOIN payment p USING (rental_id)
					GROUP BY c.name ORDER BY 'Gross Revenue' LIMIT 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS 
	SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross Revenue' FROM category c 
		JOIN film_category fc USING (category_id )
			JOIN inventory i USING (film_id)
				JOIN rental r USING (inventory_id)
					JOIN payment p USING (rental_id)
						GROUP BY c.name ORDER BY 'Gross Revenue' LIMIT 5;
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;