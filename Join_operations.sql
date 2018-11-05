/* Join operations */
/*http://sqlzoo.net/wiki/The_JOIN_operation */

/*The first example shows the goal scored by a player with the last name 'Bender'. The * says to
 list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime
Modify it to show the matchid and player name for all goals scored by Germany. To identify German
 players, check for: teamid = 'GER' */

 SELECT goal.matchid,goal.player 
FROM goal 
WHERE teamid = 'GER';

/*From the previous query you can see that Lars Bender's scored a goal in game 1012. 
Now we want to know what teams were playing in that match.
Notice in the that the column matchid in the goal table corresponds to the id column in 
the game table. We can look up information about game 1012 by finding that row in the game table.
Show id, stadium, team1, team2 for just game 1012 */

SELECT id,stadium,team1,team2
  FROM game
WHERE id =1012;

/*The code below shows the player (from the goal) and stadium name (from the game table) for every 
goal scored.
Modify it to show the player, teamid, stadium and mdate for every German goal. */

SELECT goal.player,goal.teamid,game.stadium,game.mdate
FROM game 
JOIN goal
ON game.id=goal.matchid
WHERE goal.teamid ='GER' ;

/*Use the same JOIN as in the previous question.
Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%' */

SELECT game.team1, game.team2, goal.player
FROM game
JOIN goal
ON game.id = goal.matchid
WHERE  goal.player LIKE 'Mario%';

/*The table eteam gives details of every national team including the coach.
 You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id
Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10 */

SELECT goal.player, goal.teamid, eteam.coach, goal.gtime
FROM goal 
JOIN eteam
ON  goal.teamid = eteam.id
 WHERE gtime<=10;

 /*List the the dates of the matches and the name of the team in which 'Fernando Santos' was the team1
 coach.*/

 SELECT game.mdate , eteam.teamname
FROM game
JOIN eteam
ON game.team1 = eteam.id
WHERE eteam.coach ='Fernando Santos';

/*List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'*/

SELECT goal.player 
FROM goal
JOIN game
ON goal.matchid = game.id
WHERE game.stadium = 'National Stadium, Warsaw';

/*harder questions */

/*The example query shows all goals scored in the Germany-Greece quarterfinal.
Instead show the name of all players who scored a goal against Germany. */

SELECT DISTINCT player
  FROM game JOIN goal ON matchid = id 
    WHERE (team1='GER' OR team2='GER') AND goal.teamid!='GER';

/* Show teamname and the total number of goals scored. */

SELECT teamname, COUNT (teamname)
 FROM eteam JOIN goal ON id=teamid
GROUP BY teamname;

/*Show the stadium and the number of goals scored in each stadium. */

SELECT game.stadium, count(goal.player)
FROM game
JOIN goal
ON game.id = goal.matchid
GROUP BY game.stadium ;

/*For every match involving 'POL', show the matchid, date and the number of goals scored.*/

SELECT goal.matchid,game.mdate,COUNT(goal.teamid) AS goal_scored
FROM game JOIN goal
ON goal.matchid = game.id 
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY goal.matchid, game.mdate;

/*For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER' */

SELECT goal.matchid,game.mdate,COUNT(goal.teamid) AS goal_scored
FROM game JOIN goal
ON goal.matchid = game.id 
WHERE (team1 = 'GER' OR team2 = 'GER') AND goal.teamid = 'GER'
GROUP BY goal.matchid, game.mdate;

/*List every match with the goals scored by each team as shown. 
This will use "CASE WHEN" which has not been explained in any previous exercises. */

SELECT game.mdate, game.team1,
  SUM(CASE WHEN goal.teamid=team1 THEN 1 ELSE 0 END) AS score1 ,
  game.team2,
  SUM(CASE WHEN goal.teamid=team2 THEN 1 ELSE 0 END) AS score2 
  FROM game 
  LEFT JOIN goal 
  ON goal.matchid = game.id
  GROUP BY game.mdate, game.team1,game.team2 ;

/* more join operations */
/*http://sqlzoo.net/wiki/More_JOIN_operations */

