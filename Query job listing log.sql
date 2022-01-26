SELECT

    -- Mauricio here --


    
    o.id as ID,
    o.objective as 'Job title',
    -- url,
    -- Manager_link,
    (select group_concat(l.location) from opportunity_places l where l.opportunity_id = o.id and l.active = 1) as 'location',
    o.created as 'Created date',
    o.reviewed as 'Approved date',
    -- closing date,
    o.locale as 'Language of the post',
    o.commitment_id as 'Type of job',
    o.fulfillment as 'Type of service',
    -- Recruiter_advisor,
    o.status as 'Status',
    o.last_updated as 'Changes history',
    sum(case when oc.id is not null and oc.interested is not null then 1 else 0 end) as 'Completed Applications',
    sum(case when oc.id is not null and oc.interested is null and application_step is not null then 1 else 0 end) as 'Incomplete applications'
    -- Pending for review
    -- Mutual matches
    -- Other
    -- Active
    -- Disqualified
    -- Hires
    -- Yesterday new applications
    -- Superfilter
    -- +2 weeks with Superfilter
    -- +2 weeks with -10 appl
    
    

FROM opportunities as o

left join opportunity_candidates as oc on o.id = oc.opportunity_id

WHERE true
    and o.objective <> 'Shared by an intermediary'
    and o.review = 'approved'

group by o.id
order by o.created desc
LIMIT 10000;