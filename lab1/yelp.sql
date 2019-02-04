-- a)
-- Victor
select user_id, name from user where review_count = (select max(review_count) from user);

-- b)
-- Mon ami Gabi
select business_id, name from business where review_count = (select max(review_count) from business);

-- c)
-- 24.3193
select avg(review_count) from user;

-- d)
-- 66
select COUNT(*) from review join user on review.user_id = user.user_id
left join (select review.user_id as average_user_id, avg(review.stars) as average_reviews from review join user on review.user_id = user.user_id group by review.user_id) as averages
on review.user_id = averages.average_user_id
where ABS(user.average_stars - averages.average_reviews) > 0.5;

-- e)
-- 0.3311
select (select count(*) from user where review_count > 10) / (select count(*) from user);

-- f)
-- 698.7808
select avg(length(text)) from review where user_id in (select user_id from user where review_count > 10);