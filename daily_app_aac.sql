/* AA : Sonic : daily app by aac: prod */ 
SELECT
    date(`source`.`interested`) AS `date`,
    `source`.`People_name` AS `AAC_name`,
    count(distinct `source`.`person_id`) AS `count_daily_app`
FROM
    (
        SELECT
            `opportunity_candidates`.`id` AS `id`,
            `opportunity_candidates`.`person_id` AS `person_id`,
            `opportunity_candidates`.`interested` AS `interested`,
            `People`.`name` AS `People_name`,
            `People`.`id`  AS `People_ID`,
            `Opportunities`.`remote` AS `remote`,
            `Opportunities`.`applicant_coordinator_person_id` AS `Opportunities_applicant_coordinator_person_id`
        FROM
            `opportunity_candidates`
            LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates` ON `opportunity_candidates`.`id` = `Tracking Code Candidates`.`candidate_id`
            LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates`.`tracking_code_id` = `Tracking Codes`.`id`
            LEFT JOIN `opportunity_members` `Opportunity Members - Opportunity` ON `opportunity_candidates`.`opportunity_id` = `Opportunity Members - Opportunity`.`opportunity_id`
            LEFT JOIN `person_flags` `Person Flags - Person` ON `Opportunity Members - Opportunity`.`person_id` = `Person Flags - Person`.`person_id`
            LEFT JOIN `opportunities` `Opportunities` ON `opportunity_candidates`.`opportunity_id` = `Opportunities`.`id`
            LEFT JOIN `people` `People` ON (`Opportunities`.`applicant_coordinator_person_id` = `People`.`id`)
    ) `source`
WHERE
    `source`.`remote` = TRUE
    AND `source`.`interested` >= '2022-01-01'
    AND `source`.`interested` < date(date_add(now(6), INTERVAL 1 day))
GROUP BY
    date(`source`.`interested`),
    `source`.`People_name`
ORDER BY
    date(`source`.`interested`) ASC