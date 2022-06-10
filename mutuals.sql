/* AA : SONIC : mm by oppid : prod */ 
SELECT
    `source`.`opportunity_id` AS `ID`,
    `source`.`Tracking Codes__utm_medium` AS `UTM`,
    count(distinct `source`.`id`) AS `mutuals`
FROM
    (
        SELECT
            `opportunity_candidates`.`id` AS `id`,
            `opportunity_candidates`.`interested` AS `interested`,
            `opportunity_candidates`.`opportunity_id` AS `opportunity_id`,
            `Tracking Codes`.`utm_medium` AS `Tracking Codes__utm_medium`,
            `Opportunities`.`remote` AS `Opportunities__remote`,
            `Opportunities`.`fulfillment` AS `Opportunities__fulfillment`
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
        AND `Member Evaluations`.`interested` > "2021-1-1"
        AND `Member Evaluations`.`interested` < date(date_add(now(6), INTERVAL 1 day))
        AND date(`Member Evaluations`.`interested`) = date(`source`.`interested`)
    )
GROUP BY
    `source`.`Tracking Codes__utm_medium`,
    `source`.`opportunity_id`