use sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?

select count(inventory_id) as number_of_copies, film_id from film
join inventory
using (film_id)
where title = 'Hunchback Impossible'
group by film_id;

-- List all films whose length is longer than the average of all the films.

select title, length from film
where length >
(select avg(length)
from film);

-- Use subqueries to display all actors who appear in the film Alone Trip.

select actor_id,first_name,last_name from actor where actor_id in
((select actor_id
from film_actor
where film_id in(
select film_id
from film
where title='ALONE TRIP')));

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.

select title as family_films from film
where film_id in(
select film_id
from film_category
where category_id in(
select category_id
from category
where name='Family'));

-- Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

select email from customer
where address_id in (
	select address_id
	from address
	where city_id in ( 
		select city_id
		from city
		join country c
			on city.country_id = c.country_id
		where c.country = 'Canada'));

-- Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

select T1.first_name, T1.last_name, count(*) as films
from sakila.actor as T1
left join sakila.film_actor as T2 on T1.actor_id = T2.actor_id 
group by first_name, last_name
order by films desc;

-- Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments.

select rental.customer_id, film.title, date_format(rental_date, '%D %M, %Y') as 'Rental Date', amount
from film as film
join inventory using (film_id)
join rental using (inventory_id)
join payment using (rental_id)
where rental.customer_id = (select pay.customer_id
from customer as cust
join payment as pay on cust.customer_id = pay.customer_id
group by pay.customer_id
order by sum(amount) desc limit 1)
order by amount desc;

-- Customers who spent more than the average payments.

select * from customer;
select concat(first_name, ' ', last_name) as 'Customer Name'
from customer as cust
join payment using (customer_id)
group by cust.customer_id
having avg(payment.amount) > (select avg(amount)
from payment);

