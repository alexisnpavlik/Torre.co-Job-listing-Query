SELECT
    `opportunity_stats_hires`.`hiring_date` AS `date`,
    `people`.`name` AS `AAC`,
    count(distinct `opportunity_stats_hires`.`opportunity_id`) AS `opps_hire_weekly_remote7days`
FROM
    `opportunity_stats_hires`
    LEFT JOIN `opportunities` `Opportunities` ON `opportunity_stats_hires`.`opportunity_id` = `Opportunities`.`id`
    LEFT JOIN `people` ON `Opportunities`.`applicant_coordinator_person_id` = `people`.`id`
WHERE
    (
        `opportunity_stats_hires`.`hiring_date` > "2021-7-18"
        AND `opportunity_stats_hires`.`hiring_date` < date(now(6))
        AND datediff(
            date(`opportunity_stats_hires`.`hiring_date`),
            date(`Opportunities`.`reviewed`)
        ) <= 7
        AND `Opportunities`.`remote` = TRUE
    )
GROUP BY
    `opportunity_stats_hires`.`hiring_date`
ORDER BY
    `opportunity_stats_hires`.`hiring_date` ASC