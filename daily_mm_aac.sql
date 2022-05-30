SELECT
    date(`source`.`mm_interested`) AS `date`,
    `source`.`People_name` AS `AAC_daily`,
    count(distinct `source`.`person_id`) AS `count_daily_mm`
FROM
    (
        SELECT
            `opportunity_candidates`.`id` AS `id`,
            `opportunity_candidates`.`person_id` AS `person_id`,
            `opportunity_candidates`.`interested` AS `interested`,
            `Member Evaluations`.`interested` AS `mm_interested`,
            `People`.`name` AS `People_name`,
            `Opportunities`.`remote` AS `remote`
        FROM
            `opportunity_candidates`
            LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates` ON `opportunity_candidates`.`id` = `Tracking Code Candidates`.`candidate_id`
            LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates`.`tracking_code_id` = `Tracking Codes`.`id`
            LEFT JOIN `opportunity_members` `Opportunity Members - Opportunity` ON `opportunity_candidates`.`opportunity_id` = `Opportunity Members - Opportunity`.`opportunity_id`
            LEFT JOIN `person_flags` `Person Flags - Person` ON `Opportunity Members - Opportunity`.`person_id` = `Person Flags - Person`.`person_id`
            LEFT JOIN `opportunities` `Opportunities` ON `opportunity_candidates`.`opportunity_id` = `Opportunities`.`id`
            LEFT JOIN `people` `People` ON `Opportunities`.`applicant_coordinator_person_id` = `People`.`id`
            LEFT JOIN `member_evaluations` `Member Evaluations` ON `opportunity_candidates`.`id` = `Member Evaluations`.`candidate_id`
    ) `source`
WHERE
    (
        `source`.`interested` IS NOT NULL
        AND `source`.`remote` = TRUE
        AND `source`.`interested` >= date(date_add(now(6), INTERVAL -360 day))
        AND `source`.`interested` < date(date_add(now(6), INTERVAL 1 day))
        AND date(`source`.`mm_interested`) = date(`source`.`interested`)
    )
GROUP BY
    date(`source`.`mm_interested`),
    `source`.`People_name`
ORDER BY
    date(`source`.`mm_interested`) ASC