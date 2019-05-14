-- List all the company names (and countries) that are incorporated outside Australia.
    create or replace view Q1(Name, Country) as
        select Name, Country
        from   Company
        where  country <> 'Australia';

-- List all the company codes that have more than five executive members on record (i.e., at least six).
    create or replace view Q2(Code) as
        select   ExecutiveCount.code
        from
            (select  c.code, count(c.code)
             from    Company   c
             join    Executive e on (c.code = e.code)
            group by   c.code) as ExecutiveCount
        -- NOTE: change the below to 4 when testing,no sample data for 5+
        where   ExecutiveCount.count   >   5;

-- List all the company names that are in the sector of "Technology"
    create or replace view Q3(Name) as
           select  name
           from    Category   cat
           join    Company    c     on   (c.code   =   cat.code)
           where   sector     =     'Technology';

-- Find the number of Industries in each Sector
    create or replace view Q4(Sector, Number) as
        select  distinct sector,
                count(industry) over (partition by sector)
        from    category
        group   by sector, industry
        order   by sector;

-- Find all the executives (i.e., their names) that are affiliated with companies in the sector of "Technology". If an executive is affiliated with more than one company, he/she is counted if one of these companies is in the sector of "Technology".
    create or replace view Q5(Name) as
        select  e.person
        from    executive    e
                join company  c   on e.code   = c.code
                join category cat on cat.code = c.code
        where   cat.sector  =  'Technology';

-- List all the company names in the sector of "Services" that are located in Australia with the first digit of their zip code being 2.
    create or replace view Q6(Name) as
        select  c.name
        from    company c
        join    category cat   on  (cat.code = c.code)
        where   cat.sector     =   'Services'
        and     c.zip          ~   '^2'
        and     c.country      =   'Australia';

 -- Create a database view of the ASX table that 
        -- contains previous Price,
        -- Price change (in amount, can be negative) 
        -- and Price gain (in percentage, can be negative). 
    -- (Note that the first trading day should be excluded in your result.)
    -- For example, if the PrevPrice is 1.00, Price is 0.85; then Change is -0.15 and Gain is -15.00 (in percentage but you do not need to print out the percentage sign).
    create or replace view Q7("Date", Code, Volume, PrevPrice, Price, Change, Gain) as
        select   curr."Date",
                 curr.code,
                 volume,
                 prevPrice,
                 newPrice,
                 newPrice-prevPrice,
                 trunc(newPrice/prevPrice*100-100, 14)
        from    (select  code, price as prevPrice, "Date"
                   from  asx
                ) as prev
        join    (select  code, price as newPrice, "Date", volume
                   from  asx
                ) as curr
                on prev."Date"+1=curr."Date" and prev.code = curr.code;


-- Find the most active trading stock (the one with the maximum trading volume; if more than one, output all of them) on every trading day. Order your output by "Date" and then by Code.
    create or replace view Q8("Date", Code, Volume) as
        select    "Date", code, volume
        from
            (select  "Date", code, volume,
                     max(volume) over (partition by "Date")
             from    asx)  as  asx
        where     volume = max
        order by  "Date", volume, code desc;

-- Find the number of companies per Industry. Order your result by Sector and then by Industry.
    create or replace view Q9(Sector, Industry, Number) as
        select  sector, industry, count(code)
        from    category
        group   by sector, industry
        order   by sector, industry;

-- List all the companies (by their Code) that are the only one in their Industry (i.e., no competitors).
    create or replace view Q10(Code, Industry) as
        select  company.code, company.industry
        from
                (select company.code, industry,
                        count(*) over (partition by industry)
                from    category
                join    company on (category.code = company.code))
        as      company
        where   count = 1
        order   by code, industry;

-- List all sectors ranked by their average ratings in descending order. AvgRating is calculated by finding the average AvgCompanyRating for each sector (where AvgCompanyRating is the average rating of a company).
    create or replace view Q11(Sector, AvgRating) as
        select  sector, avg
        from
            (select  sector,
                     avg(rating.star) over (partition by sector)
            from    company
              join  rating    on (rating.code   = company.code)
              join  category  on (category.code = company.code))
        as      sectorRatings
        group   by sector, avg
        order   by avg desc;

-- Output the person names of the executives that are affiliated with more than one company.
   create or replace view Q12(Name) as
       select   e.person
       from     executive   e
       group    by          e.person
       having   count       (e.person)   >   1;

-- Find all the companies with a registered address in Australia, in a Sector where there are no overseas companies in the same Sector. i.e., they are in a Sector that all companies there have local Australia address.
   create or replace view Q13(Code, Name, Address, Zip, Sector) as
       select   company.code, name, address, zip, sector
         from   company
                join    category on (category.code = company.code)
        where   sector not in (
                                select   distinct sector
                                  from   company
                                  join   category on category.code = company.code
                                 group   by sector, company.country
                                having   company.country != 'Australia'
        )
        order   by sector;

