SELECT
    o.id as ID_3,
    me.send_disqualified_notification  as 'data',
    me.interested as 'fecha1',
    oc.interested as 'fecha2',
    (case when me.interested is not null and oc.interested is not null then 1 else 0 end) as 'Match'
   

FROM opportunities as o

join opportunity_candidates as oc on o.id = oc.opportunity_id
join member_evaluations as me on oc.id = me.member_id

WHERE me.send_disqualified_notification = true
   
    and o.objective <> 'Shared by an intermediary'
    and o.review = 'approved'
    and o.reviewed is not null
    
    
    
group by o.id
order by o.created desc
LIMIT 10000;