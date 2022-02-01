select
  o.created,
  o.id,
  o.objective,
  sum(case when oc.id is not null and oc.interested is null and application_step is not null then 1 else 0 end) as 'unfinished applications',
  sum(case when oc.id is not null and oc.interested is not null then 1 else 0 end) as 'completed applications',
  sum(case when oc.id is not null and oc.interested is null and application_step is null and oc.column_id is null
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'invited (not interested yet)',
  sum(case when oc.id is not null and oc.interested is not null and oc.column_id is null
    and (last_evaluation.last_interest is null and last_evaluation.last_not_interest is null) then 1 else 0 end)
    as 'potential matches',
  sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and oc2.name = 'mutual matches'
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'mutual matches',
  sum(case when oc.id is not null and oc.interested is not null and oc.column_id is not null
    and oc2.name <> 'mutual matches'
    and (last_evaluation.last_interest is not null and (last_evaluation.last_not_interest is null or last_evaluation.last_interest > last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'matched candidates in other columns',
  sum(case when oc.id is not null and oc.interested is not null
    and (last_evaluation.last_not_interest is not null and (last_evaluation.last_interest is null or last_evaluation.last_interest < last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'interested disqualified',
  sum(case when oc.id is not null and oc.interested is null
    and (last_evaluation.last_not_interest is not null and (last_evaluation.last_interest is null or last_evaluation.last_interest < last_evaluation.last_not_interest)) then 1 else 0 end)
    as 'not-interested disqualified',
  p.username as poster,
  (select group_concat(org.organization_id) from opportunity_organizations org where org.opportunity_id = o.id and org.active = 1) as organizations,
  o.review,
  o.remote,
  o.status,
  (case o.published when true then 'POSTED' else 'DRAFT' end) as published,
  (select group_concat(l.location) from opportunity_places l where l.opportunity_id = o.id and l.active = 1) as location,
  o.external_application_url
from (
SELECT o.*
FROM opportunities o
WHERE o.`objective` NOT LIKE '***%'

  AND review = 'approved'
  AND o.`active`
  AND NOT o.`id` IN (
    SELECT o2.`id`
    FROM opportunities o2
    JOIN opportunity_members om ON o2.`id` = om.`opportunity_id`
    JOIN people p on om.`person_id` = p.`id`
    JOIN person_flags pf on p.`id` = pf.`person_id`
    WHERE om.`person_id` IN (
      82,     -- Juan Camilo Gomez
      2629    -- Torre Bot
    )
    OR (
      om.`person_id` NOT IN (SELECT `id` FROM metrics_people)
      AND om.`poster`
    )
    OR (
      om.`person_id` IN (
        16376,  -- David Velásquez Martínez
        25596   -- David Mauricio Castro Fandiño
      )
      AND om.`member`
    )
    OR (pf.opportunity_crawler AND om.poster)
    OR o2.review = 'rejected'
  )
) o
left join opportunity_candidates oc on o.id = oc.opportunity_id
left join opportunity_columns oc2 on oc.column_id = oc2.id
left join (
  select me.candidate_id, max(me.interested) as last_interest, max(me.not_interested) as last_not_interest
  from member_evaluations me
  group by me.candidate_id
) last_evaluation on last_evaluation.candidate_id = oc.id
join opportunity_members om on o.id = om.opportunity_id and om.poster
join people p on om.person_id = p.id
join person_flags pf on p.id = pf.person_id
where true
[[and p.username = {{posterUsername}}]]
and objective <> 'Shared by an intermediary'
[[ and objective like {{objective}}]]
[[ and o.id like {{id}}]]
group by o.id
order by o.created desc;