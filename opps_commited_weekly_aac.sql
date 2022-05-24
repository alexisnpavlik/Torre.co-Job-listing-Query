SELECT
    str_to_date(concat(yearweek(`opportunities__via__opportunit`.`reviewed`),'Sunday'),'%X%V %W') AS `date`,
    `people`.`name` AS `AAC`,
    count(distinct `opportunity_changes_history`.`opportunity_id`) AS `opps_commited_weekly_remote`
FROM
    `opportunity_changes_history`
    LEFT JOIN `opportunities` `opportunities__via__opportunit` ON `opportunity_changes_history`.`opportunity_id` = `opportunities__via__opportunit`.`id`
    LEFT JOIN `people` ON `opportunities__via__opportunit`.`applicant_coordinator_person_id`= `people`.`id`
WHERE
    (
        (
            `opportunity_changes_history`.`type` = 'outbound'
            AND `opportunity_changes_history`.`value` = false
        )
        AND `opportunities__via__opportunit`.`reviewed` > "2021-7-18"
        AND `opportunities__via__opportunit`.`reviewed` < date(now(6))
        AND `opportunities__via__opportunit`.`remote` = TRUE
    )
GROUP BY
    str_to_date(concat(yearweek(`opportunities__via__opportunit`.`reviewed`),'Sunday'),'%X%V %W'),
    `people`.`name`
ORDER BY
    str_to_date(concat(yearweek(`opportunities__via__opportunit`.`reviewed`),'Sunday'),'%X%V %W') ASC