alter table managershalf add primary key (playerID, yearID, teamID, half);
alter table managershalf add foreign key (playerID) references managers(playerID);
alter table managershalf add foreign key (teamID) references teams(teamID);