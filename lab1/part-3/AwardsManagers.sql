alter table awardsmanagers add primary key (playerID, awardID, yearID);
alter table awardsmanagers add foreign key (playerID) references managers(playerID);
alter table awardsmanagers add foreign key (playerID) references master(playerID);