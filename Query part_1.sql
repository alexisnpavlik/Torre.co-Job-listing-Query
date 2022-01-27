SELECT
    -- ID
    o.id as ID,
    -- Job title
    o.objective as 'Job title',
    -- location
    (select group_concat(l.location) from opportunity_places l where l.opportunity_id = o.id and l.active = 1) as 'location',
    --Created date 
    o.created as 'Created date',
    -- Approved date
    o.reviewed as 'Approved date',
    -- Language of the post
    o.locale as 'Language of the post',
    o.commitment_id as 'Type of job',
    o.fulfillment as 'Type of service',
    o.status as 'Status',
    o.last_updated as 'Changes history',
    pam.person_id as 'Account manager',
    sum(case when oc.id is not null and oc.interested is not null then 1 else 0 end) as 'Completed Applications',
    sum(case when oc.id is not null and oc.interested is null and application_step is not null then 1 else 0 end) as 'Incomplete applications'
FROM opportunities as o

join opportunity_candidates as oc on o.id = oc.opportunity_id
join opportunity_changes_history as och on o.id = och.opportunity_id
left join person_account_managers as pam on och.person_id = pam.person_id


WHERE true
    and o.objective <> 'Shared by an intermediary'
    and o.review = 'approved'
    and o.reviewed is not null
group by o.id
order by o.created desc
LIMIT 10000;