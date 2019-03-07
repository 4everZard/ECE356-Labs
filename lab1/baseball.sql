-- 1.a = 449
SELECT COUNT(playerID)
    FROM Master 
    WHERE birthYear=0 OR birthMonth=0 OR birthDay=0;

-- 1.b = -1699
SELECT
    (SELECT COUNT(*)
    FROM Master INNER JOIN HallOfFame ON Master.playerID = HallOfFame.playerID
    WHERE deathYear=0 AND deathMonth=0 AND deathDay=0) - 
    (SELECT COUNT(*)
    FROM Master INNER JOIN HallOfFame ON Master.playerID = HallOfFame.playerID
    WHERE deathYear!=0 AND deathMonth!=0 AND deathDay!=0)
    AS Diff;

-- 1.c = Alex Rodriguez 377416252
SELECT nameFirst, nameLast, sumSalary 
    FROM ((SELECT playerID, SUM(salary) AS sumSalary FROM Salaries GROUP BY playerID) AS salaries
    JOIN Master on Master.playerID=salaries.playerID) ORDER BY sumSalary DESC LIMIT 1 ;

-- 1.d = 15.2938
SELECT AVG(sumHR)
    FROM (SELECT SUM(HR) AS sumHR FROM Batting GROUP BY playerID) AS t;

-- 1.e = 37.3944
SELECT AVG(sumHR) 
    FROM (SELECT SUM(HR) AS sumHR FROM Batting GROUP BY playerID) AS t
    WHERE t.sumHR != 0;

-- 1.f = 39
SELECT COUNT(playerID)
    FROM
    (SELECT playerID
        FROM (SELECT playerID, SUM(HR) AS sumHR FROM Batting GROUP BY playerID) AS t
        WHERE sumHR > (SELECT AVG(sumHR) FROM (SELECT SUM(HR) AS sumHR FROM Batting GROUP BY playerID) AS t1)) AS t2
    WHERE playerID IN
    (SELECT playerID
        FROM (SELECT playerID, SUM(SHO) AS sumSHO FROM Pitching GROUP BY playerID) AS t
        WHERE sumSHO > (SELECT AVG(sumSHO) FROM (SELECT SUM(SHO) AS sumSHO FROM Pitching GROUP BY playerID) AS t1));

-- 2)
LOAD DATA LOCAL INFILE 'Fielding.csv'
    INTO TABLE Fielding
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (playerID, yearID, stint, teamID, lgID, POS, G, GS, InnOuts, PO, A, E, DP, PB, WP, SB, CS, ZR);

-- 3)

-- Primary Keys

-- AllStarFull
ALTER TABLE AllstarFull ADD PRIMARY KEY (playerID, gameID);

-- Appearances
ALTER TABLE Appearances ADD PRIMARY KEY (playerID, yearID, teamID);

-- AwardsManagers
ALTER TABLE AwardsManagers ADD PRIMARY KEY (playerID, awardID, yearID);

-- AwardsPlayers
ALTER TABLE AwardsPlayers ADD PRIMARY KEY (playerID, awardID, yearID, lgID);

-- AwardsShareManagers
ALTER TABLE AwardsShareManagers ADD PRIMARY KEY (playerID, yearID, awardID);

-- AwardsSharePlayers
ALTER TABLE AwardsSharePlayers ADD PRIMARY KEY (playerID, yearID, awardID);

-- Batting
ALTER TABLE Batting ADD PRIMARY KEY (playerID, yearID, stint);

-- BattingPost
ALTER TABLE BattingPost ADD PRIMARY KEY (playerID, yearID, round);

-- CollegePlaying
-- playerIDs in this table do not exist in Master. 
-- For there to exist a foreign key to Master these playerId's must be deleted from Master.
ALTER TABLE CollegePlaying ADD PRIMARY KEY (playerID, schoolID, yearID);

-- Fielding
ALTER TABLE Fielding ADD PRIMARY KEY (playerID, yearID, stint, POS);

-- FieldingOF
ALTER TABLE FieldingOF ADD PRIMARY KEY (playerID, yearID, stint);

-- FieldingOfSplit
ALTER TABLE FieldingOFsplit ADD PRIMARY KEY (playerID, yearID, pos, stint);

-- FieldingPost
ALTER TABLE FieldingPost ADD PRIMARY KEY (playerID, yearID, teamID, pos, round);

-- HallOfFame
-- playerIDs in this table do not exist in Master. 
-- For there to exist a foreign key to Master these playerId's must be deleted from Master.
ALTER TABLE HallOfFame ADD PRIMARY KEY (playerID, yearID, votedBy);

-- HomeGames
ALTER TABLE HomeGames ADD PRIMARY KEY (`park.key`, `team.key`, `year.key`);

-- Managers
ALTER TABLE Managers ADD PRIMARY KEY (playerID, yearID, inseason);

-- ManagersHalf
ALTER TABLE ManagersHalf ADD PRIMARY KEY (playerID, yearID, teamID, half);

-- Master
ALTER TABLE Master ADD PRIMARY KEY (playerID);

-- Parks
ALTER TABLE Parks ADD PRIMARY KEY (`park.key`);

-- Pitching
ALTER TABLE Pitching ADD PRIMARY KEY(playerID, yearID, stint);

-- PitchingPost
ALTER TABLE PitchingPost ADD PRIMARY KEY(playerID, yearID, round);

