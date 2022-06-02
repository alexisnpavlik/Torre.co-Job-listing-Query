/* AA : Sonic : autotrigg ext notifications: prod */ 
select oc.opportunity_id as 'ID', count(*) as 'trigg_ext_notifications'
from opportunity_candidates oc
    inner join member_evaluations me on me.candidate_id = oc.id 
    inner join people p on oc.person_id = p.id
where (me.interested is not null 
    and me.not_interested is null
    and me.send_disqualified_notification = false
    and oc.column_id is null
    and oc.application_step is null)
group by 1
    