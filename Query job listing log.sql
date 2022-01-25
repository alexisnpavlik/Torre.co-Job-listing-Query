SELECT
    o.id as job_id,
    o.objective as job_title,
    -- Company,
    -- URL,
    -- Manager Link,

FROM opportunities o

WHERE 
    and objective <> 'Shared by an intermediary'
    and review = 'approved'