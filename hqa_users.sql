/* AA : SONIC : hqa gg_ids : prod */ 
SELECT
    applications.opportunity_reference_id AS 'Alfa ID',
    applications.gg_id
FROM
    applications 
WHERE
    applications.match_score > 0.85
GROUP BY
    applications.opportunity_reference_id
ORDER BY
    applications.opportunity_reference_id DESC