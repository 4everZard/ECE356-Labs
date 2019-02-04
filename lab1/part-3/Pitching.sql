alter table pitching add primary key(playerID, yearID, stint);
alter table pitching add foreign key (playerID) references master(playerID);
alter table pitching add foreign key (teamID) references teams(teamID);