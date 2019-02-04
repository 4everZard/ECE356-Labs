alter table fielding add primary key (playerID, yearID, stint, POS);
alter table fielding add foreign key (playerID) references master(playerID);
alter table fielding add foreign key (teamID) references teams(teamID);