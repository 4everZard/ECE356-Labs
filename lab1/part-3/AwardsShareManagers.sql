alter table awardssharemanagers add primary key (playerID, yearID, awardID);
alter table awardssharemanagers add foreign key (playerID) references Master(playerID);
alter table awardssharemanagers add foreign key (playerID) references managers(playerID);