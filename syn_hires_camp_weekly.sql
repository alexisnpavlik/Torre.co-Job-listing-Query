/* AA : Sonic : weekly syn hires by campaign: prod */ 
SELECT
    str_to_date(concat(yearweek(ooh.hiring_date), ' Sunday'),'%X%V %W') AS 'date',
    tc.utm_campaign AS 'utm_campaign_syn_hires',
    count(distinct ooh.opportunity_candidate_id) AS 'count_hires_syn'
FROM
    opportunity_operational_hires ooh
    LEFT JOIN tracking_code_candidates tcc ON ooh.opportunity_candidate_id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
WHERE
    ooh.hiring_date IS NOT NULL
    AND ooh.hiring_date >= date(date_add(now(6), INTERVAL -60 day))
    AND (
        tc.utm_campaign = 'jams'
        OR tc.utm_campaign = 'lfrr'
        OR tc.utm_campaign = 'mmam'
        OR tc.utm_campaign = 'cals'
    )
    AND ooh.opportunity_id IN (
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
    str_to_date(concat(yearweek(ooh.hiring_date), ' Sunday'),'%X%V %W'),
    tc.utm_campaign