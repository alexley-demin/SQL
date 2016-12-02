/*соотнесенные подзапросы*/

SELECT cnum, cname 
FROM Cust outer 
WHERE rating = (SELECT MAX (rating) FROM Cust inner WHERE inner.city = outer.city); 

SELECT snum, sname 
FROM Sal outer 
WHERE city IN (SELECT city FROM Cust inner WHERE inner.snum < > outer.snum); 
 
SELECT DISTINCT s.snum, sname 
FROM Sal s, Cust c 
WHERE s.city = c.city AND s.snum < > c.snum; 

/*пердикат exists*/

SELECT * 
FROM Sal outer 
WHERE EXISTS (SELECT * FROM Cust inner WHERE outer.snum = inner.snum AND rating = 300); 

SELECT * 
FROM Cust outer 
WHERE EXISTS (SELECT * FROM Ord inner WHERE outer.snum = inner.snum AND outer.cnum < > inner.cnum);

/*пердикаты all,any,some*/
SELECT * 
FROM Cust 
WHERE rating > = ANY (SELECT rating FROM Cust WHERE snum = 1002); 
            
SELECT * 
FROM Sal
WHERE city < > ALL (SELECT city FROM Cust); 
 
 или 
 
SELECT * 
FROM Sal
WHERE NOT city = ANY (SELECT city FROM Cust); 
 
SELECT * 
FROM Ord 
WHERE amt > ALL (SELECT amt FROM Ord a, Cust b WHERE a.cnum = b.cnum AND b.city = 'London'); 
/*union, minus,intersect*/
SELECT cname, city, rating, 'High Rating' 
       FROM Cust 
       WHERE rating > = 200 
 
       UNION 
 
    SELECT cname, city, rating, 'Low Rating' 
       FROM Cust 
       WHERE rating < 200; 
          
SELECT cnum, cname 
FROM Cust a WHERE 1 < (SELECT COUNT (*) FROM Ord b WHERE a.cnum = b.cnum) 
 
           UNION 
 
SELECT snum, sname 
FROM Sal a WHERE 1 < (SELECT COUNT (*) FROM Ord b WHERE a.snum = b.snum) ORDER BY 2;

SELECT snum 
FROM Sal MINUS select snum from ord; 

SELECT cname 
FROM Cust INTERSECT SELECT sname from Sal;
/*внешние содинения*/

SELECT Sal.snum, sname, cnum, cname 
FROM Sal left join Cust on Sal.snum = Cust.snum and Cust.RATING > 100;

SELECT Cust.cnum, cname, Sal.snum, sname 
FROM Cust left join Sal on Sal.snum = Cust.snum and (Sal.CITY='London' or Sal.CITY='Barcelona');

SELECT Sal.snum, sname, cnum, cname 
FROM Sal right join Cust on Sal.snum = Cust.snum;

SELECT snum + 1 num
FROM (SELECT * FROM sal ORDER BY snum ASC) s
WHERE snum > 1002
  AND NOT EXISTS(
    SELECT 1 
    FROM sal s1 
    WHERE s1.snum = s.snum + 1
  )
  AND ROWNUM = 1;
  
SELECT s.snum + 1 num
FROM sal s
FULL OUTER JOIN sal s1 ON s1.snum = s.snum + 1
WHERE s.snum > 1002
  AND s1.snum IS NULL
  AND ROWNUM = 1;