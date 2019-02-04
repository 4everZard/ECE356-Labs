-- 1.a)
SELECT COUNT(playerID)
    FROM Master 
    WHERE birthYear=0 OR birthMonth=0 OR birthDay=0;

-- 1.b)
SELECT
    (SELECT COUNT(*)
    FROM Master INNER JOIN HallOfFame ON Master.playerID = HallOfFame.playerID
    WHERE deathYear=0 AND deathMonth=0 AND deathDay=0) - 
    (SELECT COUNT(*)
    FROM Master INNER JOIN HallOfFame on Master.playerID = HallOfFame.playerID
    WHERE deathYear!=0 AND deathMonth!=0 AND deathDay!=0)
    AS Diff;

-- 1.c)
SELECT nameFirst, nameLast 
    FROM ((SELECT playerID, SUM(salary) AS sumSalary FROM Salaries GROUP BY playerID) AS salaries
    JOIN Master on Master.playerID=salaries.playerID) ORDER BY sumSalary DESC LIMIT 1 ;

-- 1.d)
SELECT AVG(sumHR)
    FROM (SELECT SUM(HR) as sumHR from Batting group by playerID) AS t;

-- 1.e)
SELECT AVG(sumHR) 
    FROM (SELECT SUM(HR) as sumHR from Batting group by playerID) AS t
    WHERE t.sumHR != 0;

-- 1.f)
SELECT COUNT(playerID)
    FROM
    (SELECT playerID
        FROM (SELECT playerID, SUM(HR) as sumHR from Batting group by playerID) AS t
        WHERE sumHR > (SELECT AVG(sumHR) FROM (SELECT SUM(HR) as sumHR from Batting group by playerID) AS t1)) AS t2
    WHERE playerID IN
    (SELECT playerID
        FROM (SELECT playerID, SUM(SHO) as sumSHO from Pitching group by playerID) AS t
        WHERE sumSHO > (SELECT AVG(sumSHO) FROM (SELECT SUM(SHO) as sumSHO from Pitching group by playerID) AS t1));

-- 2