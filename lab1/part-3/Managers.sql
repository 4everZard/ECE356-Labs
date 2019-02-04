alter table managers add primary key (playerID, yearID, inseason);
alter table managers add constraint fk_Managers_Teams foreign key(teamID) references Teams(teamID);
alter table managers add constraint fk_Managers_Master foreign key (playerID) references Master(playerID);