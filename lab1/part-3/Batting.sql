alter table batting add primary key (playerID, yearID, stint);
alter table batting add foreign key (playerID) references master(playerID);
alter table batting add foreign key (teamID) references teams(teamID);