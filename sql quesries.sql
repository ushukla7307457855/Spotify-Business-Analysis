DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify(
Artist VARCHAR(255),
Track  VARCHAR(255),
Album VARCHAR(255),
Album_type	VARCHAR(50),
Danceability FLOAT,
Energy FLOAT,
Loudness FLOAT,
Speechiness FLOAT,
Acousticness FLOAT,
Instrumentalness FLOAT,
Liveness FLOAT,
Valence FLOAT,
Tempo FLOAT,
Duration_min FLOAT,
Title VARCHAR(255),
Channel	 VARCHAR(255),
Views FLOAT,
Likes BIGINT,
Comments BIGINT,
Licensed BOOLEAN,
official_video BOOLEAN,
Stream BIGINT,
EnergyLiveness FLOAT,
most_playedon VARCHAR(50)
);

---EDA 

 
SELECT COUNT(*)
FROM 
spotify;

SELECT COUNT(DISTINCT album)
FROM 
spotify

SELECT album_type
FROM 
spotify;

SELECT MAX(duration_min)
FROM 
spotify;
--to find & deal with the column having  0 duration
SELECT * FROM spotify
WHERE duration_min =0

 DELETE FROM spotify 
 WHERE duration_min =0

SELECT DISTINCT liveness FROM spotify



--DATA ANALYSIS BUSINESS PROBLEMS 

--Q1 Retrieve all the names of all tracks that have more than 1 billion streams

SELECT * FROM spotify 
WHERE Stream>=1000000000

--Q2 List of all the albums aling with their respective artists.
SELECT DISTINCT Album,Artist FROM spotify
ORDER BY 1

--Q3 GET the total  number of comments for tracks where licensed =TRUE
SELECT COUNT(Comments) FROM spotify
WHERE licensed =TRUE

--Q4 Find all tracks that belong to the album type single 
SELECT *
FROM spotify
WHERE Album_type='single'

--Q5 COUNT the total number of tracks by each artist
SELECT COUNT(Track) as cnt_of_tracks,Artist  FROM spotify
GROUP BY 2
ORDER BY 2 

--medium level questions 
--Q6 Calculate the avg danceability of tracks in each album

SELECT 
AVG(danceability) as avg_dance,Album
FROM spotify
GROUP BY 2
ORDER BY 1 DESC

--Q7 FIND the top 5 tracks with the highest energy values

SELECT 
Track,MAX(energy)
FROM spotify
ORDER BY energy
LIMIT 5

--Q8 List all tracks along with their views and likes offical_video=TRUE 
SELECT 
Track,
SUM(Views) AS total_views,
SUM(Likes) as total_likes
FROM SPOTIFY
WHERE officIal_video=TRUE
GROUP BY 1

--Q9 For each album calculate the total views of all aassociated tracks
SELECT Album,
track,
SUM(Views) 

FROM spotify
GROUP BY 1,2

--Q10 Retrieve the tracks names that have been streamed on
--Spotify more than Youtube 

SELECT *FROM 
(SELECT 
Track,
--most_playedon,
SUM (CASE WHEN most_playedon='Youtube' THEN stream END) AS streamed_on_yt,
SUM (CASE WHEN most_playedon='Spotify' THEN stream END) AS streamed_on_spotify
FROM spotify
GROUP BY 1) as t1
WHERE streamed_on_yt>streamed_on_spotify

--YOU CAN READ ABOOUT COLASECE FUNCTION TO MAKE THE NULL VALLEUS TO ZERO AND THEN REMOVE THEM
--ADVANCED QUERIES 

--Q11 Find the top 3 most viewed tracks of each artist  using window functions

--dense rank functions 
--using cte and filtre we will seggregate the rank
WITH ranking_artist as

(SELECT 
 DISTINCT Artist,
Track,
SUM (Views) as total_view,
--dense rank will also take care of the null value so partition by artist means it will
--divide artist by artist
DENSE_RANK () OVER(PARTITION BY artist ORDER BY SUM(views)DESC) AS rank
FROM spotify 
GROUP BY 1,2
ORDER BY 1,3 DESC)

SELECT * FROM ranking_artist
WHERE rank<=3

--Q12 WRITE a query to find tracks where the liveness score is above the average
SELECT Track,artist,liveness
FROM spotify

WHERE liveness>(SELECT AVG(liveness) FROM spotify)


--Q13 use the WITH clause to calculate the difference between the highest 
--and lowest energy values for tracks in each album
WITH difference
AS
(
SELECT 
album,
track,
MAX(energy) as highest,
MIN(energy) as lowest
FROM spotify
GROUP BY 1,2
)
SELECT 
album,
highest-lowest as diff
FROM difference 

