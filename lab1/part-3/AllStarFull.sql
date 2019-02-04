alter table allstarfull add primary key (playerID, gameID);
alter table allstarfull add constraint fk_AllstarFull_Teams foreign key (teamID) references teams(teamID);
alter table allstarfull add constraint fk_AllstarFull_Master foreign key (playerID) references master(playerID);