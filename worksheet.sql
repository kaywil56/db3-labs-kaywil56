-- 1. List the titles and prices of all books that have the cheapest price.
SELECT TOP 1 WITH TIES title, price 
FROM (
  SELECT title, price 
  FROM titles 
  WHERE price IS NOT NULL
) AS NotNull
GROUP BY price, title 
ORDER BY price ASC;

-- 2. List all titles that have sold more than 40 copies at a single store.
SELECT titles.title 
FROM titles 
JOIN sales 
  ON titles.title_id = sales.title_id 
WHERE sales.qty > 40;

-- 3. List all authors who have not published any books.
SELECT authors.au_id, au_lname, au_fname 
FROM authors 
LEFT JOIN titleauthor 
  ON authors.au_id = titleauthor.au_id 
LEFT JOIN titles 
  ON titleauthor.title_id = titles.title_id 
WHERE titles.title IS NULL;

-- 4. List all the publishers who have published any business books.
SELECT pub_name 
FROM publishers 
JOIN titles 
  ON publishers.pub_id = titles.pub_id 
WHERE titles.type = 'business' 
GROUP BY pub_name;

-- 5. List all authors who have published a “popular computing” book (these
-- books have type = 'popular_comp' in the titles table).
SELECT au_lname, au_fname 
FROM authors 
JOIN titleauthor 
  ON authors.au_id = titleauthor.au_id 
JOIN (
  SELECT * 
  FROM titles 
  WHERE titles.type = 'popular_comp'
) AS PopComp 
  ON titleauthor.title_id = PopComp.title_id;

--  6. List all the cities where both an author (or authors) and a publisher (or
--publishers) are located

SELECT city
FROM authors
WHERE city IN (
  SELECT city
  FROM publishers
)
GROUP BY city

--7. List all cities where an author, but no publisher, is located.
SELECT city
FROM authors
WHERE city NOT IN (
  SELECT city
  FROM publishers
)
GROUP BY city

--8. List all titles that have sold no copies.

SELECT title
FROM titles
LEFT JOIN sales ON titles.title_id = sales.title_id
WHERE sales.title_id IS NULL

--9. List the title and total sales of each book whose total sales is less than the
--average totals sales across all books

select title, sum(qty) from titles
join sales on titles.title_id = sales.title_id
group by title
having sum(qty) < (select avg(SalesNumbers) from (select sum(qty) as SalesNumbers from sales
group by title_id) as SalesAmount)

--10. List the publishers, and the number of books each has published, who are
--not located in California.

select pub_name, count(title) from publishers join
titles on publishers.pub_id = titles.pub_id 
where state != 'CA'
group by pub_name

--11. For each book, list the number of stores where it has been sold.
select title, count(stores.stor_id) from titles join
sales on titles.title_id = sales.title_id
join stores on sales.stor_id = stores.stor_id
group by title

--12. For each book, list its title, the largest quantity of it sold at any one store,
--and the name of that store.

select title, stor_name, max(qty) from titles join
sales on titles.title_id = sales.title_id
join stores on sales.stor_id = stores.stor_id
group by title, stor_name
order by title

--13. Increase by two points the royalty rate for all books that have sold more
--than 30 copies total.

update titles set royalty = royalty + 2
where royalty in
(select royalty from titles join
sales on titles.title_id = sales.title_id
group by title, royalty
having sum(qty) > 30)

--14. List all types of books published by more than one publisher.
select type from titles join
publishers on titles.pub_id = publishers.pub_id
group by type
having count(distinct publishers.pub_id) > 1