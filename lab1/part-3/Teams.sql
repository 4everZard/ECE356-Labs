alter table teams add primary key(teamID, yearID);
alter table teams add constraint fk_Teams_TeamsFranchises foreign key (franchID) references teamsfranchises(franchId);