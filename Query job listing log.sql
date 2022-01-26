SELECT
    o.id as ID,
    o.objective as Job_title,
    -- url,
    -- Manager Link,
    -- location,
    o.created as Created_date,
    o.reviewed as Approved_date,
    -- closing date,
    o.locale as Language_of_the_post
    

FROM opportunities as o

WHERE true
    and objective <> 'Shared by an intermediary'
    and review = 'approved'

group by o.id
order by o.created desc;