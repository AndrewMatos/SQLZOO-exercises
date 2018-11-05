/* self join */
/* http://sqlzoo.net/wiki/Self_join */

/*How many stops are in the database. */

SELECT COUNT(*)
FROM stops;

/* Find the id value for the stop 'Craiglockhart'  */

SELECT stops.id
FROM stops
WHERE stops.name='Craiglockhart' 

/*Give the id and the name for the stops on the '4' 'LRT' service.  */

SELECT stops.id , stops.name
FROM route
JOIN  stops
ON route.stop= stops.id
WHERE route.company='LRT' AND route.num = '4';

/*The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). 
Run the query and notice the two services that link these stops have a count of 2. Add a 
HAVING clause to restrict the output to these two routes. */

SELECT company, num, COUNT(*) AS count
FROM route 
WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING count= 2;

/*Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, 
without changing routes. Change the query so that it shows the services from Craiglockhart to London Road. */

SELECT a.company, a.num, a.stop, b.stop
FROM route a 
JOIN route b 
ON(a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop= 149;

/*The query shown is similar to the previous one, however by joining two copies of the stops table 
we can refer to stops by name rather than by number. Change the query so that the services between
 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' 
 against 'Tollcross'  */

 SELECT a.company, a.num, stopa.name, stopb.name
FROM route a 
JOIN route b 
ON(a.company=b.company AND a.num=b.num)
JOIN stops stopa 
ON (a.stop=stopa.id)
JOIN stops stopb
ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'AND stopb.name = 'London Road'

/* Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')  */

SELECT DISTINCT a.company, a.num
FROM route AS a
JOIN route AS b
ON a.company = b.company AND a.num = b.num
WHERE a.stop = 115 AND b.stop=137;

/* Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'  */

SELECT a.company , a.num
FROM route AS a
JOIN route AS b
ON a.company = b.company AND a.num= b.num
JOIN stops AS sa
ON  a.stop = sa.id
JOIN stops AS sb
ON b.stop = sb.id
WHERE sa.name = 'Craiglockhart' AND sb.name ='Tollcross' 

/*Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, 
including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the 
relevant services. */

SELECT sb.name , b.company, b.num
FROM route AS a
JOIN route AS b
ON a.company = b.company AND a.num= b.num
JOIN stops AS sa
ON  a.stop = sa.id
JOIN stops AS sb
ON b.stop = sb.id
WHERE a.company = 'LRT'  AND sa.name = 'Craiglockhart' 

/*Find the routes involving two buses that can go from Craiglockhart to Sighthill.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus.  */

SELECT DISTINCT S.num,S.company, stops.name, E.num, E.company
FROM (
   SELECT a.company, a.num, b.stop
   FROM route AS a JOIN route AS b ON (a.company = b.company AND a.num =b.num)
   WHERE  a.stop = (SELECT stops.id FROM stops WHERE stops.name ='Craiglockhart')
) AS S
JOIN (
  SELECT c.company, c.num, d.stop
  FROM route AS c JOIN route AS d ON (c.company =d.company AND c.num = d.num)
  WHERE c.stop = (SELECT stops.id FROM stops WHERE stops.name = 'Sighthill')
) E
ON S.stop = E.stop
JOIN stops ON (S.stop = stops.id);
