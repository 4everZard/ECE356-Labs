-- Part 2
-- a = Victor
SELECT name, user_id FROM user WHERE review_count = (SELECT max(review_count) FROM user);

-- b = Mon ami Gabi
SELECT name, business_id  FROM business WHERE review_count = (SELECT max(review_count) FROM business);

-- c = 24.3193
SELECT avg(review_count) FROM user;

-- d = 66
SELECT count(*) FROM user LEFT JOIN 
(SELECT user_id, avg(stars) as average_stars FROM review GROUP BY user_id) AS average_review 
ON average_review.user_id = user.user_id 
WHERE ABS(user.average_stars - average_review.avg_str) > 0.5;


-- e = 0.3311
SELECT
(SELECT count(*) FROM user WHERE review_count > 10) / 
(SELECT count(*) FROM user);

-- f = 698.7808
 SELECT avg(length(text)) FROM review WHERE user_id IN 
 (SELECT user_id FROM user WHERE review_count > 10);
