alter table appearances add primary key (playerID, yearID, teamID);
alter table appearances add foreign key (teamID) references teams(teamID);
alter table appearances add foreign key (playerID) references master(playerID);