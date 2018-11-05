/*Using null */
/* http://sqlzoo.net/wiki/Using_Null */

/* List the teachers who have NULL for their department.  */

SELECT teacher.name
FROM teacher
WHERE teacher.dept IS NULL;

/*Note the INNER JOIN misses the teachers with no department and the departments with no teacher.  */

SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id)

/* Use a different JOIN so that all teachers are listed. */

SELECT teacher.name , dept.name
FROM teacher
LEFT JOIN dept
ON teacher.dept = dept.id;

/*Use a different JOIN so that all departments are listed. */

SELECT teacher.name , dept.name
FROM teacher
RIGHT JOIN dept
ON teacher.dept = dept.id;

/*Use COALESCE to print the mobile number. Use the number '07986 444 2266'
 if there is no number given. Show teacher name and mobile number or '07986 444 2266' */

 SELECT teacher.name ,COALESCE(teacher.mobile, '07986 444 2266') AS mobile
FROM teacher;

/*Use the COALESCE function and a LEFT JOIN to print the 
teacher name and department name. Use the string 'None' where there is no department. */

SELECT teacher.name, COALESCE(dept.name, 'None') AS dept_name
FROM teacher
LEFT JOIN dept
ON teacher.dept = dept.id;

/*Use COUNT to show the number of teachers and the number of mobile phones.  */

SELECT COUNT(teacher.name) , COUNT(teacher.mobile)
FROM teacher;

/*Use COUNT and GROUP BY dept.name to show each department and the number of staff.
 Use a RIGHT JOIN to ensure that the Engineering department is listed.  */

 SELECT dept.name, COUNT (teacher.name) 
FROM teacher
RIGHT JOIN dept
ON teacher.dept = dept.id
GROUP BY dept.name;

/*Use CASE to show the name of each teacher followed by 'Sci'
 if the teacher is in dept 1 or 2 and 'Art' otherwise.  */

 SELECT teacher.name,
       CASE 
       WHEN  teacher.dept=1 OR teacher.dept=2 THEN  'Sci'
       ELSE  'Art' 
       END AS dept
FROM teacher;

/* Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2,
show 'Art' if the teacher's dept is 3 and 'None' otherwise.  */

SELECT teacher.name,
       CASE 
       WHEN  teacher.dept=1 OR teacher.dept=2 THEN  'Sci'
       WHEN  teacher.dept=3 THEN 'Art'
       ELSE  'None' 
       END AS dept
FROM teacher;

/* NSS tutorial */

/* http://sqlzoo.net/wiki/NSS_Tutorial */

/* The example shows the number who responded for:
    question 1
    at 'Edinburgh Napier University'
    studying '(8) Computer Science'
Show the the percentage who STRONGLY AGREE */

SELECT A_STRONGLY_AGREE
  FROM nss
 WHERE question='Q01'
   AND institution='Edinburgh Napier University'
   AND subject='(8) Computer Science'

/*Show the institution and subject where the score is at least 100 for question 15. */

SELECT institution, subject
  FROM nss
 WHERE question='Q15'AND
   score >= 100

/*Show the institution and score where the score for '(8) Computer Science' 
is less than 50 for question 'Q15'  */

SELECT institution,score
  FROM nss
 WHERE question='Q15'
   AND subject='(8) Computer Science'
   AND score < 50;

/*Show the subject and total number of students who responded to question 22 for each
 of the subjects '(8) Computer Science' and '(H) Creative Arts and Design'.  */

 SELECT subject, SUM(response)
  FROM nss
 WHERE question='Q22'
 AND subject IN('(8) Computer Science','(H) Creative Arts and Design')
 GROUP BY subject;

 /* Show the subject and total number of students who A_STRONGLY_AGREE to question 22 for each of
  the subjects '(8) Computer Science' and '(H) Creative Arts and Design'. */

  SELECT subject , SUM((A_STRONGLY_AGREE*response)/100)
  FROM nss
 WHERE question='Q22'
 AND subject IN ('(8) Computer Science','(H) Creative Arts and Design')
GROUP BY subject;

/*Show the percentage of students who A_STRONGLY_AGREE to question 22 for the subject '(8) Computer Science'
 show the same figure for the subject '(H) Creative Arts and Design'.
Use the ROUND function to show the percentage without decimal places.  */

SELECT subject , ROUND(SUM(A_STRONGLY_AGREE*response)/SUM(response))
 FROM nss
 WHERE question='Q22'
 AND subject IN ('(8) Computer Science','(H) Creative Arts and Design')
GROUP BY subject;

/* Show the average scores for question 'Q22' for each institution that include 'Manchester' in the name.
The column score is a percentage - you must use the method outlined above to multiply the percentage by the
 response and divide by the total response. Give your answer rounded to the nearest whole number. */

SELECT institution,ROUND(SUM(score*response)/SUM(response) )
  FROM nss
 WHERE question='Q22'
   AND (institution LIKE '%Manchester%')
GROUP BY institution;

/*Show the institution, the total sample size and the number of computing students for institutions in 
Manchester for 'Q01'. */

SELECT institution,SUM(sample),SUM(
  CASE 
  WHEN subject='(8) Computer Science' THEN sample
  ELSE 0 
  END
) AS COMP
  FROM nss
 WHERE question='Q01'
   AND (institution LIKE '%Manchester%')
GROUP BY institution

