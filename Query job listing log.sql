SELECT
    -- ID
    o.id as ID,
    -- Job title
    o.objective as 'Job title',
    -- location
    (select group_concat(l.location) from opportunity_places l where l.opportunity_id = o.id and l.active = 1) as 'location',
    -- matches
     (case when me.interested is not null and oc.interested is not null then 1 else 0 end) as 'Match',
    -- Commit date
    och.created as 'Commited date',
    -- Created date 
    o.created as 'Created date',
    -- Approved date
    o.reviewed as 'Approved date',
    -- Language of the post
    o.locale as 'Language of the post',
    -- Type of job
    o.commitment_id as 'Type of job',
    -- Type of service
    o.fulfillment as 'Type of service',
    -- Status
    o.status as 'Status',
    -- Account Manager
    p.username as 'Account manager',
    -- Disqualified
     me.send_disqualified_notification  as 'data',
    -- Changes history, last updated
    o.last_updated as 'Changes history',
    -- Completed applications
    sum(case when oc.id is not null and oc.interested is not null then 1 else 0 end) as 'Completed Applications',
    -- Incomplete applications
    sum(case when oc.id is not null and oc.interested is null and application_step is not null then 1 else 0 end) as 'Incomplete applications'
    -- Hires
    sum(case when oc.id is not null and osh.hiring_date is not null then 1 else 0 end) as 'Hires'

FROM opportunities as o

-- Necessary for completed applications and incomplete applications
join opportunity_candidates as oc on o.id = oc.opportunity_id
-- Necessary for account manager
join opportunity_changes_history as och on o.id = och.opportunity_id
--Necessa
left join person_account_managers as pam on och.person_id = pam.person_id
--join to make the relation people-person_account_mannager
left join people as p on pam.person_id = p.id
--join to asign osh to get match dates
left join opportunity_stats_hires osh on o.id = osh.opportunity_id
--join to get member evaluation
join member_evaluations as me on oc.id = me.member_id


WHERE true
    and me.send_disqualified_notification = true
    and o.objective <> 'Shared by an intermediary'
    and o.review = 'approved'
    -- Approved date is not null
    and o.reviewed is not null
    and p.username in ("nataliaarrieta","danna73","josealdave","davidorban","srlondono","najarroa","andresmeza","danielaavila","natisropi","danielabotero","carolinamontoyaar","valentinasantosss","danigaviriaz24","jhonmarin1989","nellcacho","jhonmarin","diana_cujer","dianaaparicio ","edlombanal","danna73","paulamarulanda","pklozanom","melissa")

group by o.id
order by o.created desc;
