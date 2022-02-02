SELECT
    -- ID
    o.id as 'ID',
    -- Job title
    o.objective as 'Job title',
    -- Company
   (select organization_id from opportunity_organizations where opportunity_id =  o.id  group by organization_id limit 1) as 'Company_id',
    -- location
    (select group_concat(l.location) from opportunity_places l where l.opportunity_id = o.id and l.active = 1) as 'location',
   -- Created date 
    DATE(o.created) as 'Created date',
    -- Approved date
    DATE(o.reviewed) as 'Approved date',
   (select DATE(och.created) FROM opportunity_changes_history och WHERE och.opportunity_id = o.id group by opportunity_id ) as 'Commited date',
    -- Status
    o.status as 'Status',
    -- Completed applications
    sum(case when oc.id is not null and oc.interested is not null then 1 else 0 end) as 'completed applications',
    -- Incomplete applications
    sum(case when oc.id is not null and oc.interested is null and application_step is not null then 1 else 0 end) as  'Incomplete applications',
    
    sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and oc2.name = 'mutual matches'
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'mutual matches',
    sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and oc2.name <> 'mutual matches'
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Other',
    sum(case when oc.id is not null and oc.interested is not null
    and (last_evaluation.last_not_interest is not null and (last_evaluation.last_interest is null or last_evaluation.last_interest < last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'Disqualified',
    -- Changes history, last updated
    DATE(o.last_updated) as 'Last changes',
    -- Closing date
    DATE(o.deadline) as 'Closing Date'
   
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
   -- and status ='open'
   -- and applicant_coordinator_person_id is not null
    
    and o.id = 886966
    
group by o.id
order by o.created desc;