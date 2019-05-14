    

select  *
from    (select  code, price as prevPrice, "Date"
           from  asx
        ) as prev
join    (select  code, price as newPrice, "Date", volume
           from  asx
        ) as curr
        on prev."Date"+1=curr."Date";
        --accesson prev.code = curr.code and prev."Date"+1=curr."Date";



--        select  c.name
--        from    company c
--        join    category cat   on  (cat.code = c.code)
--        where   cat.sector     =   'Services'
--        and     c.zip          ~   '^2'
--        and     c.country      =   'Australia';





































---- Q17 Suppose more stock trading data are incoming into the ASX table.
--    -- Create a trigger to increase the stock's rating (as Star's) to 5
--        -- when stock has max daily price gain compared with the price on the previous day
--    -- For example, for a given day and a given sector,
--        -- if Stock A has the maximum price gain in the sector,
--        -- its rating should then be updated to 5.
--        -- If it happens to have more than one stock with the same maximum price gain
--            -- update all these stocks' ratings to 5.
--        -- Otherwise, decrease the stock's rating to 1 when the stock has performed the worst in the sector 
--            -- in terms of daily percentage price gain.
--        -- If there is more than one record of a rating for a given stock that needs to be updated, update (not insert) all these records.
--        -- You may assume that there are at least two trading records for each stock in the existing ASX table, and do not worry about the case that when the ASX table is initially empty.
--
--        create or replace function rateStock() returns trigger as $$
--        declare
--            newSector   varchar(40);
--            maxGain     numeric;
--            minGain     numeric;
--            priceGain   numeric;
--        begin
--
--            newSector := (select sector
--                          from   category
--                          where  code=new.code
--                         );
--
--            priceGain := new.price/(
--                                    select price
--                                    from   asx
--                                    where  asx.code=new.code and
--                                           asx."Date"=new."Date"
--                                   );
--
--            -- find the sector's max gain of the previous day
--            maxGain := (select  max(newPrice/prevPrice)
--                        from    (select  code, price as prevPrice, "Date"
--                                 from    asx natural join category
--                                 where   sector=newSector and "Date"=new."Date"-2
--                                ) as     prev
--                        join    (select  code, price as newPrice, "Date", volume
--                                 from    asx natural join category
--                                 where   sector=newSector and "Date"=new."Date"-1
--                                ) as     curr
--                                on prev."Date"+1=curr."Date" and prev.code=curr.code
--                       );
--
--            minGain := (select  min(newPrice/prevPrice)
--                        from    (select  code, price as prevPrice, "Date"
--                                 from    asx natural join category
--                                 where   sector=newSector and "Date"=new."Date"-2
--                                ) as     prev
--                        join    (select  code, price as newPrice, "Date", volume
--                                 from    asx natural join category
--                                 where   sector=newSector and "Date"=new."Date"-1
--                                ) as     curr
--                                on prev."Date"+1=curr."Date" and prev.code=curr.code
--                       );
--
--            if (new.price > maxGain) then
--                update rating set star=5 where code=new.code;
--            else if (new.price < minGain) then
--                update rating set star=1 where code=new.code;
--            end if;
--
--        end;
--        $$ language plpgsql;
--
--        drop trigger if exists rateStock on asx;
--        create trigger rateStock
--            after insert
--            on asx
--            for each row
--            execute procedure rateStock();



