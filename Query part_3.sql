SELECT
    o.id as ID_3,
    (select me.send_disqualified_notification from member_evaluations as me where me.send_disqualified_notification = 'True' ) as 'Disqualified',
    (select me.interested from member_evaluations as me where me.interested = oc.interested ) as 'MatchDate'
   

FROM opportunities as o

join opportunity_candidates as oc on o.id = oc.opportunity_id


WHERE true
    and o.objective <> 'Shared by an intermediary'
    and o.review = 'approved'
    and o.reviewed is not null
    
group by o.id
order by o.created desc
LIMIT 10000;