-- Salaries
-- teamIds in this table do not exist in the Teams. 
-- For there to exist a foreign key these teamId's must be deleted from Master.
ALTER TABLE Salaries ADD PRIMARY KEY(playerID, yearID, teamID);

-- Schools
ALTER TABLE Schools ADD PRIMARY KEY (schoolID);

-- SeriesPost
ALTER TABLE SeriesPost ADD PRIMARY KEY(teamidwinner,round, yearID);

-- TeamFranchises
ALTER TABLE TeamsFranchises ADD PRIMARY KEY(franchID);

-- Teams
ALTER TABLE Teams ADD PRIMARY KEY(teamID, yearID);

-- TeamsHalf
ALTER TABLE TeamsHalf ADD PRIMARY KEY(teamID, yearID, half);


-- Foreign Key

-- AllStarFull
ALTER TABLE AllstarFull ADD CONSTRAINT fk_AllstarFull_Teams FOREIGN KEY (teamID) REFERENCES Teams(teamID);
ALTER TABLE AllstarFull ADD CONSTRAINT fk_AllstarFull_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- Appearances
ALTER TABLE Appearances ADD FOREIGN KEY (teamID) REFERENCES Teams(teamID);
ALTER TABLE Appearances ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- AwardsManagers
ALTER TABLE AwardsManagers ADD FOREIGN KEY (playerID) REFERENCES Managers(playerID);
ALTER TABLE AwardsManagers ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- AwardsPlayers
ALTER TABLE AwardsPlayers ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- AwardsShareManagers
ALTER TABLE AwardsShareManagers ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE AwardsShareManagers ADD FOREIGN KEY (playerID) REFERENCES Managers(playerID);

-- AwardsSharePlayers
ALTER TABLE AwardsSharePlayers ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- Batting
ALTER TABLE Batting ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE Batting ADD FOREIGN KEY (teamID) REFERENCES Teams(teamID);

-- BattingPost
ALTER TABLE BattingPost ADD CONSTRAINT fk_BattingPost_Teams FOREIGN KEY (teamID) REFERENCES Teams(teamID);
ALTER TABLE BattingPost ADD CONSTRAINT fk_BattingPost_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- CollegePlaying
ALTER TABLE CollegePlaying ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
delete from CollegePlaying WHERE schoolID NOT IN (SELECT schoolID FROM Schools);
ALTER TABLE CollegePlaying ADD FOREIGN KEY (schoolID) REFERENCES Schools(schoolID);

-- Fielding
ALTER TABLE Fielding ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE Fielding ADD FOREIGN KEY (teamID) REFERENCES Teams(teamID);

-- FieldingOF
ALTER TABLE FieldingOF ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- FieldingOFsplit
ALTER TABLE FieldingOFsplit ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE FieldingOFsplit ADD FOREIGN KEY (teamID) REFERENCES Teams(teamID);

-- FieldingPost
ALTER TABLE FieldingPost ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE FieldingPost ADD FOREIGN KEY (teamID) REFERENCES Teams(teamID);

-- HallOfFame
delete from HallOfFame WHERE playerID not in (select playerID from Master);
ALTER TABLE HallOfFame ADD CONSTRAINT fk_HallOfFame_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- HomeGames
ALTER TABLE HomeGames ADD FOREIGN KEY (`team.key`) REFERENCES Teams(teamID);
ALTER TABLE HomeGames ADD FOREIGN KEY (`park.key`) REFERENCES Parks(`park.key`);

-- Managers
ALTER TABLE Managers ADD CONSTRAINT fk_Managers_Teams FOREIGN KEY(teamID) REFERENCES Teams(teamID);
ALTER TABLE Managers ADD CONSTRAINT fk_Managers_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);

-- ManagersHalf
ALTER TABLE ManagersHalf ADD FOREIGN KEY (playerID) REFERENCES Managers(playerID);
ALTER TABLE ManagersHalf ADD FOREIGN KEY (teamID) REFERENCES Teams(teamID);

-- Pitching
ALTER TABLE Pitching ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE Pitching ADD FOREIGN KEY (teamID) REFERENCES Teams(teamID);

-- PitchingPost
ALTER TABLE PitchingPost ADD CONSTRAINT fk_PitchingPost_Master FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE PitchingPost ADD CONSTRAINT fk_PitchingPost_Teams FOREIGN KEY (teamID) REFERENCES Teams(teamID);

-- Salaries
delete from Salaries WHERE playerId not in (select playerId from Master);
delete from Salaries WHERE teamID not in (select teamID from Teams);
ALTER TABLE Salaries ADD FOREIGN KEY (playerID) REFERENCES Master(playerID);
ALTER TABLE Salaries ADD FOREIGN KEY (teamID) REFERENCES Teams(teamID);

-- SeriesPost
ALTER TABLE SeriesPost ADD FOREIGN KEY (teamIDwinner) REFERENCES Teams(teamID);
ALTER TABLE SeriesPost ADD FOREIGN KEY (teamIDloser) REFERENCES Teams(teamID);

-- Teams
ALTER TABLE Teams ADD CONSTRAINT fk_Teams_TeamsFranchises FOREIGN KEY (franchID) REFERENCES TeamsFranchises(franchID);

-- TeamsHalf
ALTER TABLE TeamsHalf ADD FOREIGN KEY (teamID) REFERENCES Teams(teamID);