alter table fieldingOfSplit add primary key (playerID, yearID, pos, stint);
alter table fieldingofsplit add foreign key (playerID) references master(playerID);
alter table fieldingofsplit add foreign key (teamID) references teams(teamID);