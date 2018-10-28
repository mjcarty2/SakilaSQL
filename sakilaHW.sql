-- use sakila database
use sakila;

-- 1a) Show first and last names
select first_name,
		last_name
from actor;

-- 1b) Show first and last name in uppercase letters in a new column
select concat(upper(first_name), " ", upper(last_name)) 
as actor_name from actor;

-- 2a) Display ID, first, and last name with "Joe"
select actor_id, first_name, last_name from actor
where first_name = "Joe";

-- 2b) Find all actors whose last name contains GEN
select * from actor
where last_name like '%GEN%';

-- 2c) Find all actors whose last name contains LO. Order rows by last name and first name
select * from actor
where last_name like '%LI%'
order by last_name, first_name;

-- 2d) Use IN to display the country id and country columns of Afghanistan, Bangladesh, and China
select * from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a) Add a column in actor named description and use data type BLOB
alter table actor
add column description blob;

-- 3b) Delete the description column
alter table actor drop description;

-- 4a) List the last names of actors and how many have that last name
select last_name, count(last_name) as number_of_actors
from actor
group by last_name;

-- 4b) List same as above, but only shared by at least two actors
select last_name, count(last_name) as number_of_actors
from actor
group by last_name
having count(last_name) >= 2;

-- 4c) Use a query to fix Groucho Williams to Harpo Williams
update actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d) Use a query to change Harpo back to Groucho
update actor
set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'WILLIAMS';

-- 5a) Use a query to re-create the address table
show columns from address;
show create table address;

-- 6a) Use JOIN to display first, last names, and addresses of staff members. Use table staff and address
select first_name, last_name, address from staff s
inner join address a on s.address_id = a.address_id;

-- 6b) Use JOIN to display the total amount rung up by each staff member in Aug 2005
select s.staff_id, first_name, last_name, sum(amount) as 'total_amount'
from staff s
inner join payment p 
on s.staff_id = p.staff_id
group by s.staff_id;

-- 6c) List each film and the number of actors listed for that film
select f.title, count(fa.actor_id) as 'number_of_actors'
from film f
left join film_actor fa
on f.film_id = fa.film_id
group by f.film_id;

-- 6d) How many copis of Hunchback Impossible exist
select f.title, count(i.inventory_id) as 'inventory'
from film f
inner join inventory i
on f.film_id = i.film_id
group by f.film_id
having title = "Hunchback Impossible";

-- 6e) List the total paid by each customer using JOIN and tables payment and customer. List alphabetically by last name
select c.last_name, c.first_name, sum(p.amount) as 'total_paid'
from customer c
inner join payment p
on c.customer_id = p.customer_id
group by p.customer_id
order by last_name, first_name;

-- 7a) Use subqueries to display the titles of movies starting with K and Q whose language is in English
select title from film
where language_id in
	(select language_id from language
	where name = "English")
and (title like "K%") or (title like "Q%");

-- 7b) Use subqueries to display all actors who appear in the film Alone Trip
select first_name, last_name from actor
where actor_id in
	(select actor_id from film_actor
	where film_id in
		(select film_id from film
		where title = "Alone Trip"));

-- 7c) Use JOIN to retrieve names and email addresses of Canadian cutomers
select c.first_name, c.last_name, c.email, co.country from customer c
left join address a
on c.address_id = a.address_id
left join city ci
on ci.city_id = a.city_id
left join country co
on co.country_id = ci.country_id
where country = "Canada";

-- 7d) Identify all movies categorized as family films
select * from film
where film_id in
	(select film_id from film_category
	where category_id in
		(select category_id from category
		where name = "Family"));

-- 7e) Display the most frequently rented movies in descending order
select f.title , count(r.rental_id) as 'number_of_rentals' from film f
right join inventory i
on f.film_id = i.film_id
join rental r 
on r.inventory_id = i.inventory_id
group by f.title
order by count(r.rental_id) desc;

-- 7f) Write a query to display how much business eash store brought in
select s.store_id, sum(amount) as 'revenue' from store s
right join staff st
on s.store_id = st.store_id
left join payment p
on st.staff_id = p.staff_id
group by s.store_id;

-- 7g) Write a query to display each store's ID, city, and country
select s.store_id, ci.city, co.country from store s
join address a
on s.address_id = a.address_id
join city ci
on a.city_id = ci.city_id
join country co
on ci.country_id = co.country_id;

-- 7h) List the top five genres in gross revenue in descending order
select c.name, sum(p.amount) as 'revenue_per_category' from category c
join film_category fc
on c.category_id = fc.category_id
join inventory i
on fc.film_id = i.film_id
join rental r
on r.inventory_id = i.inventory_id
join payment p
on p.rental_id = r.rental_id
group by name
order by sum(p.amount) desc;

-- 8a) Use solution above to create a ciew of the top five genres
create view top_5_by_genre as
select c.name, sum(p.amount) as 'revenue_per_category' from category c
join film_category fc
on c.category_id = fc.category_id
join inventory i
on fc.film_id = i.film_id
join rental r
on r.inventory_id = i.inventory_id
join payment p
on p.rental_id = r.rental_id
group by name
order by sum(p.amount) desc
limit 5;

-- 8b) Display the view created above
select * from top_5_by_genre;

-- 8c) Delete query for view
drop view top_5_by_genre;

-- DONE!