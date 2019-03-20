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
SELECT last_name,COUNT(last_name) FROM actor GROUP BY last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
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
SELECT s.staff_id, SUM(p.amount) FROM staff s INNER JOIN payment p USING (staff_id)  WHERE YEAR(p.payment_date) = 2005 AND MONTH(p.payment_date) = 08 GROUP BY s.staff_id;
-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT f.title AS 'Film Title', SUM(fa.actor_id) AS 'Number of Actors' FROM film f INNER JOIN film_actor fa USING (film_id) GROUP BY f.film_id;
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.title,SUM(film_id) as 'Total Sold' FROM film INNER JOIN inventory USING (film_id) WHERE film.title = 'Hunchback Impossible';
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT c.last_name as 'Customer', SUM(p.amount) as 'Total Paid' FROM payment p INNER JOIN customer c USING (customer_id) GROUP BY c.customer_id ORDER BY c.last_name ASC;
