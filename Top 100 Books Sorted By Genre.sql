-- gathering groups of the top 100 books of general genre's that each book fits into
-- most all books fit into multiple categories so the total information will amount to more than 100 books
-- the purpose here is to find what genre has the most the top selling books according to this data

-- general genres we are looking at will be: Fantasy, Mystery, Thriller, Horror, Historical, Romance, Science Fiction, Childrens, Fiction, Self Help



-- finding all books sitting in the fantasy genre
select *
from top
WHERE genre ILIKE '%Fantasy%';


-- finding all books sitting in the Mystery genre
select *
from top
WHERE genre ILIKE '%Mystery%';


-- finding all books sitting in the Thriller genre
select *
from top
WHERE genre ILIKE '%Thriller%';


-- finding all books sitting in the Horror genre
select *
from top
WHERE genre ILIKE '%Horror%';


-- finding all books sitting in the Historical genre
select *
from top
WHERE genre ILIKE '%Historical%' or genre ilike '%history%';


-- finding all books sitting in the Romance genre
select *
from top
WHERE genre ILIKE '%Romance%';


-- finding all books sitting in the Science genre
select *
from top
WHERE genre ILIKE '%Science%';


-- finding all books sitting in the Childrens genre
select *
from top
WHERE genre ILIKE '%Children%' or genre ilike '%picture%';


-- finding all books sitting in the Fiction genre
-- non fiction doesn't pull up in this dataset so it isn't created as a category
select *
from top
WHERE genre ILIKE '%Fiction%';


-- finding all books sitting in the Self Help genre
select *
from top
WHERE genre ILIKE '%Self%' or genre ilike '%help%';


-- now we are finding all the OTHER books that aren't fitting into any of the general genre's listed above
select *
from top
WHERE genre NOT ILIKE '%Fantasy%'
  AND genre NOT ILIKE '%Mystery%'
  AND genre NOT ILIKE '%Thriller%'
  AND genre NOT ILIKE '%Horror%'
  AND genre NOT ILIKE '%Historical%'
  AND genre NOT ILIKE '%Romance%'
  AND genre NOT ILIKE '%Science Fiction%'
  AND genre NOT ILIKE '%Science%'
  AND genre NOT ILIKE '%Children%'
  AND genre NOT ILIKE '%Picture%'
  AND genre NOT ILIKE '%Fiction%'
  AND genre NOT ILIKE '%Self%'
  AND genre NOT ILIKE '%Help%';
  
 
 
 -- query to count all fantasy books to make sure the data transfered correctly over to tableau
 select COUNT(*) as book_count
 from top
 WHERE "year of publication" = 2023;
