USE beemovies;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name, table_rows from information_schema.tables where table_schema = 'beemovies';








-- Q2. Which columns in the movie table have null values?
-- Type your code below:
select sum(case when id is null then 1 else 0 end) as id_null,sum(case when title is null then 1 else 0 end) as title_null, sum(case when year is null then 1 else 0 end) as year_null, sum(case when date_published is null then 1 else 0 end) as date_published_null, sum(case when duration is null then 1 else 0 end) as duration_null, sum(case when country is null then 1 else 0 end) as country_null, sum(case when worlwide_gross_income is null then 1 else 0 end) as worlwide_gross_income_null, sum(case when languages is null then 1 else 0 end) as languages_null, sum(case when production_company is null then 1 else 0 end) as production_company_null from movie;








-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select year, count(year) as no_of_movies_produced from movie group by year order by year asc;

select month(date_published) as month_num, count(title) as number_of_movies from movie group by month_num order by month_num asc;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

select sum(count_of_movies) from (select country, count(*) as count_of_movies from movie where year=2019 group by country having country like ('%India%') or country like ('%USA%')) as country_cnts;








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select distinct(genre) from genre;








/* So, Bee Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select genre, count(movie_id) as no_of_movies from genre group by genre;







/* So, based on the insight that you just drew, Bee Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select count(*) as movies_with_1_genre from (select movie_id from genre group by movie_id having count(distinct genre) = 1) as genre_cnt;








/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of Bee Movies’ next project.*/

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

select g.genre, round(avg(m.duration),2) from genre g, movie m where g.movie_id = m.id group by g.genre;







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
-- Type your code below:

select genre, count(movie_id) as movie_count, rank() over (order by movie_count desc) as genre_rank from genre group by genre order by genre_rank;








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select min(avg_rating) as min_avg_rating, max(avg_rating) as max_avg_rating, min(total_votes) as min_total_votes, max(total_votes) as max_total_votes, min(median_rating) as min_median_rating, max(median_rating) as max_median_rating from ratings;




    

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

select m.title, r.avg_rating from movie m, ratings r where m.id = r.movie_id order by avg_rating desc limit 10;






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

select median_rating, count(*) as movie_count from ratings group by median_rating order by median_rating asc;








/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which Bee Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company, count(id) as movie_count, rank() over (order by movie_count desc) prod_company_rank from (select m.production_company, m.id from movie m, ratings r where m.id = r.movie_id and avg_rating > 8) sub group by production_company order by rank desc;





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

select g.genre, count(*) as movie_count from genre g, ratings r, movie m where g.movie_id = r.movie_id and r.movie_id = m.id and r.total_votes > 1000 and m.date_published between '2017-03-01' and '2017-03-31' and m.country like '%USA%' group by g.genre;







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

select m.title, r.avg_rating, r.median_rating,  g.genre from movie m, ratings r, genre g where m.id = r.movie_id and r.movie_id = g.movie_id and  m.title like 'The%' and r.avg_rating > 8;







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select count(*) from movie m, ratings r where m.date_published between '2018-04-01' and '2019-04-01' and r.median_rating = 8 and m.id = r.movie_id;







-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT(SELECT COUNT(*) FROM movie WHERE country = 'Germany') AS german, (SELECT COUNT(*) FROM movie WHERE country = 'Italy') AS italy;





-- Answer is Yes

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

select sum(case when id is null then 1 else 0 end) as id_null, sum(case when name is null then 1 else 0 end) as name_null, sum(case when height is null then 1 else 0 end) as height_null, sum(case when date_of_birth is null then 1 else 0 end) as date_of_birth_null, sum(case when known_for_movies is null then 1 else 0 end) as known_for_movies_null from names;






/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by Bee Movies.*/

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

With top_genres AS (
	Select
	g.genre, count(*) as movie_cnt
	from genre g
	join ratings r
	on g.movie_id = r.movie_id
	where r.avg_rating > 8
	group by g.genre
	order by movie_cnt desc
	limit 3)
SELECT g.genre, n.name as director_name, count(*) as movie_count
	from genre g
	join ratings r on g.movie_id = r.movie_id
	join director_mapping dm on g.movie_id = dm.movie_id
	join names n on dm.name_id = n.id
	where r.avg_rating > 8
	AND g.genre IN (SELECT genre from top_genres)
	GROUP BY g.genre, n.name
	ORDER BY g.genre, movie_count DESC limit 3;




