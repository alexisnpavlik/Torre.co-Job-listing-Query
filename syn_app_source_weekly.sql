/* AA : Sonic : weekly syn app by source: prod */ 
SELECT
    str_to_date(concat(yearweek(`source`.`interested`), ' Sunday'),'%X%V %W') AS `date_syn`,
    `source`.`Tracking Codes__utm_source` AS `utm_source_syn`,
    count(distinct `source`.`id`) AS `count_app_syn`
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
        AND `source`.`interested` >= date(date_add(now(6), INTERVAL -60 day))
        AND `source`.`interested` < date(date_add(now(6), INTERVAL 1 day))
        AND (
            `source`.`Tracking Codes__utm_medium` = 'syn'
            OR `source`.`Tracking Codes__utm_medium` = 'rc_syn'
        )
    )
GROUP BY
    str_to_date(concat(yearweek(`source`.`interested`), ' Sunday'),'%X%V %W'),
    `source`.`Tracking Codes__utm_source`
ORDER BY
    str_to_date(concat(yearweek(`source`.`interested`), ' Sunday'),'%X%V %W') DESC