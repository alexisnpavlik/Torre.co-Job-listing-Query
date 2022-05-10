SELECT
    date(`Member Evaluations`.`interested`) AS `date`,
    `source`.`Tracking Codes__utm_campaign` AS `utm_campaign_syn_mm`,
    count(distinct `source`.`id`) AS `count_mm_syn`
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
    LEFT JOIN `member_evaluations` `Member Evaluations` ON `source`.`id` = `Member Evaluations`.`candidate_id`
WHERE
    (
        `Member Evaluations`.`interested` IS NOT NULL
        AND `Member Evaluations`.`interested` >= date(date_add(now(6), INTERVAL -30 day))
        AND `Member Evaluations`.`interested` < date(date_add(now(6), INTERVAL 1 day))
        AND date(`Member Evaluations`.`interested`) = date(`source`.`interested`)
        AND (
            `source`.`Tracking Codes__utm_campaign` = 'jams'
            OR `source`.`Tracking Codes__utm_campaign` = 'lfrr'
            OR `source`.`Tracking Codes__utm_campaign` = 'mmam'
            OR `source`.`Tracking Codes__utm_campaign` = 'cals'
        )
    )
GROUP BY
    `source`.`Tracking Codes__utm_campaign`,
    date(`Member Evaluations`.`interested`)
ORDER BY
    date(`Member Evaluations`.`interested`) DESC