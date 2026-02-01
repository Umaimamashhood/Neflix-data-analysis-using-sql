-- 1. Count the number of Movies vs TV Shows
SELECT 
	type,
	COUNT(*) as cnt
FROM netflix
GROUP BY type

-- 2. Find the most common rating for movies and TV shows
select 
type,rating from 
( 
select
type, rating, count(*),
Rank() OVER(PARTITION BY type order by count(*) desc) as ranking
from netflix
group by 1,2 
) as t1
where
ranking =1

-- 3. List all movies released in a specific year (e.g., 2020)
select * from netflix
where type="Movie"
and
release_year =2020

-- 4. Find the top 5 countries with the most content on Netflix
select country,
 count(show_id) as total_content
 from netflix
 group by 1
SELECT
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', n.n), ',', -1)) AS new_country,
    COUNT(show_id) AS total_content
FROM netflix
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
    SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
) n
ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= n.n - 1
GROUP BY new_country
ORDER BY total_content DESC
limit 5

-- 5. Identify the longest movie
select *
 from netflix
 where type='movie'
 and 
 duration = (select max(duration) from netflix)

-- 6. Find content added in the last 5 years
SELECT *
FROM netflix
WHERE YEAR(STR_TO_DATE(data_added, '%M %d, %Y')) >= YEAR(CURDATE()) - 5;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select *
 from netflix
 where type='movie'
 and director like '%Kirsten Johnson%'

-- 8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;

-- 9. Count the number of content items in each genre
SELECT
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', n.n), ',', -1)) AS genre,
    COUNT(*) AS total_content
FROM netflix
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
    SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
) n
ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= n.n - 1
GROUP BY genre
ORDER BY total_content DESC;

-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !
SELECT
    YEAR(STR_TO_DATE(data_added, '%M %d, %Y')) AS release_year,
    COUNT(*) AS avg_content
FROM netflix
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
    SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6
) n
ON CHAR_LENGTH(country) - CHAR_LENGTH(REPLACE(country, ',', '')) >= n.n - 1
WHERE
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', n.n), ',', -1)) = 'India'
    AND data_added IS NOT NULL
GROUP BY YEAR(STR_TO_DATE(data_added, '%M %d, %Y'))
ORDER BY avg_content DESC
LIMIT 5;

-- 11. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries'

-- 12. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(casts, ',', n.n), ',', -1)) AS actor,
    COUNT(*) AS total_movies
FROM netflix
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL
    SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL
    SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL
    SELECT 10
) n
ON CHAR_LENGTH(casts) - CHAR_LENGTH(REPLACE(casts, ',', '')) >= n.n - 1
WHERE
    type = 'Movie'
    AND country LIKE '%India%'
    AND casts IS NOT NULL
GROUP BY actor
ORDER BY total_movies DESC
LIMIT 10;

-- Question 15:Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2


