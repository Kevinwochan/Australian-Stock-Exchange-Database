create table Marks (
Q integer,
M integer default 0
);

insert into Marks(Q) values(1);
insert into Marks(Q) values(2);
insert into Marks(Q) values(3);
insert into Marks(Q) values(4);
insert into Marks(Q) values(5);
insert into Marks(Q) values(6);
insert into Marks(Q) values(7);
insert into Marks(Q) values(8);
insert into Marks(Q) values(9);
insert into Marks(Q) values(10);
insert into Marks(Q) values(11);
insert into Marks(Q) values(12);
insert into Marks(Q) values(13);
insert into Marks(Q) values(14);
insert into Marks(Q) values(15);
insert into Marks(Q) values(16);
insert into Marks(Q) values(17);
insert into Marks(Q) values(18);

update Marks set M=1 where Q=1 AND (select count(*) from (select * from Q1 intersect select * from Q1soln) X) = (select count(*) from (select * from Q1 union select * from Q1soln) Y);
update Marks set M=1 where Q=2 AND (select count(*) from (select * from Q2 intersect select * from Q2soln) X) = (select count(*) from (select * from Q2 union select * from Q2soln) Y);
update Marks set M=1 where Q=3 AND (select count(*) from (select * from Q3 intersect select * from Q3soln) X) = (select count(*) from (select * from Q3 union select * from Q3soln) Y);
update Marks set M=1 where Q=4 AND (select count(*) from (select * from Q4 intersect select * from Q4soln) X) = (select count(*) from (select * from Q4 union select * from Q4soln) Y);
update Marks set M=1 where Q=5 AND (select count(*) from (select * from Q5 intersect select * from Q5soln) X) = (select count(*) from (select * from Q5 union select * from Q5soln) Y);
update Marks set M=1 where Q=6 AND (select count(*) from (select * from Q6 intersect select * from Q6soln) X) = (select count(*) from (select * from Q6 union select * from Q6soln) Y);

update Marks set M=1 where Q=7 AND (select count(*) from (select "Date", Code, Volume, PrevPrice, Price, Change from Q7 intersect select "Date", Code, Volume, PrevPrice, Price, Change from Q7soln) X) = (select count(*) from (select "Date", Code, Volume, PrevPrice, Price, Change from Q7 union select "Date", Code, Volume, PrevPrice, Price, Change from Q7soln) Y);

update Marks set M=1 where Q=8 AND (select count(*) from (select * from Q8 intersect select * from Q8soln) X) = (select count(*) from (select * from Q8 union select * from Q8soln) Y);
update Marks set M=1 where Q=9 AND (select count(*) from (select * from Q9 intersect select * from Q9soln) X) = (select count(*) from (select * from Q9 union select * from Q9soln) Y);
update Marks set M=1 where Q=10 AND (select count(*) from (select * from Q10 intersect select * from Q10soln) X) = (select count(*) from (select * from Q10 union select * from Q10soln) Y);

update Marks set M=1 where Q=11 AND (select count(*) from (select Sector, AvgRating::int from Q11 intersect select * from Q11soln) X) = (select count(*) from (select Sector, AvgRating::int from Q11 union select * from Q11soln) Y);
update Marks set M=1 where Q=12 AND (select count(*) from (select * from Q12 intersect select * from Q12soln) X) = (select count(*) from (select * from Q12 union select * from Q12soln) Y);
update Marks set M=1 where Q=13 AND (select count(*) from (select * from Q13 intersect select * from Q13soln) X) = (select count(*) from (select * from Q13 union select * from Q13soln) Y);
update Marks set M=1 where Q=14 AND (select count(*) from (select Code, BeginPrice, EndPrice, Change from Q14 intersect select Code, BeginPrice, EndPrice, Change from Q14soln) X) = (select count(*) from (select Code, BeginPrice, EndPrice, Change from Q14 union select Code, BeginPrice, EndPrice, Change from Q14soln) Y);

-- There are a few interpretations of the definitions of MonDayGain etc, so only a simple check is used here.
update Marks set M=1 where Q=15 AND (select count(*) from (select Code, MinPrice, MaxPrice from Q15 intersect select * from Q15soln) X) = (select count(*) from (select Code, MinPrice, MaxPrice from Q15 union select * from Q15soln) Y);

insert into Executive VALUES('AWE', 'Mr. Alistair Field'); -- should fail
update Executive set Person = 'Mr. Alistair Field' where Person = 'Mr. Dennis Washer'; -- should fail
insert into Executive VALUES('AWE', 'Mr. Alistair Ford');

update Marks set M=1 where Q=16 AND (select count(*) from (select Person from Executive where Code = 'AWE' intersect select * from Q16soln) X) = (select count(*) from (select Person from Executive where Code = 'AWE' union select * from Q16soln) Y);

INSERT INTO ASX VALUES('2012-01-10','ABC','833900','2.58');
INSERT INTO ASX VALUES('2012-01-10','AGK','743800','13.84');
INSERT INTO ASX VALUES('2012-01-10','ALZ','207500','2.27');
INSERT INTO ASX VALUES('2012-01-10','AMP','9675800','3.85');
INSERT INTO ASX VALUES('2012-01-10','AUT','855300','3.33');
INSERT INTO ASX VALUES('2012-01-10','AIO','2368600','4.41');
TRUNCATE Rating;
INSERT INTO Rating(Code, Star) VALUES ('ABC', 3);
INSERT INTO Rating(Code, Star) VALUES ('AGK', 3);
INSERT INTO Rating(Code, Star) VALUES ('AIO', 3);
INSERT INTO Rating(Code, Star) VALUES ('ALZ', 3);
INSERT INTO Rating(Code, Star) VALUES ('AMP', 3);
INSERT INTO Rating(Code, Star) VALUES ('ANZ', 3);
INSERT INTO Rating(Code, Star) VALUES ('AUT', 3);
INSERT INTO Rating(Code, Star) VALUES ('AWC', 3);
INSERT INTO Rating(Code, Star) VALUES ('AWE', 3);
INSERT INTO ASX VALUES('2012-01-10','ANZ','6036800','21.90');
INSERT INTO ASX VALUES('2012-01-10','AWC','9674700','0.67');

update Marks set M=1 where Q=17 AND (select count(*) from (select * from Rating where star=1 or star=5 intersect select * from Q17soln where star=1 or star=5) X) = (select count(*) from (select * from Rating  where star=1 or star=5 union select * from Q17soln  where star=1 or star=5) Y);

update ASX set Price ='21.80' where "Date" = '2012-01-10' and Code = 'ANZ';
update ASX set Volume = '100000' where "Date" = '2012-01-10' and Code = 'ANZ';
update ASX set (Price, Volume) = ('20.50', '200000') where "Date" = '2012-01-10' and Code = 'ANZ';
update ASX set (Price, Volume) = ('25.50', '300000') where "Date" = '2012-01-10' and Code = 'ANZ';

update Marks set M=1 where Q=18 AND (select count(*) from (select Code, OldPrice, OldVolume from ASXLog intersect select * from Q18soln) X) = (select count(*) from (select Code, OldPrice, OldVolume from ASXLog union select * from Q18soln) Y);
