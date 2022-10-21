--Tools → Options → Query Results a vyberte default destination for results "results to text".

SELECT * FROM netflix WHERE country = 'South Korea' AND release_year = 2015 ORDER BY show_id;

SELECT * FROM netflix WHERE release_year < 2015 AND (country = 'SPAIN' OR country = 'norway') AND type = 'movie' ORDER BY show_id ASC;
SELECT * FROM netflix WHERE type = 'TV show' AND cast IS NULL AND director IS NOT NULL AND date_added < '2020-05-01' ORDER BY release_year, show_id;

SELECT * FROM netflix WHERE cast LIKE '%Brad Pitt%' ORDER BY country, date_added;

SELECT * FROM netflix WHERE show_id IN (15,22,900,30,44,1800,45,66,2700,60,88,3600,75,110,4500) order by show_id;
SELECT * FROM netflix WHERE release_year = 1982 order by show_id;


SELECT * FROM netflix WHERE message is not null;
