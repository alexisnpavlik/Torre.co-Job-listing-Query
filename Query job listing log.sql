SELECT
    o.id as ID,
    o.objective as job_title

FROM opportunities as o

WHERE true
    and objective <> 'Shared by an intermediary'
    and review = 'approved'

group by o.id
order by o.created desc;