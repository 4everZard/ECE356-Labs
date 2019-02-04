alter table halloffame add primary key (playerID, yearID, votedBy);
delete from halloffame where playerID not in (select playerID from master);
alter table halloffame add constraint fk_HallOfFame_Master foreign key (playerID) references master(playerID);