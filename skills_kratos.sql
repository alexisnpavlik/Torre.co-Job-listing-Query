select id as 'Skill ID',
term as 'Skill Name'

from terms

where true
and status = 'APPROVED'
and type = 'SKILL'