SELECT
    o.id as ID,
    oc2.name as Channel,
    sum(case when oc.id is not null and oc.interested is not null and (last_evaluation.last_not_interest is not null and (last_evaluation.last_interest is null or last_evaluation.last_interest < last_evaluation.last_not_interest)) then 1 else 0 end) as Disqualified,
    (select Reason from opportunity_changes_history as och where true and type = 'close' and Reason is not null and o.id = och.opportunity_id order by och.created desc limit 1) as Reason
FROM opportunities o
LEFT JOIN opportunity_candidates oc on o.id=oc.opportunity_id
LEFT JOIN opportunity_columns oc2 on oc.column_id = oc2.id
LEFT JOIN (
  select me.candidate_id, max(me.interested) as last_interest, max(me.not_interested) as last_not_interest
  from member_evaluations me
  group by me.candidate_id) last_evaluation on last_evaluation.candidate_id = oc.id
WHERE oc.interested is not null
group by ID, Channel
order by ID desc