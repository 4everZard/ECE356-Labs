alter table teamshalf add primary key(teamId, yearId, half);
alter table teamshalf add foreign key (teamID) references teams(teamID);