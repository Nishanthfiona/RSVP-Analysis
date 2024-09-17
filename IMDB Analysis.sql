USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) as 'Total Rows' FROM DIRECTOR_MAPPING ;
SELECT COUNT(*) as 'Total Rows' FROM GENRE ;
SELECT COUNT(*) as 'Total Rows' FROM  MOVIE;
SELECT COUNT(*) as 'Total Rows' FROM  NAMES;
SELECT COUNT(*) as 'Total Rows' FROM  RATINGS;
SELECT COUNT(*) as 'Total Rows' FROM  ROLE_MAPPING;

/*
Summary Q1: 
- Director_Mapping Table has 3867 rows.
- Genre Table has 14662 rows.
- Movie Table has 7997 rows.
- Names Table has 25735 rows.
- Ratings Table has 7997 rows.
- Role_Mapping has 15615 rows.
*/



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS ID_NULL_COUNT,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_NULL_COUNT,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_NULL_COUNT,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_NULL_COUNT,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_NULL_COUNT,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_NULL_COUNT,
       Sum(CASE
             WHEN worldwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_NULL_COUNT,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_NULL_COUNT,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_NULL_COUNT
FROM   movie;

/*
Summary Q2: 
- Country, worlwide_gross_income, languages and production_company columns have NULL values
*/



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each year
SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;

-- Number of movies released each month 
SELECT Month(date_published) AS MONTH_NUM,
       Count(*)              AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

/*
Summary Q3: 
- Highest Releases: March had the highest number of movie releases.
- Lowest Releases: December had the lowest number of releases.
Seasonal Trends:
- January, March, September, and October tend to have higher movie releases, with over 800 movies released in each of these months across the three years.
- July and December are the months with the least number of releases, with less than 500 movies combined in these months over three years.
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
  
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT
    COUNT(id) AS Total_Movies,
    year
FROM
 movie
WHERE
 (country LIKE "%USA%" OR 
     country LIKE "%India%")
    AND year = 2019
GROUP BY year;

/*
Summary Q4: 
- India and USA produced exactly 1059 movies in 2019
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/



-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 
 DISTINCT genre
FROM
 genre
ORDER BY genre ASC;

/*
Summary Q5: 
Action
Adventure
Comedy
Crime
Drama
Family
Fantasy
Horror
Mystery
Others
Romance
Sci-Fi
Thriller
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */



-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    COUNT(movie_id) AS movie_count, genre
FROM
    genre
GROUP BY genre
ORDER BY movie_count DESC
LIMIT 1;

/*
Summary Q6:
- The Drama genre has the highest number of movies produced, with a total count of 4285.
*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/



-- Q7. How many movies belong to only one genre?
-- Type your code below

WITH one_genre_movies AS(
   SELECT 
    movie_id
   FROM
    genre
   GROUP BY
    movie_id
   HAVING
    COUNT(genre)=1)
SELECT 
 COUNT(movie_id) as movie_with_one_genre
FROM
 one_genre_movies;

/*
Summary Q7:
- There are 3,289 movies that are associated with only one genre.
*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/



-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
  genre, 
  ROUND(
    AVG(duration)
  ) AS avg_duration 
FROM 
  genre g 
  INNER JOIN movie m ON g.movie_id = m.id 
GROUP BY 
  genre 
ORDER BY 
  avg_duration DESC;

/*
Summary Q8:
- The Action genre has the highest average duration at 113 minutes, while the Horror genre has the shortest average duration at 92.72 minutes.
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/



-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below

WITH genre_rank_table AS(
   SELECT 
    genre,
    COUNT(movie_id) AS movie_count, 
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) as genre_rank
   FROM
    genre
   GROUP BY genre)
SELECT *
FROM 
 genre_rank_table
WHERE 
 genre = "Thriller";

/*
Summary Q9: 
- The genre 'Thriller' ranks 3rd based on the total number of movies produced.
*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table
*/



-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
 MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM
 ratings;
 
 /*
Summary Q10: 
- The minimum and maximum values in each column fall within the expected range, varying from zero to a maximum of 10 or 100, depending on the column.
*/ 

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/



-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT
    m.title,
    r.avg_rating,
    RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM
    movie AS m
JOIN
    ratings AS r
ON 
 m.id = r.movie_id
ORDER BY
 movie_rank
LIMIT 10;

 /*
Summary Q11: 
- Top 10 Movies based on Average Rating
Kirket
Love in Kilnerry
Gini Helida Kathe
Runam
Fan
Android Kunjappan Version 5.25
Yeh Suhaagraat Impossible
Safe
The Brighton Miracle
Shibu
*/ 

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/



-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT
 median_rating,
 COUNT(movie_id) AS movie_count
FROM
 ratings
GROUP BY
 median_rating
ORDER BY
 movie_count DESC;

 /*
Summary Q12: 
Majority of Films: 7 is the most common median rating, with 2,257 movies.
Above-Average Ratings: 6 and 8 are also frequent, with 1,975 and 1,030 movies, respectively.
High Ratings: Few movies achieve top ratings, with 429 rated 9 and 346 rated 10.
Lower Ratings: Decreasing trend in ratings below 5, with 985 movies rated 5.
Insight: Most movies cluster around ratings of 6 and 7, with fewer films standing out as either exceptionally good or bad.
*/ 

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/



-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_company_ranks as
(
SELECT
    m.production_company,
    COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM
    movie AS m
JOIN
    ratings AS r
ON 
 m.id = r.movie_id
WHERE 
 r.avg_rating > 8 and m.production_company is not NULL
GROUP BY
 m.production_company
)
SELECT 
 production_company, movie_count, prod_company_rank
FROM   
 prod_company_ranks
WHERE  
 prod_company_rank = 1; 

 /*
Summary Q13: 
- Dream Warrior Pictures and National Theatre Live each produced the highest number of hit movies (average rating > 8).
- Both production houses hold the top rank with a movie count of 3 each.
- These production houses consistently deliver high-quality films that resonate well with audiences.
*/ 

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both



-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
    g.genre,
    COUNT(m.id) AS movie_count
FROM
    movie AS m
INNER JOIN
    ratings AS r
ON 
 m.id = r.movie_id
INNER JOIN 
 genre AS g
ON
 m.id = g.movie_id
WHERE 
 r.total_votes > 1000
    AND g.genre IS NOT NULL
    AND YEAR(date_published) = 2017
    AND country LIKE '%USA%'
    AND MONTH(date_published) = 3
GROUP BY
 g.genre
ORDER BY 
 movie_count DESC;

 /*
Summary Q14: 
- In March 2017, 24 Drama movies were released in the USA with more than 1,000 votes, leading the count.
- Drama, Comedy, and Action were the top 3 genres in March 2017 in the USA, all receiving more than 1,000 votes.
*/ 



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
    m.title,
    r.avg_rating,
    g.genre
FROM
    movie AS m
  INNER JOIN
 ratings AS r ON m.id = r.movie_id
  INNER JOIN 
 genre AS g ON m.id = g.movie_id
WHERE 
 m.title LIKE "THE%"
 AND r.avg_rating > 8
ORDER BY
 avg_rating DESC;

/*
Summary Q15: 
- Drama genre dominates with several high-rated films, such as The Brighton Miracle (9.5), The Colour of Darkness (9.1), and The Irishman (8.7).
- The Blue Elephant 2 stands out by excelling in multiple genres—Drama (8.8), Horror (8.8), and Mystery (8.8).
- The Irishman (8.7) and The Gambinos (8.4) are top-rated in both the Drama and Crime genres.
- Theeran Adhigaaram Ondru is highly rated in Action, Crime, and Thriller genres, with a rating of 8.3.
- The King and I is noted for its strong ratings in both Drama and Romance (8.2).
*/ 



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT
    r.median_rating,
    COUNT(m.id) AS movie_count
FROM
    movie AS m
INNER JOIN
    ratings AS r
ON 
 m.id = r.movie_id
WHERE 
 r.median_rating = 8
    AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY
 r.median_rating;

/*
Summary Q16: 
- A significant number of movies, 361 to be precise, released between 1 April 2018 and 1 April 2019 received a median rating of 8. 
This indicates a strong consistency in quality during this period.
*/ 



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
 "Italian" as language,
 Sum(total_votes) AS total_vote_count
FROM
 movie AS m
INNER JOIN 
 ratings AS r
ON 
 r.movie_id = m.id
WHERE 
 languages LIKE '%Italian%'

UNION

SELECT 
 "German" as language,
    Sum(total_votes) AS total_vote_count
FROM
 movie AS m
INNER JOIN 
 ratings AS r
ON r.movie_id = m.id
WHERE
 languages LIKE '%German%'
ORDER BY total_vote_count DESC; 

/*
Summary Q17: 
Yes, German movies get more votes than Italian movies.
*/ 

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/



-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
 COUNT(CASE WHEN names.name IS NULL THEN 1 END) AS name_nulls,
 COUNT(CASE WHEN names.height IS NULL THEN 1 END) AS height_nulls,
 COUNT(CASE WHEN names.date_of_birth IS NULL THEN 1 END) AS date_of_birth_nulls,
 COUNT(CASE WHEN names.known_for_movies IS NULL THEN 1 END) AS known_for_movies_nulls
FROM
 names;

/*
Summary: 
- The columns in the names table with null values are Height, Date of Birth, and Know of movies.
*/ 

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/



-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS
(
           SELECT     genre,
                      Count(m.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre G
using     (movie_id)
INNER JOIN names AS n
ON         n.id = d.name_id
INNER JOIN top_3_genres
using     (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

/*
Summary Q19: 
The top three directors in the top three genres whose movies have an average rating > 8 are:
James Mangold
Anthony Russo
Soubin Shahir
*/ 

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/



-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT N.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS RM
       INNER JOIN movie AS M
               ON M.id = RM.movie_id
       INNER JOIN ratings AS R USING(movie_id)
       INNER JOIN names AS N
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 

/*
Summary Q20: 
- Top 2 actors are Mammootty and Mohanlal.
*/ 

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/



-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH ranking AS(
SELECT production_company, sum(total_votes) AS vote_count,
	RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
	INNER JOIN ratings AS r ON r.movie_id=m.id
GROUP BY production_company)
SELECT production_company, vote_count, prod_comp_rank
FROM ranking
WHERE prod_comp_rank<4;

/*
Summary Q21: 
The top three production houses based on the number of votes received by their movies are:
Marvel Studios
Twentieth Century Fox
Warner Bros.
*/ 

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/



-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_ranking AS (
   SELECT
    n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(r.avg_rating*r.total_votes)/SUM(total_votes),2) AS actor_avg_rating
   FROM
    movie m 
    INNER JOIN
    ratings r 
    ON m.id = r.movie_id
    INNER JOIN
    role_mapping rm
    ON m.id = rm.movie_id
    INNER JOIN
    names n 
    ON n.id = rm.name_id
   WHERE
    rm.category = "actor" AND
    m.country = "India"
   GROUP BY
    actor_name
   HAVING
    movie_count >=5)
SELECT *,
  RANK() OVER(ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM
 actor_ranking;

/*
Summary Q22: 
- The actor at the top of the list based on average ratings for movies released in India is Vijay Sethupathi, with an average rating of 8.42.
*/ 



-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_ranking AS (
   SELECT
    n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(r.avg_rating*r.total_votes)/SUM(total_votes),2) AS actress_avg_rating
   FROM
    movie m 
    INNER JOIN
    ratings r 
    ON m.id = r.movie_id
    INNER JOIN
    role_mapping rm
    ON m.id = rm.movie_id
    INNER JOIN
    names n 
    ON n.id = rm.name_id
   WHERE
    rm.category = "actress" AND
    m.country = "India" AND
    m.languages LIKE "%Hindi%"
   GROUP BY
    actress_name
   HAVING
    movie_count >=3)
SELECT *,
  RANK()OVER(ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM
 actress_ranking
LIMIT 5;

/*
Summary Q23: 
The top five actresses in Hindi movies released in India based on their average ratings are:
Taapsee Pannu (7.74)
Kriti Sanon (7.05)
Divya Dutta (6.88)
Shraddha Kapoor (6.63)
Kriti Kharbanda (4.80)
*/ 

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/



/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movie_list AS(
    SELECT
     m.title,
     r.avg_rating
    FROM 
     ratings r 
     INNER JOIN
     movie m
     ON r.movie_id = m.id
     INNER JOIN
     genre g
     ON m.id = g.movie_id
    WHERE
     g.genre = "Thriller")
SELECT *,
 CASE
  WHEN avg_rating > 8 THEN "Superhit movies"
        WHEN avg_rating BETWEEN 7 AND 8 THEN "Hit movies"
        WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch movies"
        ELSE "Flop movies"
 END AS movie_category
FROM
 thriller_movie_list;
 
/*
Summary Q24: 
- New Category Created
*/ 

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
 g.genre,
 ROUND(AVG(m.duration),2) AS avg_duration,
 SUM(ROUND(AVG(m.duration),2)) OVER W1 AS running_total_duration,
 AVG(ROUND(AVG(m.duration),2)) OVER W2 AS moving_avg_duration
FROM
 movie m 
    INNER JOIN
 genre g 
 ON m.id = g.movie_id
GROUP BY
 g.genre
WINDOW W1 AS (ORDER BY genre ROWS UNBOUNDED PRECEDING),
 W2 AS (ORDER BY genre ROWS 10 PRECEDING)
ORDER BY
 g.genre;


/*
Summary Q25: 
Here is the genre-wise running total and moving average of the average movie duration:

Action: Running Total = 112.88, Moving Average = 112.88
Adventure: Running Total = 214.75, Moving Average = 107.38
Comedy: Running Total = 317.37, Moving Average = 105.79
Crime: Running Total = 424.42, Moving Average = 106.11
Drama: Running Total = 531.19, Moving Average = 106.24
Family: Running Total = 632.16, Moving Average = 105.36
Fantasy: Running Total = 737.30, Moving Average = 105.33
Horror: Running Total = 830.02, Moving Average = 103.75
Mystery: Running Total = 931.82, Moving Average = 103.54
Others: Running Total = 1031.98, Moving Average = 103.20
Romance: Running Total = 1141.51, Moving Average = 103.77
Sci-Fi: Running Total = 1239.45, Moving Average = 102.42
Thriller: Running Total = 1341.03, Moving Average = 102.39
*/ 


-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH top3genre AS (
    SELECT genre
    FROM genre
    GROUP BY genre
    ORDER BY COUNT(movie_id) DESC
    LIMIT 3
), currency_converted AS (
    SELECT
        id,
        CASE
            WHEN worldwide_gross_income LIKE 'INR%' 
                THEN Cast(Replace(worldwide_gross_income, 'INR', '') AS DECIMAL(12)) / 75
            WHEN worldwide_gross_income LIKE '$%' 
                THEN Cast(Replace(worldwide_gross_income, '$', '') AS DECIMAL(12))
            ELSE Cast(worldwide_gross_income AS DECIMAL(12))
        END AS worldwide_gross_income
    FROM 
        movie
), ranked_movies AS (
    SELECT 
        genre,
        year,
        title AS movie_name,
        CONCAT('$', ROUND(cc.worldwide_gross_income, 0)) AS 'worldwide_gross_income ($)',
        DENSE_RANK() OVER(PARTITION BY year ORDER BY cc.worldwide_gross_income DESC) movie_rank
    FROM
        movie m
        INNER JOIN genre g ON m.id = g.movie_id
        INNER JOIN currency_converted cc ON cc.id = m.id
    WHERE genre IN (SELECT * FROM top3genre)
)
SELECT * FROM ranked_movies
WHERE movie_rank <= 5;

/*
Summary Q26: 
For the year 2017, the five highest-grossing movies belonging to the top three genres (Thriller, Comedy, Drama) are:
Thriller: The Fate of the Furious - $1,236,005,118
Comedy: Despicable Me 3 - $1,034,799,409
Comedy: Jumanji: Welcome to the Jungle - $962,102,237
Drama: Zhan lang II - $870,325,439
Thriller: Zhan lang II - $870,325,439
*/ 



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_comp_summary AS (
    SELECT 
     m.production_company,
     COUNT(m.id) AS movie_count
    FROM
     movie m 
     INNER JOIN
     ratings r 
     ON m.id = r.movie_id
    WHERE 
     r.median_rating >=8 AND
     POSITION(',' IN m.languages)>0 AND
     m.production_company IS NOT NULL
    GROUP BY
     m.production_company)
SELECT *,
 RANK()OVER(ORDER BY movie_count DESC) AS prod_comp_rank
FROM 
 prod_comp_summary
LIMIT 2;


/*
Summary Q27: 
The top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies are:
Star Cinema
Twentieth Century Fox
*/ 

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language



-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_ranking AS
(
SELECT 
	name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(total_votes * avg_rating)/SUM(total_votes), 2) AS actress_avg_rating,
	ROW_NUMBER() OVER(ORDER BY COUNT(r.movie_id) DESC) AS actress_rank 
FROM
	names n
		INNER JOIN
	role_mapping rm ON n.id = rm.name_id
		INNER JOIN
	genre g ON g.movie_id = rm.movie_id
		INNER JOIN
	ratings r ON r.movie_id = rm.movie_id
WHERE avg_rating > 8 AND genre = 'Drama' AND category = 'actress'
GROUP BY name 
)
SELECT *
FROM actress_ranking
WHERE actress_rank <=3 ;

/*
Summary: 
The top three actresses based on the number of Super Hit movies (average rating >8) in the drama genre are:
Parvathy Thiruvothu
Susan Brown
Amanda Lawrence
*/ 



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH director_info AS
(
SELECT
	dm.name_id AS director_id,
    name AS director_name,
    dm.movie_id AS movie_id,
    date_published,
    LEAD(date_published, 1) OVER(PARTITION BY dm.name_id ORDER BY date_published) AS next_date_published,
    total_votes,
    avg_rating,
    duration
FROM
	names n
		INNER JOIN
	director_mapping dm ON dm.name_id = n.id
		INNER JOIN 
	movie m ON m.id = dm.movie_id
		INNER JOIN
	ratings r ON r.movie_id = m.id
), top_directors AS
(
SELECT 
	director_id,
    director_name,
	COUNT(movie_id) number_of_movies,
	ROUND(AVG(datediff(next_date_published, date_published)), 2) as avg_inter_movie_days,
    ROUND(SUM(avg_rating * total_votes)/ SUM(total_votes), 2) AS avg_rating,
    SUM(total_votes)AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration,
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) as movie_rank
FROM
	director_info
GROUP BY director_id 
)
SELECT director_id,
       director_name,
       number_of_movies,
       avg_inter_movie_days,
       avg_rating,
       total_votes,
       min_rating,
       max_rating,
       total_duration
FROM   top_directors
WHERE  movie_rank <= 9;

/*
Summary: 
 Based on movies directed these are the top 9 directores: 
- 	A.L. Vijay
- 	Andrew Jones
- 	Steven Soderbergh
- 	Jesse V. Johnson
- 	Sam Liu
- 	Sion Sono
- 	Chris Stokes
- 	Justin Price
- 	Özgür Bakar
*/ 


-- END --

