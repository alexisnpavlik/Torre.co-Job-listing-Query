SELECT
    o.id as ID,
    me.send_disqualified_notification = 'True' as 'Disqualified'
   

FROM opportunities as o

join opportunity_candidates as oc on o.id = oc.opportunity_id
inner join member_evaluations me on oc.interested = me.interested

WHERE true
    and o.objective <> 'Shared by an intermediary'
    and o.review = 'approved'
    and o.reviewed is not null
    
group by o.id
order by o.created desc
LIMIT 10000;