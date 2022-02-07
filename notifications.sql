select
    distinct opportunity_ref as 'Alfa ID',
    count(distinct model = 'realistic') as 'Sent Matches',
    count(distinct model = 'signal_person_all') as 'Sent SigPeop',
    count(distinct model = 'signal_organization_all') as 'Sent SigOrg'
from com_torrelabs_match_distributed_2
group by opportunity_ref;