use sakila;
SELECT*FROM actor;

-- 1a. Display the first and last names of all actors from 
-- the table actor.
SELECT first_name,last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a 
-- single column in upper case letters.
--  Name the column Actor Name.

SELECT CONCAT(first_name," ", last_name) AS 'Actor Name'
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor,
-- of whom you know only the first name, "Joe."
-- What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

-- 2b. Find all actors whose last name contain the letters GEN:

SELECT first_name, last_name
FROM actor
WHERE last_name like '%GEN';

-- 2c. Find all actors whose last names contain the letters LI.
-- This time, order the rows by last name and first name,
-- in that order: 

SELECT first_name, last_name 
FROM actor 
WHERE last_name like '%lI'
ORDER BY first_name,Last_name;

-- 2d. Using IN, display the country_id and country columns
-- of the following countries:
-- Afghanistan, Bangladesh, and China:

SELECT * FROM country;

SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a. You want to keep a description of each actor.
-- You don't think you will be performing queries on a 
-- description, so create a column in the table actor named
-- description and use the data type BLOB (Make sure to research 
-- the type BLOB, as the difference between it and VARCHAR are 
-- significant).

ALTER TABLE actor ADD description BLOB;
SELECT * FROM actor;

-- 3b. Very quickly you realize that entering descriptions
-- for each actor is too much effort.
-- Delete the description column.

ALTER TABLE actor DROP COLUMN description;
SELECT * FROM actor;

-- 4a. List the last names of actors,
-- as well as how many actors have that last name.
SELECT last_name
FROM actor;

SELECT last_name,COUNT(*)
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who 
-- have that last name, but only for names that are shared by
-- at least two actors
SELECT last_name,COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;
 
-- 4c. The actor HARPO WILLIAMS was accidentally
-- entered in the actor table as GROUCHO WILLIAMS.
-- Write a query to fix the record.
SET SQL_SAFE_UPDATES=0;
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO";

SELECT first_name, last_name
FROM actor
WHERE first_name = "HARPO" AND last_Name = "WILLIAMS"; 

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO.
--  It turns out that GROUCHO was the correct name after all!
-- In a single query, if the first name of the actor is currently HARPO,
-- change it to GROUCHO.

UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

SELECT first_name, last_name
FROM actor
WHERE first_name = "GROUCHO" AND last_Name = "WILLIAMS";

-- 5a. You cannot locate the schema of the address table.
-- Which query would you use to re-create it?
SELECT * FROM address;


-- 6a. Use JOIN to display the first and last names,
-- as well as the address,
--  of each staff member. Use the tables staff and address:
SELECT * FROM address,staff;
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON s.address_id=a.address_id;

-- 6b. Use JOIN to display the total amount rung up by each 
-- staff member in August of 2005. Use tables staff and payment.

SELECT*FROM staff,payment;
SELECT s.first_name, s.last_name, SUM(p.amount) AS 'Total Sales'
FROM staff s
JOIN payment p
ON s.staff_id= p.staff_id AND p.payment_date BETWEEN "2005-08-01" AND "2005-08-31"
GROUP BY last_name;

-- 6c. List each film and the number of actors who are listed
-- for that film. Use tables film_actor and film. Use inner join.

SELECT * FROM film_actor,film;
SELECT COUNT(fa.actor_id), f.title
FROM film f
JOIN film_actor fa
ON fa.film_id=f.film_id
GROUP BY fa.actor_id;

-- 6d. How many copies of the film Hunchback Impossible
-- exist in the inventory system?

SELECT * FROM inventory,film;
SELECT COUNT(i.film_id), f.title
FROM inventory i
JOIN film f
ON f.film_id=i.film_id AND f.title = "Hunchback Impossible"
GROUP BY i.film_id;

-- 6e. Using the tables payment and customer and the 
-- JOIN command, list the total paid by each customer.
-- List the customers alphabetically by last name:

SELECT * FROM payment, customer;
SELECT  SUM(p.amount) AS 'Total Paid', c.first_name, c.last_name
FROM payment p
JOIN customer c
ON p.customer_id=c.customer_id
GROUP BY c.last_name
ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen
-- an unlikely resurgence. As an unintended consequence,
-- films starting with the letters K and Q have also soared 
-- in popularity. Use subqueries to display the titles of movies
-- starting with the letters K and Q whose language is English.

SELECT * FROM film,language;
SELECT title
FROM film
WHERE language_id IN 
(
SELECT language_id
FROM language
WHERE name = 'English') 
AND title LIKE 'K%'
OR title LIKE 'Q%';

-- 7b. Use subqueries to display all actors who appear in the 
-- film Alone Trip.

SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM film_actor;

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
SELECT actor_id
FROM film_actor
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = "Alone Trip"));

-- 7c. You want to run an email marketing campaign in Canada,
-- for which you will need the names and email addresses of all
-- Canadian customers. Use joins to retrieve this information.

SELECT * FROM country;
SELECT * FROM customer;
SELECT * FROM city;
SELECT * FROM address;

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN
(
SELECT address_id
FROM address
WHERE city_id IN
(
SELECT city_id
FROM city 
WHERE country_id IN
(
SELECT country_id
FROM country
WHERE country = "Canada")));

-- 7d. Sales have been lagging among young families,
-- and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.

SELECT * FROM film_category;
SELECT * FROM category;
SELECT * FROM film;

SELECT title AS 'Family Movies'
FROM film
WHERE film_id IN
(
SELECT film_id
FROM film_category
WHERE category_id IN
(
SELECT category_id
FROM category
WHERE name = "Family"));

-- 7e. Display the most frequently rented movies in descending order.

SELECT title, rental_duration
FROM film
ORDER BY rental_duration DESC;

-- 7f. Write a query to display how much business,
-- in dollars, each store brought in.

SELECT s.store_id, SUM(p.amount) AS 'Total Sales in dollars'
FROM payment p
JOIN store s
ON p.staff_id=s.manager_staff_id 
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, 
-- and country.

SELECT * FROM store;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM address;

SELECT store.store_id AS 'Store ID',
city.city AS 'City',
country.country AS 'Country'
FROM store
JOIN address ON store.address_id=address.address_id
JOIN city ON address.city_id=city.city_id
JOIN country ON city.country_id=country.country_id;

-- 7h. List the top five genres in gross revenue in descending
-- order. (Hint: you may need to use the following tables:
-- category, film_category, inventory, payment, and rental.)
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM payment;
SELECT * FROM rental;

SELECT category.name AS 'Movie Genre',
SUM(payment.amount) AS 'Gross Revenue'
FROM category
JOIN film_category ON category.category_id=film_category.category_id
JOIN inventory ON inventory.film_id=film_category.film_id
JOIN rental ON rental.inventory_id=inventory.inventory_id
JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount)DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have 
-- an easy way of viewing the Top five genres by gross revenue.
-- Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query
-- to create a view.

CREATE VIEW Top_five_genres_by_gross_revenue AS 
SELECT category.name AS 'Movie Genre',
SUM(payment.amount) AS 'Gross Revenue'
FROM category
JOIN film_category ON category.category_id=film_category.category_id
JOIN inventory ON inventory.film_id=film_category.film_id
JOIN rental ON rental.inventory_id=inventory.inventory_id
JOIN payment ON rental.rental_id=payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount)DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM Top_five_genres_by_gross_revenue;

-- 8c. You find that you no longer need the view top_five_genres.
-- Write a query to delete it.

DROP VIEW Top_five_genres_by_gross_revenue;



