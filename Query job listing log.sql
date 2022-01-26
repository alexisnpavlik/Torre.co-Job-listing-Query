SELECT
    o.id as ID,
    o.objective as Job_title,
    -- url,
    -- Manager_link,
    -- location,
    o.created as Created_date,
    o.reviewed as Approved_date,
    -- closing date,
    o.locale as Language_of_the_post,
    o.commitment_id as Type_of_job,
    o.fulfillment as Type_of_service,
    -- Recruiter_advisor,
    o.status as Status,
    o.last_updated as Changes_history,
    o. as Completed_applications
    
    
    

FROM opportunities as o

WHERE true
    and objective <> 'Shared by an intermediary'
    and review = 'approved'

group by o.id
order by o.created desc;