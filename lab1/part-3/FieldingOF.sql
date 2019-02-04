alter table fieldingOf add primary key (playerID, yearID, stint);
alter table fieldingOF add foreign key (playerID) references master(playerID);