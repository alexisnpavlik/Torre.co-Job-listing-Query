SELECT
    o.id as ID,
    och.created as 'Commited date',
    me.send_disqualified_notification = 'True' as 'Disqualified',
    pam.person_id as 'Account manager',
    sum(case when oc.id is not null and osh.hiring_date is not null then 1 else 0 end) as 'Hires'
    

FROM opportunities as o

join opportunity_candidates as oc on o.id = oc.opportunity_id
join opportunity_changes_history as och on o.id = och.opportunity_id
left join opportunity_stats_hires osh on o.id = osh.opportunity_id
left join person_account_managers as pam on och.person_id = pam.person_id
inner join member_evaluations me on oc.interested = me.interested
WHERE true
    and o.objective <> 'Shared by an intermediary'
    and o.review = 'approved'
    and o.reviewed is not null
    
group by o.id
order by o.created desc
LIMIT 10000;