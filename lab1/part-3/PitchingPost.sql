alter table pitchingpost add primary key(playerID, yearID, round);
alter table pitchingpost add constraint fk_PitchingPost_Master foreign key (playerID) references master(playerID);
alter table pitchingpost add constraint fk_PitchingPost_Teams foreign key (teamID) references teams(teamID);