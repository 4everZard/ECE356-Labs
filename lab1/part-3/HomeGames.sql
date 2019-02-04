alter table homegames add primary key (`park.key`, `team.key`, `year.key`);
alter table homegames add foreign key (`team.key`) references teams(teamID);
alter table homegames add foreign key (`park.key`) references parks(`park.key`);