-- 1)a)
select count(*) from Master where birthYear = 0 OR birthMonth = 0 OR birthDay = 0;

-- 1)b)
 SELECT
 	COUNT(CASE WHEN t.deathDay = '' AND t.deathMonth='' and t.deathYear='' THEN 1 END)
    - COUNT(CASE WHEN t.deathDay != '' AND t.deathMonth!='' and t.deathYear!='' THEN 1 END)
     from (SELECT deathDay, deathMonth, deathYear FROM HallOfFame join Master on HallOfFame.playerID=Master.playerID) as t;

-- 1)c)
select nameFirst, nameLast from ((select playerID, sum(salary) as sumSalary from salaries group by playerID) salaries 
join Master on Master.playerID=salaries.playerID) order by sumSalary desc limit 1 ;

-- 1) d)
select avg(avgHR) from (select avg(HR) as avgHR from Batting group by playerID) as t;

-- 1) e)
select avg(avgHR) from (select avg(HR) as avgHR from Batting where HR > 0 group by playerID) as t;

-- 1) f)
select COUNT(*) from (select b.playerID, avg(b.HR) as hrAVG, p.avgSHO
 from  Batting b
 join (select playerID, avg(SHO) as avgSHO from Pitching group by playerID) 
  p on b.playerID=p.playerID group by playerID) j
  where j.hrAVG > (select avg(avgHRIndiv) from (select sum(HR) as avgHRIndiv from Batting group by playerID) as t)
  and j.avgSHO > (select avg(avgSHOIndiv) from (select sum(SHO) as avgSHOIndiv from Pitching group by playerID) as e);