/*List the films where the yr is 1962 [Show id, title] */

SELECT id, title
 FROM movie
 WHERE yr=1962

/*Give year of 'Citizen Kane'. */

SELECT yr
FROM movie
WHERE title ='Citizen Kane';

/*List all of the Star Trek movies, include the id, title and yr 
(all of these movies include the words Star Trek in the title). Order results by year. */

SELECT id, title , yr
FROM movie
WHERE title LIKE '%star trek%';

/*What id number does the actor 'Glenn Close' have?  */

SELECT id
FROM actor
WHERE name = 'Glenn Close';

/*What is the id of the film 'Casablanca'  */

SELECT id
FROM movie
WHERE title ='Casablanca' 

/*Obtain the cast list for 'Casablanca'.
Use movieid=11768, (or whatever value you got from the previous question) */

SELECT actor.name
FROM casting
JOIN actor
ON casting.actorid = actor.id
WHERE movieid=11768;

/*Obtain the cast list for the film 'Alien'  */

SELECT actor.name
FROM movie
JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON casting.actorid= actor.id
WHERE movie.title ='Alien';

/*List the films in which 'Harrison Ford' has appeared  */

SELECT movie.title
FROM actor
JOIN casting
ON actor.id=casting.actorid
JOIN movie
ON movie.id=casting.movieid
WHERE actor.name = 'Harrison Ford';

/*List the films where 'Harrison Ford' has appeared - but not in the starring role.  */

SELECT movie.title
FROM actor
JOIN casting
ON actor.id=casting.actorid
JOIN movie
ON movie.id=casting.movieid
WHERE actor.name = 'Harrison Ford' AND casting.ord>1;

/*List the films together with the leading star for all 1962 films.  */

SELECT movie.title,actor.name
FROM movie
JOIN casting
ON movie.id=casting.movieid
JOIN actor
ON casting.actorid = actor.id
WHERE casting.ord=1 AND movie.yr='1962';

/*Which were the busiest years for 'John Travolta', show the year and the number of
movies he made each year for any year in which he made more than 2 movies. */

SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
where name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(c) FROM
(SELECT yr,COUNT(title) AS c FROM
   movie JOIN casting ON movie.id=movieid
         JOIN actor   ON actorid=actor.id
 where name='John Travolta'
 GROUP BY yr) AS t)

/*List the film title and the leading actor for all of the films 'Julie Andrews' played in. */

SELECT x.title, xz.name
FROM movie AS x
JOIN casting  AS xy
ON x.id = xy.movieid
JOIN actor AS xz
ON xz.id =xy.actorid
WHERE xy.ord=1 AND x.id IN (
   SELECT y.id
   FROM movie AS y
   JOIN casting  AS yy
   ON y.id = yy.movieid
   JOIN actor AS yz
   ON yz.id =yy.actorid    
   WHERE name='Julie Andrews'
);

/*Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles. */

SELECT DISTINCT actor.name
FROM movie
JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON casting.actorid=actor.id
WHERE 30<=  (
  SELECT COUNT(*)
  FROM movie AS x
  JOIN casting AS y
  ON x.id = y.movieid  
  JOIN actor AS z
  ON y.actorid=z.id
  WHERE actor.name = z.name AND y.ord=1
) ;

/*List the films released in the year 1978 ordered by the number of actors in the cast, then by title. */

SELECT movie.title, COUNT(actor.name) AS actors_in_cast
FROM movie
JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON casting.actorid = actor.id
WHERE movie.yr = 1978
GROUP BY movie.title
ORDER BY actors_in_cast DESC , movie.title; 

/*List all the people who have worked with 'Art Garfunkel'. */

SELECT DISTINCT actor.name
FROM movie
JOIN casting
ON movie.id=casting.movieid
JOIN actor
ON casting.actorid=actor.id
WHERE actor.name !='Art Garfunkel' AND movie.title IN (
    SELECT x.title
    FROM movie AS x
    JOIN casting AS y
    ON x.id= y.movieid
    JOIN actor AS z
    ON y.actorid = z.id
    WHERE z.name = 'Art Garfunkel');