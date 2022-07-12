/* AA : Sonic : SQ disqualified: prod */
SELECT
    `opportunity_candidates`.`id` AS `candidate_id`,
    `People`.`name` AS `People__name`,
    `People`.`username` AS `People__username`,
    `opportunity_candidates`.`opportunity_id` AS `Opportunity ID`,
    max(`member_evaluations`.`not_interested`) AS `not_interested`,
    max(`member_evaluations`.`reason`) AS `reason`,
    `Opportunity Questions - Opportunity`.`question_id` AS `question_id`,
    max(`Opportunity Questions - Opportunity`.`rank`) AS `rank`,
    `opportunity_candidate_responses`.`id` AS `answer_id`,
    `Questions`.`purpose` AS `Questions_purpose`,
    `Questions`.`title` AS `Questions_title`,
    `Questions`.`type` AS `Questions_type`,
    `Questions`.`locale` AS `Questions_locale`,
    `Comments`.`text` AS `Notes`
FROM
    `opportunity_candidates`
    INNER JOIN `opportunity_questions` `Opportunity Questions - Opportunity` ON `opportunity_candidates`.`opportunity_id` = `Opportunity Questions - Opportunity`.`opportunity_id` AND `Opportunity Questions - Opportunity`.`active` IS TRUE
    LEFT JOIN  `member_evaluations` ON `member_evaluations`.`candidate_id` = `opportunity_candidates`.`id`
    LEFT JOIN `questions` `Questions` ON `Opportunity Questions - Opportunity`.`question_id` = `Questions`.`id`
    LEFT JOIN `opportunity_candidate_responses` `Opportunity Candidate Responses - Question` ON (`opportunity_candidates`.`id` = `Opportunity Candidate Responses - Question`.`candidate_id` AND `Opportunity Questions - Opportunity`.`question_id` = `Opportunity Candidate Responses - Question`.`question_id`) AND `Opportunity Candidate Responses - Question`.`active` IS TRUE
    LEFT JOIN `question_options` `Question Options` ON (`Opportunity Candidate Responses - Question`.`question_option_id` = `Question Options`.`id` AND `Opportunity Candidate Responses - Question`.`question_id` = `Question Options`.`question_id`)
    LEFT JOIN `opportunity_candidate_responses` ON (`opportunity_candidates`.`id` = `opportunity_candidate_responses`.`candidate_id` AND `Opportunity Questions - Opportunity`.`question_id` = `opportunity_candidate_responses`.`question_id`) AND `opportunity_candidate_responses`.`active` IS TRUE
    LEFT JOIN `tracking_code_candidates` `Tracking Code Candidates - Candidate` ON `member_evaluations`.`candidate_id` = `Tracking Code Candidates - Candidate`.`candidate_id`
    LEFT JOIN `tracking_codes` `Tracking Codes` ON `Tracking Code Candidates - Candidate`.`tracking_code_id` = `Tracking Codes`.`id`
    LEFT JOIN `people` `People` ON `opportunity_candidates`.`person_id` = `People`.`id`
    LEFT JOIN `comments` `Comments` ON `People`.`id` = `Comments`.`candidate_person_id` AND `opportunity_candidates`.`opportunity_id` = `Comments`.`opportunity_id`
WHERE
    (
        `Questions`.`purpose` = 'filter'
        AND `opportunity_candidate_responses`.`id` IS NOT NULL
        AND `member_evaluations`.`not_interested` IS NOT NULL
        AND `member_evaluations`.`reason`= 'screening-questions' 
    )
GROUP BY
    `opportunity_candidates`.`id`,
    `opportunity_candidates`.`opportunity_id`
ORDER by
    `Opportunity ID` asc