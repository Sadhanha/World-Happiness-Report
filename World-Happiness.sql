USE mydatabase;


# Query 1: How does happiness scores vary across different regions or continents?  

SELECT region, AVG(happiness_score) AS avg_happiness_score
FROM (SELECT region, happiness_score FROM WHR_2015
      UNION ALL
      SELECT region, happiness_score FROM WHR_2016
      UNION ALL
      SELECT region, happiness_score FROM WHR_2017
      UNION ALL
      SELECT region, happiness_score FROM WHR_2018
      UNION ALL
      SELECT region, happiness_score FROM WHR_2019
      UNION ALL
      SELECT region, happiness_score FROM WHR_2020
      UNION ALL
      SELECT region, happiness_score FROM WHR_2021
      UNION ALL
      SELECT region, happiness_score FROM WHR_2022
      UNION ALL
      SELECT region, happiness_score FROM WHR_2023) AS all_years
GROUP BY region;


# Query 2: What is the average happiness score across all countries? 

SELECT AVG(happiness_score) AS avg_happiness_score_all
FROM (SELECT happiness_score FROM WHR_2015
      UNION ALL
      SELECT happiness_score FROM WHR_2016
      UNION ALL
      SELECT happiness_score FROM WHR_2017
      UNION ALL
      SELECT happiness_score FROM WHR_2018
      UNION ALL
      SELECT happiness_score FROM WHR_2019
      UNION ALL
      SELECT happiness_score FROM WHR_2020
      UNION ALL
      SELECT happiness_score FROM WHR_2021
      UNION ALL
      SELECT happiness_score FROM WHR_2022
      UNION ALL
      SELECT happiness_score FROM WHR_2023) AS all_years;


# Query 3: How have happiness scores changed over different years? 
     
SELECT year, AVG(happiness_score) AS avg_happiness_score
FROM (SELECT 2015 AS year, happiness_score FROM WHR_2015
      UNION ALL
      SELECT 2016, happiness_score FROM WHR_2016
      UNION ALL
	  SELECT 2017, happiness_score FROM WHR_2017
      UNION ALL
	  SELECT 2018, happiness_score FROM WHR_2018
      UNION ALL
	  SELECT 2019, happiness_score FROM WHR_2019
      UNION ALL
	  SELECT 2020, happiness_score FROM WHR_2020
      UNION ALL
	  SELECT 2021, happiness_score FROM WHR_2021
      UNION ALL
	  SELECT 2022, happiness_score FROM WHR_2022
      UNION ALL
	  SELECT 2023, happiness_score FROM WHR_2023) AS all_years
GROUP BY year;


# Query 4: Compare the perception of corruption in European countries to that in Asian countries.

SELECT region, AVG(perceptions_of_corruption) AS avg_corruption_perception
FROM (SELECT region, perceptions_of_corruption FROM WHR_2015
      UNION ALL
      SELECT region, perceptions_of_corruption FROM WHR_2016
      UNION ALL
      SELECT region, perceptions_of_corruption FROM WHR_2017
      UNION ALL
      SELECT region, perceptions_of_corruption FROM WHR_2018
      UNION ALL
      SELECT region, perceptions_of_corruption FROM WHR_2019
      UNION ALL
      SELECT region, perceptions_of_corruption FROM WHR_2020
      UNION ALL
      SELECT region, perceptions_of_corruption FROM WHR_2021
      UNION ALL
      SELECT region, perceptions_of_corruption FROM WHR_2023
	  UNION ALL
      SELECT region, perceptions_of_corruption FROM WHR_2023) AS all_years
WHERE region IN ('Western Europe', 'Southeast Asia', 'East Asia')
GROUP BY region;

# Query 5: Identify the top 5 countries with the most significant decline in generosity over the years.

WITH generosity_diff AS (
    SELECT country,
           MAX(generosity) - MIN(generosity) AS generosity_difference
    FROM (
        SELECT country, generosity FROM WHR_2015
        UNION ALL
        SELECT country, generosity FROM WHR_2016
        UNION ALL
        SELECT country, generosity FROM WHR_2017
        UNION ALL
        SELECT country, generosity FROM WHR_2018
        UNION ALL
        SELECT country, generosity FROM WHR_2019
        UNION ALL
        SELECT country, generosity FROM WHR_2020
        UNION ALL
        SELECT country, generosity FROM WHR_2021
        UNION ALL
        SELECT country, generosity FROM WHR_2022
        UNION ALL
        SELECT country, generosity FROM WHR_2023
    ) AS combined_years
    GROUP BY country
)    
SELECT country, generosity_difference
FROM generosity_diff
ORDER BY generosity_difference DESC
LIMIT 5;


# Query 6: Find the top 3 countries with the most consistent improvement in healthy life expectancy over the years

