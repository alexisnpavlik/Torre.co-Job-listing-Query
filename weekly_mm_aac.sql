/* AA : Sonic : weekly mm by aac: prod */ 
SELECT
    str_to_date(concat(yearweek(occh.created), ' Sunday'),'%X%V %W') AS date,
    p.name AS AAC_name,
    count(distinct occh.candidate_id) AS count_weekly_mm
FROM
    opportunity_candidate_column_history occh
    INNER JOIN opportunity_columns oc ON occh.to = oc.id
    INNER JOIN opportunities o ON oc.opportunity_id = o.id
    LEFT JOIN opportunity_candidates oca ON occh.candidate_id = oca.id
    LEFT JOIN people p ON o.applicant_coordinator_person_id = p.id
WHERE
    oc.name = 'mutual matches'
    AND occh.created >= '2022-01-01'
    AND oca.interested IS NOT NULL 
    AND o.objective NOT LIKE '**%'
    AND o.id IN (
        SELECT
            DISTINCT o.id AS opportunity_id
        FROM
            opportunities o
            INNER JOIN opportunity_members omp ON omp.opportunity_id = o.id
            AND omp.poster = TRUE
            INNER JOIN person_flags pf ON pf.person_id = omp.person_id
            AND pf.opportunity_crawler = FALSE
        WHERE
            o.reviewed >= '2021/01/01'
            AND o.objective NOT LIKE '**%'
            AND o.review = 'approved'
    )
GROUP BY
    str_to_date(concat(yearweek(occh.created), ' Sunday'),'%X%V %W'),
    p.name