alter table battingpost add primary key (playerID, yearID, round);
alter table battingpost add constraint fk_BattingPost_Teams foreign key (teamID) references teams(teamID);
alter table battingPost add constraint fk_BattingPost_Master foreign key (playerID) references master(playerID);