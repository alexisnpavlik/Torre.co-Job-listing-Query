/* AA : Sonic : SQ disqualified: prod */ 
SELECT
    `opportunity_candidates`.`id` AS `candidate_id`,
    `opportunity_candidates`.`opportunity_id` AS `Opportunity ID`,
    `Opportunity Questions - Opportunity`.`question_id` AS `question_id`,
    `Questions`.`purpose` AS `Questions_purpose`,
    `Questions`.`title` AS `Questions_title`,
    `Questions`.`type` AS `Questions_type`,
    `Questions`.`locale` AS `Questions_locale`
FROM
    `opportunity_candidates`
    INNER JOIN `opportunity_questions` `Opportunity Questions - Opportunity` ON `opportunity_candidates`.`opportunity_id` = `Opportunity Questions - Opportunity`.`opportunity_id` AND `Opportunity Questions - Opportunity`.`active` IS TRUE
    LEFT JOIN `questions` `Questions` ON `Opportunity Questions - Opportunity`.`question_id` = `Questions`.`id`
    LEFT JOIN `opportunity_candidate_responses` `Opportunity Candidate Responses - Question` ON (
        `opportunity_candidates`.`id` = `Opportunity Candidate Responses - Question`.`candidate_id`
        AND `Opportunity Questions - Opportunity`.`question_id` = `Opportunity Candidate Responses - Question`.`question_id`
    ) AND `Opportunity Candidate Responses - Question`.`active` IS TRUE
    LEFT JOIN `question_options` `Question Options` ON (
        `Opportunity Candidate Responses - Question`.`question_option_id` = `Question Options`.`id`
        AND `Opportunity Candidate Responses - Question`.`question_id` = `Question Options`.`question_id`
    )
WHERE
    (
        `Questions`.`purpose` = 'filter'
    )
ORDER by `Opportunity ID` asc