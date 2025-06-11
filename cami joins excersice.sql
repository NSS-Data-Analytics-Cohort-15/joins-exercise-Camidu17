-- Question 1 Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT specs.film_title AS name,specs.release_year,revenue.worldwide_gross
FROM specs
INNER JOIN revenue
USING(movie_id);


-- Question 2 What year has the highest average imdb rating?

SELECT specs.release_year, AVG(rating.imdb_rating) AS avg_rating
FROM specs
INNER JOIN rating
ON specs.movie_id = rating.movie_id
GROUP BY specs.release_year
ORDER BY avg_rating DESC;

--ANSWER: 1991 with an average imbd rating of 7.45

--What is the highest grossing G-rated movie? Which company distributed it?

SELECT film_title,mpaa_rating, distributors.company_name, revenue.worldwide_gross
FROM specs
INNER JOIN distributors
ON specs.domestic_distributor_id=distributors.distributor_id
INNER JOIN revenue
ON specs.movie_id=revenue.movie_id
WHERE mpaa_rating='G'
ORDER BY revenue.worldwide_gross DESC;

--ANSWER: Toy Story 4, Walt Disney

-- Question 4 Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. 
--Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT company_name, COUNT(specs.film_title)
FROM distributors
LEFT JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY company_name

--QUEASTION 5 Write a query that returns the five distributors with the highest average movie budget.

SELECT distributors.company_name, AVG(revenue.film_budget)
FROM specs
INNER JOIN revenue
ON specs.movie_id=revenue.movie_id
INNER JOIN distributors
ON specs.domestic_distributor_id= distributors.distributor_id
GROUP BY company_name 
ORDER BY AVG(revenue.film_budget)DESC
LIMIT 5;

--ANSWER: Walt Disney, Sony Pictures, Lionsgate, Dreamworks, Warner Bros.

-- Question 6 How many movies in the dataset are distributed by a company which is not headquartered in California? 
-- Which of these movies has the highest imdb rating?

SELECT *, rating.imdb_rating
FROM distributors
INNER JOIN specs
ON specs.domestic_distributor_id = distributors.distributor_id
INNER JOIN rating
ON specs.movie_id = rating.movie_id
WHERE headquarters NOT LIKE '%CA'
ORDER BY rating.imdb_rating DESC;
--ANSWER: 2, dirty dancing

--QUESTION 7  Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
-- FROM Krithika

SELECT 'movies < 2 hours' AS movie_time, AVG(imdb_rating)
FROM specs
JOIN rating
	USING(movie_id)
WHERE  length_in_min <120
--UNION
SELECT 'movies > 2 hours' AS movie_time ,AVG(imdb_rating)
FROM specs
JOIN rating
	USING(movie_id)
WHERE  length_in_min >120
--GROUP BY film_title

--from Jennifer

SELECT
    CASE
        WHEN specs.length_in_min > 120 THEN 'Over 2 Hours'
        WHEN specs.length_in_min <= 120 THEN '2 Hours or Less' -- This includes movies exactly 120 mins. 
    END AS film_length_category, -- This creates a new column called film_length_category that assigns each movie to one of your desired categories based on its length 
    AVG(rating.imdb_rating) AS average_rating
FROM
    specs
JOIN
    rating ON specs.movie_id = rating.movie_id
GROUP BY
    film_length_category -- Grouping all movies belonging to 'Over 2 Hours' into one group and '2 Hours or Less' into another, allowing AVG() to calculate the average for each category.
ORDER BY 1 DESC;

