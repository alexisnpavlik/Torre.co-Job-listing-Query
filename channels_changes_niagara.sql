/* AA : Sonic : Niagara channels changes : prod */ 
SELECT
    opportunity_channels.opportunity_reference_id AS 'Alfa ID',
    opportunity_channels.channel,
    opportunity_channels.source,
    opportunity_channels.active,
    opportunity_channels.created,
    opportunity_channels.modified
FROM
   opportunity_channels