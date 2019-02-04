alter table collegeplaying add primary key (playerID, schoolID, yearID);
alter table collegeplaying add foreign key (playerID) references master(playerID);
delete from collegeplaying where schoolID not in (select schoolID from schools);
alter table collegeplaying add foreign key (schoolID) references schools(schoolID);