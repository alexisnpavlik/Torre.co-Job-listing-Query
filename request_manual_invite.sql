select
   opportunity_id as AlfaID,
   sum(case when status = 'sent' then 1 else 0 end) as sent,
   sum(case when status = 'pending' then 1 else 0 end) as pending
from
   career_advisor_suggested_opportunities 
group by AlfaID