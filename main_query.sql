SELECT
    -- ID
    o.id as 'ID',
    -- Job title
    o.objective as 'Job title',
    -- Company
   (select organization_id from opportunity_organizations where opportunity_id =  o.id  group by organization_id limit 1) as 'Company_id',
    -- location
    (select group_concat(l.location) from opportunity_places l where l.opportunity_id = o.id and l.active = 1) as 'location',
    -- Type of service
    o.fulfillment as 'Type of service',
    -- Type of job
    o.commitment_id as 'Type of job',
   -- Created date 
    DATE(o.created) as 'Created date',
    -- Approved date
    DATE(o.reviewed) as 'Approved date',
    -- Applicant Acquisition Coordinator
    (select name FROM people p WHERE o.applicant_coordinator_person_id=p.id) as 'Applicant Acquisition Coordinator',
    -- Commited date
    (select DATE(och.created) FROM opportunity_changes_history och WHERE och.opportunity_id = o.id group by opportunity_id ) as 'Commited date',
    -- Status
    o.status as 'Status',
    -- Completed applications
    sum(case when oc.id is not null and oc.interested is not null then 1 else 0 end) as 'Completed applications',
    -- Incomplete applications
    sum(case when oc.id is not null and oc.interested is null and application_step is not null then 1 else 0 end) as  'Incomplete applications',
    -- Mutual matches
    sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and oc2.name = 'mutual matches'
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Mutual matches',
    sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and oc2.name <> 'mutual matches'
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Others',
    sum(case when oc.id is not null and oc.interested is not null
    and (last_evaluation.last_not_interest is not null and (last_evaluation.last_interest is null or last_evaluation.last_interest < last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Disqualified',
    -- Changes history, last updated
    DATE(o.last_updated) as 'Last changes',
    -- Closing date
    DATE(o.deadline) as 'Closing Date',
    o.locale as 'Language of the post',
    -- Hires
    (select sum(case when osh.hiring_date is not null then 1 else 0 end)  + sum(case when osh.hiring_verified is not null then 1 else 0 end) from opportunity_stats_hires osh where o.id=osh.opportunity_id) as 'Hires'
     -- Sharing token
    (select sharing_token from opportunity_members where manager = true and status = 'accepted' and opportunity_id =  o.id  limit 1) as 'Sharing token'
   
FROM opportunities o 
LEFT JOIN opportunity_candidates oc on o.id=oc.opportunity_id
left join opportunity_columns oc2 on oc.column_id = oc2.id
left join (
  select me.candidate_id, max(me.interested) as last_interest, max(me.not_interested) as last_not_interest
  from member_evaluations me
  group by me.candidate_id) last_evaluation on last_evaluation.candidate_id = oc.id


WHERE true

    and o.objective <> 'Shared by an intermediary'
    and review = 'approved'
    and status <> 'opening-soon'
    and applicant_coordinator_person_id is not null
   -- Tester, bot and opportunity Craw Ler
    and NOT o.`id` IN (
        SELECT o2.`id`
        FROM opportunities o2
        JOIN opportunity_members om ON o2.`id` = om.`opportunity_id`
        JOIN people p on om.`person_id` = p.`id`
        JOIN person_flags pf on p.`id` = pf.`person_id`
        WHERE om.`person_id` IN (82,2629) OR (om.`person_id` NOT IN (SELECT `id` FROM metrics_people) AND om.`poster`) OR (pf.opportunity_crawler AND om.poster))
    
    
group by o.id
order by o.created desc;