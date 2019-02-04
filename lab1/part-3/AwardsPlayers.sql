alter table awardsplayers add primary key (playerID, awardID, yearID, lgID);
alter table awardsplayers add foreign key (playerID) references Master(playerID);