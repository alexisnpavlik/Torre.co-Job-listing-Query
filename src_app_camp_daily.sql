/* AA : Sonic : daily src app by campaign: prod */ 
SELECT
    date(`source`.`interested`) AS `date`,
    `source`.`Tracking Codes__utm_campaign` AS `utm_campaign_src_app`,
    count(distinct `source`.`id`) AS `count_app_src`
FROM
    (
        SELECT
            `opportunity_candidates`.`id` AS `id`,
            `opportunity_candidates`.`interested` AS `interested`,
            `Tracking Code Candidates`.`id` AS `Tracking Code Candidates__id`,
            `Tracking Codes`.`utm_campaign` AS `Tracking Codes__utm_campaign`,
            `Tracking Codes`.`utm_medium` AS `Tracking Codes__utm_medium`,
            `Tracking Codes`.`utm_source` AS `Tracking Codes__utm_source`
        FROM
            `opportunity_candidates`
            LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates` ON `opportunity_candidates`.`id` = `Tracking Code Candidates`.`candidate_id`
            LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates`.`tracking_code_id` = `Tracking Codes`.`id`
            LEFT JOIN `opportunity_members` `Opportunity Members - Opportunity` ON `opportunity_candidates`.`opportunity_id` = `Opportunity Members - Opportunity`.`opportunity_id`
            LEFT JOIN `person_flags` `Person Flags - Person` ON `Opportunity Members - Opportunity`.`person_id` = `Person Flags - Person`.`person_id`
            LEFT JOIN `people` `People` ON `opportunity_candidates`.`person_id` = `People`.`id`
            LEFT JOIN `opportunities` `Opportunities` ON `opportunity_candidates`.`opportunity_id` = `Opportunities`.`id`
        WHERE
            (
                `Person Flags - Person`.`opportunity_crawler` = FALSE
                AND `Opportunity Members - Opportunity`.`poster` = TRUE
                AND (
                    NOT (lower(`People`.`username`) like '%test%')
                    OR `People`.`username` IS NULL
                )
                AND `opportunity_candidates`.`retracted` IS NULL
            )
    ) `source`
WHERE
    (
        `source`.`interested` IS NOT NULL
        AND `source`.`interested` >= date(date_add(now(6), INTERVAL -30 day))
        AND `source`.`interested` < date(date_add(now(6), INTERVAL 1 day))
        AND (
            `source`.`Tracking Codes__utm_campaign` = 'lfpa'
            OR `source`.`Tracking Codes__utm_campaign` = 'mmor'
            OR `source`.`Tracking Codes__utm_campaign` = 'smnb'
            OR `source`.`Tracking Codes__utm_campaign` = 'gco'
            OR `source`.`Tracking Codes__utm_campaign` = 'mabv'
            OR `source`.`Tracking Codes__utm_campaign` = 'rrp'
            OR `source`.`Tracking Codes__utm_campaign` = 'mmag'
            OR `source`.`Tracking Codes__utm_campaign` = 'jmmg'
            OR `source`.`Tracking Codes__utm_campaign` = 'dncg'
            OR `source`.`Tracking Codes__utm_campaign` = 'jngd'
            OR `source`.`Tracking Codes__utm_campaign` = 'mfp'
            OR `source`.`Tracking Codes__utm_campaign` = 'admp'
            OR `source`.`Tracking Codes__utm_campaign` = 'kjem'
            OR `source`.`Tracking Codes__utm_campaign` = 'mamg'
            OR `source`.`Tracking Codes__utm_campaign` = 'afdg'
            OR `source`.`Tracking Codes__utm_campaign` = 'xncs'
            OR `source`.`Tracking Codes__utm_campaign` = 'fcc'
            OR `source`.`Tracking Codes__utm_campaign` = 'ana'
            OR `source`.`Tracking Codes__utm_campaign` = 'lfpa_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'mmor_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'smnb_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'gco_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'mabv_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'rrp_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'mmag_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'jmmg_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'dncg_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'jngd_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'mfp_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'admp_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'kjem_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'mamg_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'afdg_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'xncs_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'fcc_ra'
            OR `source`.`Tracking Codes__utm_campaign` = 'ana_ra'
        )
    )
GROUP BY
    date(`source`.`interested`),
    `source`.`Tracking Codes__utm_campaign`
ORDER BY
    date(`source`.`interested`) DESC