alter table fieldingpost add primary key (playerID, yearID, teamID, pos, round);
alter table fieldingpost add foreign key (playerID) references master(playerID);
alter table fieldingpost add foreign key (teamID) references teams(teamID);