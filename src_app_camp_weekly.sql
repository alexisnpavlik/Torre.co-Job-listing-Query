SELECT
    str_to_date(concat(yearweek(`source`.`interested`), ' Sunday'),'%X%V %W') AS `date`,
    `source`.`Tracking Codes__utm_campaign` AS `utm_campaign`,
    count(distinct `source`.`id`) AS `count_app`
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
        AND `source`.`interested` >= date(date_add(now(6), INTERVAL -180 day))
        AND `source`.`interested` < date(date_add(now(6), INTERVAL 1 day))
        AND (
            `source`.`Tracking Codes__utm_campaign` = 'admp'
            OR `source`.`Tracking Codes__utm_campaign` = 'mfp'
            OR `source`.`Tracking Codes__utm_campaign` = 'jngd'
            OR `source`.`Tracking Codes__utm_campaign` = 'dncg'
            OR `source`.`Tracking Codes__utm_campaign` = 'jmmg'
            OR `source`.`Tracking Codes__utm_campaign` = 'mmag'
            OR `source`.`Tracking Codes__utm_campaign` = 'rrp'
            OR `source`.`Tracking Codes__utm_campaign` = 'mabv'
            OR `source`.`Tracking Codes__utm_campaign` = 'gco'
            OR `source`.`Tracking Codes__utm_campaign` = 'smnb'
            OR `source`.`Tracking Codes__utm_campaign` = 'mmor'
            OR `source`.`Tracking Codes__utm_campaign` = 'fpa'
        )
    )
GROUP BY
    str_to_date(concat(yearweek(`source`.`interested`), ' Sunday'),'%X%V %W'),
    `source`.`Tracking Codes__utm_campaign`
ORDER BY
    str_to_date(concat(yearweek(`source`.`interested`), ' Sunday'),'%X%V %W') DESC