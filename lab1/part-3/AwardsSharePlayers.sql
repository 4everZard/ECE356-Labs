alter table awardsshareplayers add primary key (playerID, yearID, awardId);
alter table awardsshareplayers add foreign key (playerID) references master(playerID);