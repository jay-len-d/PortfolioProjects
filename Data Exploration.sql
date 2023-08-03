/*
Food Security Data Exploration

Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views

*/

SELECT *
FROM foodsecurity.countries

SELECT *
FROM foodsecurity.countries c
LEFT JOIN world_population wp
ON c.Country = wp.`Country/Territory`


-- This is the data We will be using

SELECT c.`Rank`, c.Country, c.Affordability, c.Availability, c.`Quality/Safety`, c.`Sustainability/Adaptation`, wp.Continent, wp.`2022 Population`
FROM countries c
LEFT JOIN world_population wp
ON c.Country = wp.`Country/Territory`


-- Countries with low/high availability and affordability

SELECT c.Country, c.Availability, c.Affordability, wp.Continent, wp.`2022 Population`
FROM countries c
LEFT JOIN world_population wp
ON c.Country = wp.`Country/Territory`
ORDER BY 2,3 -- low 

SELECT c.Country, c.Availability, c.Availability, wp.Continent, wp.`2022 Population`
FROM countries c
LEFT JOIN world_population wp
ON c.Country = wp.`Country/Territory`
ORDER BY 2,3 DESC -- high


-- Top 10 best and worst food available countries

SELECT c.Country, c.Availability, wp.Continent, wp.`2022 Population`
FROM countries c
LEFT JOIN world_population wp
ON c.Country = wp.`Country/Territory`
ORDER BY 2 DESC
LIMIT 10 -- best

SELECT c.Country, c.Availability, wp.Continent, wp.`2022 Population`
FROM countries c
LEFT JOIN world_population wp
ON c.Country = wp.`Country/Territory`
ORDER BY 2
LIMIT 10; -- worst


-- Top 10 food sustainable countries

SELECT c.Country, c.`Sustainability/Adaptation`
FROM countries c
LEFT JOIN world_population wp
ON c.Country = wp.`Country/Territory`
ORDER BY 2 DESC
LIMIT 10;  -- top 10 best on sustainability

SELECT c.Country, c.`Sustainability/Adaptation`
FROM countries c
LEFT JOIN world_population wp
ON c.Country = wp.`Country/Territory`
ORDER BY 2 ASC
LIMIT 10 ; -- top 10 worst on sustainability


-- The most populated countries in order

SELECT c.Country, wp.`2022 Population`
FROM foodsecurity.countries c
LEFT JOIN world_population wp
ON c.Country = wp.`Country/Territory`
ORDER BY wp.`2022 Population` DESC;


-- Europe vs North America's food availability

SELECT round(SUM(c.Affordability) / COUNT(c.Country), 1) AS average_affordability
FROM foodsecurity.countries c
LEFT JOIN world_population wp ON c.Country = wp.`Country/Territory`
WHERE wp.Continent LIKE 'Europe'

SELECT round(SUM(c.Affordability) / COUNT(c.Country), 1) AS average_affordability
FROM foodsecurity.countries c
LEFT JOIN world_population wp ON c.Country = wp.`Country/Territory`
WHERE wp.Continent LIKE 'North America'


-- Average affordability rate by Continent

SELECT wp.Continent, ROUND(SUM(c.Affordability) / COUNT(c.Country), 1) AS average_affordability
FROM foodsecurity.countries c
LEFT JOIN world_population wp ON c.Country = wp.`Country/Territory`
WHERE wp.Continent IS NOT NULL
GROUP BY wp.Continent;


-- Using CTEs to analyze data by continent

WITH continent_averages AS (
    SELECT wp.Continent,
           ROUND(SUM(c.Affordability) / COUNT(c.Country), 1) AS average_Affordability,
           ROUND(SUM(c.Availability) / COUNT(c.Country), 1) AS average_Availability,
           ROUND(SUM(c.`Quality/Safety`) / COUNT(c.Country), 1) AS `average_Quality_Safety`,
           ROUND(SUM(c.`Sustainability/Adaptation`) / COUNT(c.Country), 1) AS `average_Sustainability_Adaptation`
    FROM foodsecurity.countries c
    LEFT JOIN world_population wp ON c.Country = wp.`Country/Territory`
    WHERE wp.Continent IS NOT NULL
    GROUP BY wp.Continent
)
SELECT Continent,
       average_Affordability,
       average_Availability,
       `average_Quality_Safety`,
       `average_Sustainability_Adaptation`
FROM continent_averages


-- Creating view

CREATE VIEW continent_averages_view AS
SELECT wp.Continent,
       ROUND(SUM(c.Affordability) / COUNT(c.Country), 1) AS average_Affordability,
       ROUND(SUM(c.Availability) / COUNT(c.Country), 1) AS average_Availability,
       ROUND(SUM(c.`Quality/Safety`) / COUNT(c.Country), 1) AS `average_Quality_Safety`,
       ROUND(SUM(c.`Sustainability/Adaptation`) / COUNT(c.Country), 1) AS `average_Sustainability_Adaptation`
FROM foodsecurity.countries c
LEFT JOIN world_population wp ON c.Country = wp.`Country/Territory`
WHERE wp.Continent IS NOT NULL
GROUP BY wp.Continent