WITH yearly_rank AS (
    SELECT 
        year, 
        country,
        RANK() OVER (PARTITION BY year ORDER BY healthy_life_expectancy DESC) AS r
    FROM (
        SELECT 2015 AS year, country, healthy_life_expectancy FROM WHR_2015
        UNION ALL
        SELECT 2016, country, healthy_life_expectancy FROM WHR_2016
        UNION ALL
        SELECT 2017, country, healthy_life_expectancy FROM WHR_2017
        UNION ALL
        SELECT 2018, country, healthy_life_expectancy FROM WHR_2018
        UNION ALL
        SELECT 2019, country, healthy_life_expectancy FROM WHR_2019
        UNION ALL
        SELECT 2020, country, healthy_life_expectancy FROM WHR_2020
        UNION ALL
        SELECT 2021, country, healthy_life_expectancy FROM WHR_2021
        UNION ALL
        SELECT 2022, country, healthy_life_expectancy FROM WHR_2022
        UNION ALL
        SELECT 2023, country, healthy_life_expectancy FROM WHR_2023
    ) AS combined_years
),
avg_rank AS (
    SELECT 
        country, 
        AVG(r) AS average_rank
    FROM yearly_rank
    GROUP BY country
)
SELECT 
    country
FROM avg_rank
ORDER BY average_rank
LIMIT 3;



# Query 7: What is the average freedom to make life choices in countries with above-average social support?
SELECT AVG(freedom_to_make_life_choices) AS avg_freedom
FROM (
    SELECT freedom_to_make_life_choices, social_support FROM WHR_2015
    UNION ALL
    SELECT freedom_to_make_life_choices, social_support FROM WHR_2016
    UNION ALL
    SELECT freedom_to_make_life_choices, social_support FROM WHR_2017
    UNION ALL
    SELECT freedom_to_make_life_choices, social_support FROM WHR_2018
    UNION ALL
    SELECT freedom_to_make_life_choices, social_support FROM WHR_2019
    UNION ALL
    SELECT freedom_to_make_life_choices, social_support FROM WHR_2020
    UNION ALL
    SELECT freedom_to_make_life_choices, social_support FROM WHR_2021
    UNION ALL
    SELECT freedom_to_make_life_choices, social_support FROM WHR_2022
) AS all_years
WHERE all_years.social_support > (
    SELECT AVG(social_support) FROM (
        SELECT social_support FROM WHR_2015
        UNION ALL
        SELECT social_support FROM WHR_2016
        UNION ALL
        SELECT social_support FROM WHR_2017
        UNION ALL
        SELECT social_support FROM WHR_2018
        UNION ALL
        SELECT social_support FROM WHR_2019
        UNION ALL
        SELECT social_support FROM WHR_2020
        UNION ALL
        SELECT social_support FROM WHR_2021
        UNION ALL
        SELECT social_support FROM WHR_2022
        UNION ALL
        SELECT social_support FROM WHR_2023
    ) AS global_social_support
);


# Query 8: Countries that have moved above the global average happiness score over the years

WITH global_avg AS (
    SELECT year, AVG(happiness_score) AS avg_happiness_score
    FROM (
        SELECT 2015 AS year, happiness_score FROM WHR_2015
        UNION ALL
        SELECT 2016, happiness_score FROM WHR_2016
        UNION ALL
        SELECT 2017, happiness_score FROM WHR_2017
        UNION ALL
        SELECT 2018, happiness_score FROM WHR_2018
        UNION ALL
        SELECT 2019, happiness_score FROM WHR_2019
        UNION ALL
        SELECT 2020, happiness_score FROM WHR_2020
        UNION ALL
        SELECT 2021, happiness_score FROM WHR_2021
        UNION ALL
        SELECT 2022, happiness_score FROM WHR_2022
        UNION ALL
        SELECT 2023, happiness_score FROM WHR_2023
    ) AS combined_years
    GROUP BY year
)
SELECT a.year, a.country
FROM (
    SELECT 2015 AS year, country, happiness_score FROM WHR_2015
    UNION ALL
    SELECT 2016, country, happiness_score FROM WHR_2016
    UNION ALL
    SELECT 2017, country, happiness_score FROM WHR_2017
    UNION ALL
    SELECT 2018, country, happiness_score FROM WHR_2018
    UNION ALL
    SELECT 2019, country, happiness_score FROM WHR_2019
    UNION ALL
    SELECT 2020, country, happiness_score FROM WHR_2020
    UNION ALL
    SELECT 2021, country, happiness_score FROM WHR_2021
    UNION ALL
    SELECT 2022, country, happiness_score FROM WHR_2022
    UNION ALL
    SELECT 2023, country, happiness_score FROM WHR_2023
) AS a
INNER JOIN global_avg b ON a.year = b.year
WHERE a.happiness_score > b.avg_happiness_score
ORDER BY a.year, a.country;