/* James Mangold can be hired as the director for Bee's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
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

select n.name, count(*) as movie_cnt from ratings r join role_mapping rm on r.movie_id = rm.movie_id join names n on n.id = rm.name_id where rm.category = 'actor' and r.median_rating > 8 group by n.name order by movie_cnt desc limit 3;






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
Bee Movies plans to partner with other global production houses. 
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


select m.production_company, sum(r.total_votes) as vote_cnt, rank() over (order by vote_cnt desc) as prod_comp_rank from movie m join ratings r on m.id = r.movie_id group by m.production_company order by prod_comp_rank asc limit 3;







/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since Bee Movies is based out of Mumbai, India also wants to woo its local audience. 
Bee Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
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

WITH actor_movie_ratings AS (
    SELECT
        rm.name_id,
        n.name AS actor_name,
        m.id AS movie_id,
        r.avg_rating,
        r.total_votes
    FROM
        movie m
    JOIN
        ratings r ON m.id = r.movie_id
    JOIN
        role_mapping rm ON m.id = rm.movie_id
    JOIN
        names n ON rm.name_id = n.id
    WHERE
        m.country = 'India'
        AND rm.category = 'actor'
),
actor_movie_counts AS (
    SELECT
        name_id,
        COUNT(*) AS movie_count
    FROM
        actor_movie_ratings
    GROUP BY
        name_id
    HAVING
        COUNT(*) >= 5
)
SELECT
    amr.actor_name,
    SUM(amr.avg_rating * amr.total_votes) / SUM(amr.total_votes) AS weighted_avg_rating,
    SUM(amr.total_votes) AS total_votes,
    amc.movie_count,
    RANK() OVER (ORDER BY SUM(amr.avg_rating * amr.total_votes) / SUM(amr.total_votes) DESC, SUM(amr.total_votes) DESC) AS actor_rank
FROM
    actor_movie_counts amc
JOIN
    actor_movie_ratings amr ON amc.name_id = amr.name_id
GROUP BY
    amr.actor_name, amc.movie_count
ORDER BY
    actor_rank ASC
LIMIT 5;









-- Top actor is Vijay Sethupathi

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

WITH actor_movie_ratings AS (
    SELECT
        rm.name_id,
        n.name AS actor_name,
        m.id AS movie_id,
        r.avg_rating,
        r.total_votes
    FROM
        movie m
    JOIN
        ratings r ON m.id = r.movie_id
    JOIN
        role_mapping rm ON m.id = rm.movie_id
    JOIN
        names n ON rm.name_id = n.id
    WHERE
        m.country = 'India'
        AND rm.category = 'actress'
),
actor_movie_counts AS (
    SELECT
        name_id,
        COUNT(*) AS movie_count
    FROM
        actor_movie_ratings
    GROUP BY
        name_id
    HAVING
        COUNT(*) >= 3
)
SELECT
    amr.actor_name,
    SUM(amr.avg_rating * amr.total_votes) / SUM(amr.total_votes) AS weighted_avg_rating,
    SUM(amr.total_votes) AS total_votes,
    amc.movie_count,
    RANK() OVER (ORDER BY SUM(amr.avg_rating * amr.total_votes) / SUM(amr.total_votes) DESC, SUM(amr.total_votes) DESC) AS actor_rank
FROM
    actor_movie_counts amc
JOIN
    actor_movie_ratings amr ON amc.name_id = amr.name_id
GROUP BY
    amr.actor_name, amc.movie_count
ORDER BY
    actor_rank ASC
LIMIT 5;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


select m.title, g.genre, r.avg_rating, case when r.avg_rating > 8 then 'Superhit' when r.avg_rating between 7 and 8 then 'Hit' when r.avg_rating between 5 and 7 then 'One-time-watch' else 'Flop' end as category from movie m join genre g on m.id = g.movie_id join ratings r on r.movie_id = g.movie_id group by m.title order by r.avg_rating desc;






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
    m.duration,
    SUM(m.duration) OVER (PARTITION BY g.genre ORDER BY m.id) AS running_total_duration,
    round(AVG(m.duration) OVER (PARTITION BY g.genre ORDER BY m.id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM
    movie m
JOIN
    genre g ON m.id = g.movie_id
ORDER BY
    g.genre, m.id;







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

-- Top 3 Genres based on most number of movies

WITH top_genre AS (
    SELECT
        genre
    FROM
        genre
    GROUP BY
        genre
    ORDER BY
        COUNT(*) DESC
    LIMIT 3
),
ranked_movies AS (
    SELECT
        g.genre,
        m.year,
        m.title,
        m.worlwide_gross_income,
        RANK() OVER (PARTITION BY g.genre, m.year ORDER BY m.worlwide_gross_income DESC) AS rank
    FROM
        movie m
    JOIN
        genre g ON m.id = g.movie_id
    WHERE
        g.genre IN (SELECT genre FROM top_genre)
)
SELECT
    genre,
    year,
    title,
    worlwide_gross_income,
    rank
FROM
    ranked_movies
WHERE
    rank <= 5
ORDER BY
    genre,
    year,
    rank;




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

WITH multilingual_movies AS (
    SELECT
        id,
        production_company
    FROM
        movie
    WHERE
        LOCATE(',', languages) > 0
),
hit_movies AS (
    SELECT
        mm.production_company,
        COUNT(*) AS hit_count
    FROM
        multilingual_movies mm
    JOIN
        ratings r ON mm.id = r.movie_id
    WHERE
        r.median_rating >= 8
    GROUP BY
        mm.production_company
),
ranked_production_houses AS (
    SELECT
        production_company,
        hit_count,
        RANK() OVER (ORDER BY hit_count DESC) AS rank
    FROM
        hit_movies
)
SELECT
    production_company,
    hit_count
FROM
    ranked_production_houses
WHERE
    rank <= 2;






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

WITH drama_superhit_movies AS (
    SELECT
        m.id AS movie_id,
        m.title
    FROM
        movie m
    JOIN
        genre g ON m.id = g.movie_id
    JOIN
        ratings r ON m.id = r.movie_id
    WHERE
        g.genre = 'Drama'
        AND r.avg_rating > 8
),
actress_superhits AS (
    SELECT
        rm.name_id,
        n.name AS actress_name,
        COUNT(*) AS superhit_count
    FROM
        drama_superhit_movies dsm
    JOIN
        role_mapping rm ON dsm.movie_id = rm.movie_id
    JOIN
        names n ON rm.name_id = n.id
    WHERE
        rm.category = 'actress'
    GROUP BY
        rm.name_id, n.name
),
ranked_actresses AS (
    SELECT
        actress_name,
        superhit_count,
        RANK() OVER (ORDER BY superhit_count DESC) AS rank
    FROM
        actress_superhits
)
SELECT
    actress_name,
    superhit_count
FROM
    ranked_actresses
WHERE
    rank <= 3;







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


WITH director_movies AS (
    SELECT
        dm.name_id AS director_id,
        n.name AS director_name,
        m.id AS movie_id,
        m.title,
        m.date_published,
        m.duration,
        r.avg_rating,
        r.total_votes
    FROM
        director_mapping dm
    JOIN
        movie m ON dm.movie_id = m.id
    JOIN
        names n ON dm.name_id = n.id
    JOIN
        ratings r ON m.id = r.movie_id
),
director_movie_counts AS (
    SELECT
        director_id,
        director_name,
        COUNT(*) AS num_movies
    FROM
        director_movies
    GROUP BY
        director_id, director_name
    ORDER BY
        num_movies DESC
    LIMIT 9
),
director_stats AS (
    SELECT
        dm.director_id,
        dm.director_name,
        dm.num_movies,
        AVG(DATEDIFF(m2.date_published, m1.date_published)) AS avg_inter_movie_duration_days,
        AVG(r.avg_rating) AS avg_movie_rating,
        SUM(r.total_votes) AS total_votes,
        MIN(r.avg_rating) AS min_rating,
        MAX(r.avg_rating) AS max_rating,
        SUM(m1.duration) AS total_movie_duration
    FROM
        director_movie_counts dm
    JOIN
        director_movies m1 ON dm.director_id = m1.director_id
    JOIN
        director_movies m2 ON dm.director_id = m2.director_id AND m2.date_published > m1.date_published
    JOIN
        ratings r ON m1.movie_id = r.movie_id
    GROUP BY
        dm.director_id, dm.director_name, dm.num_movies
)
SELECT
    director_id,
    director_name,
    num_movies,
    avg_inter_movie_duration_days,
    avg_movie_rating,
    total_votes,
    min_rating,
    max_rating,
    total_movie_duration
FROM
    director_stats
ORDER BY
    num_movies DESC;






