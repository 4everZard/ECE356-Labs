alter table salaries add primary key(playerID, yearID, teamID);
delete from salaries where playerId not in (select playerId from master);
delete from salaries where teamID not in (select teamID from teams);
alter table salaries add foreign key (playerID) references master(playerID);
alter table salaries add foreign key (teamID) references teams(teamID);