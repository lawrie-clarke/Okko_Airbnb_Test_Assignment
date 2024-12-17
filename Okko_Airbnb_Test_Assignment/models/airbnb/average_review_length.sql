with review_lengths as
(
    select  id,
            reviewer_id,
            date,
            rank() over (partition by reviewer_id order by date,id asc) as review_number, --basing off date and then id for ties
            length(comments) as length_review
    from {{source('airbnb','reviews')}}
    where reviewer_id in (select reviewer_id from {{source('airbnb','reviews')}} group by reviewer_id having count(*) >= 4)
)

select round(avg(length_review),2) as avg_review_length
from review_lengths