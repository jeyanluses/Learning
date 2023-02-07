-- SQL BOLT --



-- LESSON 1: Select Queries 101

-- Find the title of each film
SELECT title 
FROM movies;

-- Find the director of each film
SELECT director 
FROM movies;

-- Find the title and director of each film
SELECT title, director 
FROM movies;

-- Find the title and year of each film
SELECT title, year 
FROM movies;

-- Find all the information about each film
SELECT *
FROM movies;



-- LESSON 2: Queries with constraints (Pt. 1)

-- Find the movie with a row id of 6
SELECT * 
FROM movies
WHERE Id = 6;

-- Find the movies released in the years between 2000 and 2010
SELECT * 
FROM movies
WHERE year BETWEEN 2000 AND 2010;

-- ALTERNATIVE
SELECT * 
FROM movies
WHERE year >= 2000 AND year <= 2010;

-- Find the movies not released in the years between 2000 and 2010
SELECT * 
FROM movies
WHERE year NOT BETWEEN 2000 AND 2010;

-- ALTERNATIVE
SELECT * 
FROM movies
WHERE NOT (year >= 2000 AND year <= 2010);

-- Find the first 5 Pixar movies and their release year
SELECT *
FROM Movies
WHERE Id BETWEEN 1 AND 5;

-- ALTERNATIVE
SELECT * 
FROM movies
ORDER BY year
LIMIT 5;



-- LESSON 3: Queries with constraints (Pt. 2)

-- Find all the Toy Story movies
SELECT * 
FROM movies
WHERE title LIKE "Toy Story%";

-- Find all the movies directed by John Lasseter
SELECT * 
FROM movies
WHERE director LIKE "John Lasseter";

-- Find all the movies (and director) not directed by John Lasseter
SELECT * 
FROM movies
WHERE director NOT LIKE "John Lasseter";

-- Find all the WALL-* movies
SELECT *
FROM movies
WHERE title LIKE 'WALL%';



-- Lesson 4: Filtering and sorting Query results

-- List all directors of Pixar movies (alphabetically), without duplicates
SELECT DISTINCT director 
FROM movies
ORDER BY director;

-- List the last four Pixar movies released (ordered from most recent to least)
SELECT DISTINCT title 
FROM movies
ORDER BY year DESC
LIMIT 4;

-- List the first five Pixar movies sorted alphabetically
SELECT DISTINCT *
FROM movies
ORDER BY title
LIMIT 5;

-- List the next five Pixar movies sorted alphabetically
SELECT DISTINCT *
FROM movies
ORDER BY title
LIMIT 5 OFFSET 5;



-- SQL Review: Simple SELECT Queries

-- List all the Canadian cities and their populations
SELECT * 
FROM north_american_cities
WHERE country = 'Canada';

-- Order all the cities in the United States by their latitude from north to south
SELECT * 
FROM north_american_cities
WHERE country = 'United States'
ORDER BY latitude DESC;

-- List all the cities west of Chicago, ordered from west to east
SELECT * 
FROM north_american_cities
WHERE longitude <- 87.629798
ORDER BY longitude;

-- List the two largest cities in Mexico (by population)
SELECT * 
FROM north_american_cities
WHERE country = 'Mexico'
ORDER BY population DESC
LIMIT 2;

-- List the third and fourth largest cities (by population) in the United States and their population
SELECT * 
FROM north_american_cities
WHERE country = 'United States'
ORDER BY population DESC
LIMIT 2 OFFSET 2;



-- LESSON 6: Multi-table queries with JOINs

-- Find the domestic and international sales for each movie
SELECT * 
FROM movies
JOIN boxoffice
    ON movies.Id = boxoffice.Movie_id;

-- Show the sales numbers for each movie that did better internationally rather than domestically
SELECT * 
FROM movies
JOIN boxoffice AS 
    ON movies.Id = boxoffice.Movie_id
WHERE boxoffice.international_sales > boxoffice.domestic_sales;

-- List all the movies by their ratings in descending order
SELECT * 
FROM movies
JOIN boxoffice
    ON movies.Id = boxoffice.Movie_id
ORDER BY boxoffice.rating DESC;



-- LESSON 7: OUTER JOINs

-- Find the list of all buildings that have employees
SELECT DISTINCT building 
FROM employees
LEFT JOIN buildings
	ON building
WHERE years_employed NOT NULL;

-- Find the list of all buildings and their capacity
SELECT *
FROM buildings;

-- List all buildings and the distinct employee roles in each building (including empty buildings)
SELECT DISTINCT building_name, role 
FROM buildings
LEFT JOIN employees
	ON building_name = building;



-- Lesson 8: A short note on NULLs

-- Find the name and role of all employees who have not been assigned to a building
SELECT employees.name, employees.role 
FROM employees
LEFT JOIN buildings
	ON employees.building = buildings.building_name
WHERE employees.building IS NULL;

-- Find the names of the buildings that hold no employees
SELECT *
FROM buildings
LEFT JOIN employees
	ON employees.building = buildings.building_name
