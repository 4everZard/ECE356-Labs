-- 1.a)
SELECT COUNT(playerID)
    FROM Master 
    WHERE birthYear=0 OR birthMonth=0 OR birthDay=0;

-- 1.b)
SELECT
    (SELECT COUNT(*)
    FROM Master INNER JOINHallOfFame ON Master.playerID = HallOfFame.playerID
    WHERE deathYear=0 AND deathMonth=0 AND deathDay=0) - 
    (SELECT COUNT(*)
    FROM Master INNER JOINHallOfFame on Master.playerID = HallOfFame.playerID
    WHERE deathYear!=0 AND deathMonth!=0 AND deathDay!=0)
    AS Diff;

-- 1.c)
SELECT nameFirst, nameLast 
    FROM ((SELECT playerID, SUM(salary) AS sumSalary FROM Salaries GROUP BY playerID) AS salaries
    JOINMaster on Master.playerID=salaries.playerID) ORDER BY sumSalary DESC LIMIT 1 ;

-- 1.d)
SELECT AVG(sumHR)
    FROM (SELECT SUM(HR) as sumHR FROM Batting group by playerID) AS t;

-- 1.e)
SELECT AVG(sumHR) 
    FROM (SELECT SUM(HR) as sumHR FROM Batting group by playerID) AS t
    WHERE t.sumHR != 0;

-- 1.f)
SELECT COUNT(playerID)
    FROM
    (SELECT playerID
        FROM (SELECT playerID, SUM(HR) as sumHR FROM Batting group by playerID) AS t
        WHERE sumHR > (SELECT AVG(sumHR) FROM (SELECT SUM(HR) as sumHR FROM Batting group by playerID) AS t1)) AS t2
    WHERE playerID IN
    (SELECT playerID
        FROM (SELECT playerID, SUM(SHO) as sumSHO FROM Pitching group by playerID) AS t
        WHERE sumSHO > (SELECT AVG(sumSHO) FROM (SELECT SUM(SHO) as sumSHO FROM Pitching group by playerID) AS t1));

-- 2)
LOAD DATA LOCAL INFILE 'Fielding.csv'
    INTO TABLE Fielding
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (playerID, yearID, stint, teamID, lgID, POS, G, GS, InnOuts, PO, A, E, DP, PB, WP, SB, CS, ZR);

-- 3)

ALTER TABLE FieldingPost ADD PRIMARY KEY (playerID, yearID, teamID, pos, round);
ALTER TABLE FieldingPost ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE FieldingPost ADD FOREIGN KEY (teamID) REFERENCES teams(teamID);

ALTER TABLE HallOfFame ADD PRIMARY KEY (playerID, yearID, votedBy);
DELETE FROM HallOfFame WHERE playerID NOT IN (select playerID FROM Master);
ALTER TABLE HallOfFame ADD CONSTRAINT fk_HallOfFame_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE HomeGames ADD PRIMARY KEY (`park.KEY`, `team.KEY`, `year.KEY`);
ALTER TABLE HomeGames ADD FOREIGN KEY (`team.KEY`) REFERENCES teams(teamID);
ALTER TABLE HomeGames ADD FOREIGN KEY (`park.KEY`) REFERENCES parks(`park.KEY`);

ALTER TABLE Managers ADD PRIMARY KEY (playerID, yearID, inseason);
ALTER TABLE Managers ADD CONSTRAINT fk_Managers_Teams FOREIGN KEY(teamID) REFERENCES Teams(teamID);
ALTER TABLE Managers ADD CONSTRAINT fk_Managers_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);

ALTER TABLE ManagersHalf ADD PRIMARY KEY (playerID, yearID, teamID, half);
ALTER TABLE ManagersHalf ADD FOREIGN KEY (playerID) REFERENCES Managers(playerID);
ALTER TABLE ManagersHalf ADD FOREIGN KEY (teamID) REFERENCES teams(teamID);

ALTER TABLE Master ADD PRIMARY KEY (playerID)

ALTER TABLE Parks ADD PRIMARY KEY (`park.KEY`);

ALTER TABLE Pitching ADD PRIMARY KEY(playerID, yearID, stint);
ALTER TABLE Pitching ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE Pitching ADD FOREIGN KEY (teamID) REFERENCES teams(teamID);

ALTER TABLE PitchingPost ADD PRIMARY KEY(playerID, yearID, round);
ALTER TABLE PitchingPost ADD CONSTRAINT fk_PitchingPost_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE PitchingPost ADD CONSTRAINT fk_PitchingPost_Teams FOREIGN KEY (teamID) REFERENCES teams(teamID);

ALTER TABLE Salaries ADD PRIMARY KEY(playerID, yearID, teamID);
DELETE FROM Salaries WHERE playerId NOT IN (select playerId FROM Master);
DELETE FROM Salaries WHERE teamID NOT IN (select teamID FROM teams);
ALTER TABLE Salaries ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE Salaries ADD FOREIGN KEY (teamID) REFERENCES teams(teamID);

ALTER TABLE Schools ADD PRIMARY KEY (schoolID);

ALTER TABLE SeriesPost ADD PRIMARY KEY(teamidwinner,round, yearId);
ALTER TABLE SeriesPost ADD FOREIGN KEY (teamIDwinner) REFERENCES teams(teamID);
ALTER TABLE SeriesPost ADD FOREIGN KEY (teamIDloser) REFERENCES teams(teamID);

ALTER TABLE TeamsFranchises ADD PRIMARY KEY(franchID);

ALTER TABLE Teams ADD PRIMARY KEY(teamID, yearID);
ALTER TABLE Teams ADD CONSTRAINT fk_Teams_TeamsFranchises FOREIGN KEY (franchID) REFERENCES teamsfranchises(franchId);

ALTER TABLE TeamShalf ADD PRIMARY KEY(teamId, yearId, half);
ALTER TABLE TeamShalf ADD FOREIGN KEY(teamID) REFERENCES teams(teamID);