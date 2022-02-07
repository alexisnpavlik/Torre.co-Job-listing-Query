select
    distinct opportunity_ref as AlfaID,
    count(distinct model = 'realistic') as realistic,
    count(distinct model = 'signal_person_all') as person,
    count(distinct model = 'signal_organization_all') as organization
    
from com_torrelabs_match_distributed_2

group by AlfaID;