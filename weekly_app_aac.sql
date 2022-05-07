SELECT
    str_to_date(concat(yearweek(`source`.`interested`), ' Sunday'),'%X%V %W') AS `date`,
    `source`.`People_name` AS `AAC_name`,
    count(distinct `source`.`id`) AS `count_daily_app`
FROM
    (
        SELECT
            `opportunity_candidates`.`id` AS `id`,
            `opportunity_candidates`.`interested` AS `interested`,
            `People`.`name` AS `People_name`,
            `Opportunities`.`remote` AS `remote`,
            `Opportunities`.`applicant_coordinator_person_id` AS `Opportunities_applicant_coordinator_person_id`
        FROM
            `opportunity_candidates`
            LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates` ON `opportunity_candidates`.`id` = `Tracking Code Candidates`.`candidate_id`
            LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates`.`tracking_code_id` = `Tracking Codes`.`id`
            LEFT JOIN `opportunity_members` `Opportunity Members - Opportunity` ON `opportunity_candidates`.`opportunity_id` = `Opportunity Members - Opportunity`.`opportunity_id`
            LEFT JOIN `person_flags` `Person Flags - Person` ON `Opportunity Members - Opportunity`.`person_id` = `Person Flags - Person`.`person_id`
            LEFT JOIN `opportunities` `Opportunities` ON `opportunity_candidates`.`opportunity_id` = `Opportunities`.`id`
            LEFT JOIN `people` `People` ON `Opportunities`.`applicant_coordinator_person_id` = `People`.`id`
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
    `source`.`remote` = TRUE
    AND `source`.`interested` >= date(date_add(now(6), INTERVAL -360 day))
    AND `source`.`interested` < date(date_add(now(6), INTERVAL 1 day))
GROUP BY
    str_to_date(concat(yearweek(`source`.`interested`), ' Sunday'),'%X%V %W'),
    `source`.`People_name`
ORDER BY
    str_to_date(concat(yearweek(`source`.`interested`), ' Sunday'),'%X%V %W') ASC