-- Calculate stock gains based on their prices of the first trading day and last trading day (i.e., the oldest "Date" and the most recent "Date" of the records stored in the ASX table). Order your result by Gain in descending order and then by Code in ascending order.
    create or replace view Q14(Code, BeginPrice, EndPrice, Change, Gain) as 
    select   beginAsx.code,
             beginPrice,
             endPrice,
             endPrice-beginPrice,
             trunc(endPrice/beginPrice*100-100, 15)
    from    (select code, price as beginPrice, "Date"
            from asx beginAsx
            where "Date"= (
                            select min("Date")
                            from asx
                            where code=beginAsx.code
            )) as beginAsx
    join    (select code, price as endPrice, "Date"
            from asx endAsx
            where "Date"= (
                            select max("Date")
                            from asx
                            where code=endAsx.code
        )) as endAsx on beginAsx.code=endAsx.code;


-- For all the trading records in the ASX table, produce the following statistics as a database view (where Gain is measured in percentage). AvgDayGain is defined as the summation of all the daily gains (in percentage) then divided by the number of trading days (as noted above, the total number of days here should exclude the first trading day).
    create or replace view Q15(Code, MinPrice, AvgPrice, MaxPrice, MinDayGain, AvgDayGain, MaxDayGain) as
        select  prices.code,
                prices.min,
                prices.avg,
                prices.max,
                change.min,
                change.avg,
                change.max
        from
            (select  asx.code,
                    min(price),
                    avg(price),
                    max(price)
            from asx
            group by asx.code
            ) as prices
        join (select min(gain),
                     avg(gain),
                     max(gain),
                     code
                  from Q7
                  group by q7.code
            ) as change
            on prices.code=change.code;

-- Q16 Create a trigger on the Executive table, to check and disallow any insert or update of a Person in the Executive table to be an executive of more than one company.

    create or replace function checkPerson()
        returns trigger as $$
        begin
            if exists (select *
                         from Executive
                        where person = new.person
                      ) then
                raise exception '% is already an executive', new.person;
            end if;
            return new;
        end
        $$ language plpgsql;

        drop trigger if exists checkPerson on executive;
        create trigger checkPerson
            before insert
            on Executive
            for each row
            execute procedure checkPerson();



-- Q17 Suppose more stock trading data are incoming into the ASX table. Create a trigger to increase the stock's rating (as Star's) to 5 when the stock has made a maximum daily price gain (when compared with the price on the previous trading day) in percentage within its sector. For example, for a given day and a given sector, if Stock A has the maximum price gain in the sector, its rating should then be updated to 5. If it happens to have more than one stock with the same maximum price gain, update all these stocks' ratings to 5. Otherwise, decrease the stock's rating to 1 when the stock has performed the worst in the sector in terms of daily percentage price gain. If there are more than one record of rating for a given stock that need to be updated, update (not insert) all these records. You may assume that there are at least two trading records for each stock in the existing ASX table, and do not worry about the case that when the ASX table is initially empty.

        create or replace function rateStock()
        returns trigger as $$
        declare
            newSector   varchar(40);
            maxGain     numeric;
            minGain     numeric;
            priceGain   numeric;
        begin
            newSector := (select sector
                          from   category
                          where  code=new.code
                         );

            priceGain := new.price/(
                                    select price
                                    from   asx
                                    where  asx.code=new.code and
                                           asx."Date"=new."Date"
                                   );

            -- find the sector's max gain of the previous day
            maxGain := (select  max(newPrice/prevPrice)
                        from    (select  code, price as prevPrice, "Date"
                                 from    asx natural join category
                                 where   sector=newSector and "Date"=new."Date"-2
                                ) as     prev
                        join    (select  code, price as newPrice, "Date", volume
                                 from    asx natural join category
                                 where   sector=newSector and "Date"=new."Date"-1
                                ) as     curr
                                on prev."Date"+1=curr."Date" and prev.code=curr.code
                       );

            minGain := (select  min(newPrice/prevPrice)
                        from    (select  code, price as prevPrice, "Date"
                                 from    asx natural join category
                                 where   sector=newSector and "Date"=new."Date"-2
                                ) as     prev
                        join    (select  code, price as newPrice, "Date", volume
                                 from    asx natural join category
                                 where   sector=newSector and "Date"=new."Date"-1
                                ) as     curr
                                on prev."Date"+1=curr."Date" and prev.code=curr.code
                       );

            if (new.price > maxGain) then
                update rating set star=5 where code=new.code;
            elsif (new.price < minGain) then
                update rating set star=1 where code=new.code;
            end if;
            return new;
        end;
        $$ language plpgsql;

        drop trigger if exists rateStock on asx;
        create trigger rateStock
            after insert
            on asx
            for each row
            execute procedure rateStock();


-- Q18 Stock price and trading volume data are usually incoming data and seldom involve updating existing data.
    -- However, updates are allowed in order to correct data errors.
    -- All such updates (instead of data insertion) are logged and stored in the ASXLog table.
    -- Create a trigger to log any updates on Price and/or Voume in the ASX table and log these updates 
        -- (only for update, not inserts) into the ASXLog table. 
    -- Here we assume that Date and Code cannot be corrected and will be the same as their original, old values. 
    -- Timestamp is the date and time that the correction takes place. 
    -- Note that it is also possible that a record is corrected more than once, i.e., same Date and Code but different Timestamp.

        create or replace function logUpdate()
        returns trigger as $$
        declare
        begin
            insert into asxlog values (now(), new."Date", new.code, old.volume, old.price);
            return new;
        end;
        $$ language plpgsql;

        drop trigger if exists asxlogger on asx;
        create trigger asxlogger
            after update
            on asx
            for each row
            execute procedure logUpdate();



