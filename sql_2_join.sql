# SQL Join exercise
#
USE world;
#
# 1: Get the cities with a name starting with ping sorted by their population with the least populated cities first
SELECT * FROM city WHERE name LIKE 'ping%' ORDER BY population;
#
# 2: Get the cities with a name starting with ran sorted by their population with the most populated cities first
SELECT * FROM city WHERE name like '%ran' ORDER BY population DESC;
#
# 3: Count all cities
SELECT COUNT(*) FROM city;
#
# 4: Get the average population of all cities
SELECT AVG(population) FROM city;
#
# 5: Get the biggest population found in any of the cities
SELECT MAX(population) FROM city;
#
# 6: Get the smallest population found in any of the cities
SELECT MIN(population) FROM city;
#
# 7: Sum the population of all cities with a population below 10000
SELECT SUM(population) FROM city WHERE population < 10000;
#
# 8: Count the cities with the countrycodes MOZ and VNM
SELECT COUNT(*) FROM city WHERE countrycode IN ('MOZ','VNM');
#
# 9: Get individual count of cities for the countrycodes MOZ and VNM
SELECT COUNT(*) AS nr, countrycode FROM city WHERE countrycode IN ('MOZ','VNM') GROUP BY countrycode;
-- SELECT COUNT(*) FROM city WHERE countrycode = 'MOZ';
-- SELECT COUNT(*) FROM city WHERE countrycode = 'VNM';
#
# 10: Get average population of cities in MOZ and VNM
SELECT AVG(population) FROM city WHERE countrycode IN ('MOZ','VNM');
#
# 11: Get the countrycodes with more than 200 cities
SELECT COUNT(*) AS nr, countrycode FROM city GROUP BY countrycode HAVING nr > 200; 
#
# 12: Get the countrycodes with more than 200 cities ordered by city count
SELECT COUNT(*) AS nr, countrycode FROM city GROUP BY countrycode HAVING nr > 200 ORDER BY nr; 
#
# 13: What language(s) is spoken in the city with a population between 400 and 500 ?
SELECT countrylanguage.language FROM countrylanguage
	JOIN city ON countrylanguage.countrycode = city.countrycode
    WHERE city.population BETWEEN 400 AND 500;
    
-- SELECT * FROM city WHERE city.population BETWEEN 400 AND 500;
-- SELECT * FROM countrylanguage;
#
# 14: What are the name(s) of the cities with a population between 500 and 600 people and the language(s) spoken in them
SELECT city.name, countrylanguage.language FROM city
	LEFT JOIN countrylanguage ON city.countrycode = countrylanguage.countrycode 
    WHERE city.population BETWEEN 500 AND 600;
#
# 15: What names of the cities are in the same country as the city with a population of 122199 (including the that city itself)
SELECT c1.name FROM city c1,city c2 WHERE c1.countrycode=c2.countrycode AND c2.population=122199;

# My original solution, a bit too complex
SELECT city.name FROM city 
	JOIN country ON city.countrycode = country.code
	WHERE country.name = ANY(
		SELECT country.name FROM country 
		JOIN city ON city.countrycode = country.code 
		WHERE city.population = 122199);
#  
# 16: What names of the cities are in the same country as the city with a population of 122199 (excluding the that city itself)
SELECT c1.name FROM city c1,city c2 WHERE c1.countrycode=c2.countrycode AND c2.population=122199 AND NOT c1.population=122199;
# My original solution, a bit too complex
SELECT city.name FROM city 
	JOIN country ON city.countrycode = country.code
    WHERE country.name = ANY(
		SELECT country.name FROM country 
        JOIN city ON city.countrycode = country.code 
        WHERE city.population = 122199)
        AND NOT city.population = 122199;
#
# 17: What are the city names in the country where Luanda is capital?
SELECT c1.name FROM city c1, city c2 WHERE c1.countrycode=c2.countrycode and c2.name = 'Luanda';

# My original solution, a bit too complex
SELECT city.name FROM city 
	JOIN country ON city.countrycode = country.code
    WHERE country.name = ANY(
    SELECT country.name FROM country
    JOIN city ON city.id = country.capital
    WHERE city.name = 'Luanda');
#
# 18: What are the names of the capital cities in countries in the same region as the city named Yaren
# Both of these queries gives the same result.
SELECT c1.name, cr1.capital FROM country cr1 JOIN city c1 ON c1.id = cr1.capital, 
country cr2 JOIN city c2 ON c2.id = cr2.capital
WHERE cr1.region = cr2.region AND c2.name = 'Yaren';

# OR
    
SELECT city.name, country.capital FROM city
	JOIN country ON city.id = country.capital
    WHERE country.region = ANY (
		SELECT country.region FROM country 
		JOIN city on city.countrycode = country.code
		WHERE city.name = 'Yaren');
#
# 19: What unique languages are spoken in the countries in the same region as the city named Riga
# Both of these queries gives the same result.
SELECT DISTINCT cl.language FROM country cr1 JOIN countrylanguage cl ON cr1.code = cl.countrycode,
country cr2 JOIN city c ON cr2.code = c.countrycode
WHERE cr1.region = cr2.region AND c.name = 'Riga';

# OR

SELECT DISTINCT countrylanguage.language FROM countrylanguage
	JOIN country ON countrylanguage.countrycode = country.code
    WHERE country.region = ANY (
    SELECT country.region FROM country 
		JOIN city on city.countrycode = country.code
		WHERE city.name = 'Riga');
#      
# 20: Get the name of the most populous city
#Three different queries that gives the same result
SELECT name FROM city 
ORDER BY population DESC LIMIT 1;
# OR
SELECT name FROM city 
WHERE population in (SELECT MAX(population) FROM city);
# OR 
SELECT name FROM city
	WHERE population = ANY (
		SELECT MAX(population) FROM city);
#