WHERE employees.years_employed IS NULL;



-- LESSON 9: Queries with Expressions

-- List all movies and their combined sales in millions of dollars
SELECT m.Title
			, (b.domestic_sales + b.international_sales)/1000000 AS Total_Sales_Millions
FROM movies AS m
JOIN boxoffice AS b
ON m.Id = b.movie_id;

-- List all movies and their ratings in percent
SELECT m.Title
			, (b.rating)*10 AS Rating_Percent
FROM movies AS m
JOIN boxoffice AS b
ON m.Id = b.movie_id;

-- List all movies that were released on even number years
SELECT m.Title
			, m.year
FROM movies AS m
JOIN boxoffice AS b
	ON m.Id = b.movie_id
WHERE m.year % 2 = 0;



-- LESSON 10: Queries with Aggregates (Pt. 1)

-- Find the longest time that an employee has been at the studio
SELECT MAX(years_employed)
FROM employees;

-- For each role, find the average number of years employed by employees in that role
SELECT role
			, AVG(years_employed)
FROM employees
GROUP BY role;

-- Find the total number of employee years worked in each building
SELECT building
			, SUM(years_employed)
FROM employees
GROUP BY building;


-- LESSON 11: Queries with Aggregates (Pt. 2)

-- Find the number of Artists in the studio (without a HAVING clause)
SELECT COUNT(role) 
FROM employees
WHERE role = 'Artist';

-- Find the number of Employees of each role in the studio
SELECT role, COUNT(role) 
FROM employees
GROUP BY role;

-- Find the total number of years employed by all Engineers
SELECT role, SUM(years_employed) 
FROM employees
GROUP BY role
HAVING role = 'Engineer';



-- LESSON 12: Order of Execution of a Query

-- Find the number of movies each director has directed
SELECT m.director
		    , COUNT(m.title) AS Total_Directed_Movies
FROM movies AS m
LEFT JOIN boxoffice AS b
    ON m.Id = b.movie_id
GROUP BY m.director
ORDER BY Total_Directed_Movies DESC;

-- Find the total domestic and international sales that can be attributed to each director
SELECT m.director
		    , SUM(b.domestic_sales + b.international_sales) AS Total_Sales
FROM movies AS m
LEFT JOIN boxoffice AS b
    ON m.Id = b.movie_id
GROUP BY director
ORDER BY Total_Sales DESC;


-- LESSON 13: Inserting Rows


-- Add the studio's new production, Toy Story 4 to the list of movies (you can use any director)
INSERT INTO movies
(Title, Director)
VALUES ('Toy Story 4', 'John Lasseter');

-- Toy Story 4 has been released to critical acclaim! It had a rating of 8.7, and made 340 million domestically and 270 million internationally. Add the record to the BoxOffice table.
INSERT INTO boxoffice
(movie_id, rating, domestic_sales, international_sales)
VALUES (15, 8.7, 340000000, 270000000);


-- LESSON 14: Updating Rows

-- The director for A Bug's Life is incorrect, it was actually directed by John Lasseter 
UPDATE movies
SET director = 'John Lasseter'
WHERE title = "A Bug's Life";

-- The year that Toy Story 2 was released is incorrect, it was actually released in 1999
UPDATE movies
SET year = '1999'
WHERE title = 'Toy Story 2';

-- Both the title and director for Toy Story 8 is incorrect! The title should be "Toy Story 3" and it was directed by Lee Unkrich
UPDATE movies
SET title = 'Toy Story 3'
    , director = 'Lee Unkrich'
WHERE title = 'Toy Story 8';



-- LESSON 15: Deleting Rows

-- This database is getting too big, lets remove all movies that were released before 2005.
DELETE FROM movies
WHERE year < 2005;

-- Andrew Stanton has also left the studio, so please remove all movies directed by him
DELETE FROM movies
WHERE director = 'Andrew Stanton';



-- LESSON 16: Creating tables
-- Create a new table named Database with the following columns:
--–  Name A string (text) describing the name of the database
--–  Version A number (floating point) of the latest version of this database
--–  Download_count An integer count of the number of times this database was downloaded
-- This table has no constraints.
CREATE TABLE database (
    id INTEGER PRIMARY KEY,
    name TEXT,
    version FLOAT,
    download_count  INTEGER
);



-- LESSON 17: Altering tables

-- Add a column named Aspect_ratio with a FLOAT data type to store the aspect-ratio each movie was released in.
ALTER TABLE movies
ADD column aspect_ratio FLOAT;

-- Add another column named Language with a TEXT data type to store the language that the movie was released in. Ensure that the default for this language is English.
ALTER TABLE movies
ADD column language TEXT
    DEFAULT English;



-- LESSON 18: Dropping tables

-- We've sadly reached the end of our lessons, lets clean up by removing the Movies table
DROP TABLE IF EXISTS movies;

-- And drop the BoxOffice table as wel
DROP TABLE IF EXISTS boxoffice;l