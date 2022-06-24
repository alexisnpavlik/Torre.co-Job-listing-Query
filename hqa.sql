/* AA : Sonic : # of HQA/opp: prod */
SELECT
    applications.opportunity_reference_id AS 'Alfa ID',
    count(distinct applications.gg_id) AS 'HQA'
FROM
    applications 
WHERE
    applications.match_score > 0.85
GROUP BY
    applications.opportunity_reference_id