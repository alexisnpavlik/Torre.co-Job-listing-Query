/* AA : Sonic : weekly src hires by campaign: prod */ 
SELECT
    str_to_date(concat(yearweek(ooh.hiring_date), ' Sunday'),'%X%V %W') AS 'date',
    tc.utm_campaign AS 'utm_campaign_src_hires',
    count(distinct ooh.opportunity_candidate_id) AS 'count_hires_src'
FROM
    opportunity_operational_hires ooh
    LEFT JOIN tracking_code_candidates tcc ON ooh.opportunity_candidate_id = tcc.candidate_id
    LEFT JOIN tracking_codes tc ON tcc.tracking_code_id = tc.id
WHERE
    ooh.hiring_date IS NOT NULL
    AND ooh.hiring_date >= date(date_add(now(6), INTERVAL -60 day))
    AND (
        tc.utm_campaign = 'lfpa'
        OR tc.utm_campaign = 'mmor'
        OR tc.utm_campaign = 'smnb'
        OR tc.utm_campaign = 'gco'
        OR tc.utm_campaign = 'mabv'
        OR tc.utm_campaign = 'rrp'
        OR tc.utm_campaign = 'mmag'
        OR tc.utm_campaign = 'jmmg'
        OR tc.utm_campaign = 'dncg'
        OR tc.utm_campaign = 'jngd'
        OR tc.utm_campaign = 'mfp'
        OR tc.utm_campaign = 'admp'
        OR tc.utm_campaign = 'kjem'
        OR tc.utm_campaign = 'mamg'
        OR tc.utm_campaign = 'afdg'
        OR tc.utm_campaign = 'xncs'
        OR tc.utm_campaign = 'fcc'
        OR tc.utm_campaign = 'ana'
        OR tc.utm_campaign = 'erg'
        OR tc.utm_campaign = 'lfpa_ra'
        OR tc.utm_campaign = 'mmor_ra'
        OR tc.utm_campaign = 'smnb_ra'
        OR tc.utm_campaign = 'gco_ra'
        OR tc.utm_campaign = 'mabv_ra'
        OR tc.utm_campaign = 'rrp_ra'
        OR tc.utm_campaign = 'mmag_ra'
        OR tc.utm_campaign = 'jmmg_ra'
        OR tc.utm_campaign = 'dncg_ra'
        OR tc.utm_campaign = 'jngd_ra'
        OR tc.utm_campaign = 'mfp_ra'
        OR tc.utm_campaign = 'admp_ra'
        OR tc.utm_campaign = 'kjem_ra'
        OR tc.utm_campaign = 'mamg_ra'
        OR tc.utm_campaign = 'afdg_ra'
        OR tc.utm_campaign = 'xncs_ra'
        OR tc.utm_campaign = 'fcc_ra'
        OR tc.utm_campaign = 'ana_ra'
        OR tc.utm_campaign = 'erg_ra'
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