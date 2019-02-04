alter table seriespost add primary key(teamidwinner,round, yearId);
alter table seriespost add foreign key (teamIDwinner) references teams(teamID);
alter table seriespost add foreign key (teamIDloser) references teams(teamID);