with listing_type_logic as
(
    select 
        r.id as review_id,
        l.id as listing_id,
        case when '"Hair dryer"' in UNNEST(amenities) and '"Washer"' in UNNEST(amenities) then 'Both Washer and Hair dryer'
             when '"Hair dryer"' in UNNEST(amenities) then 'Hair dryer'
             when '"Washer"' in UNNEST(amenities) then 'Washer' 
             else null end as listing_type
    from 
        {{source('airbnb','reviews')}} r
    left join 
        {{ref('listings')}} l on r.listing_id = l.id
    where 
        date >= '2024-08-01'
    and case when '"Hair dryer"' in UNNEST(amenities) and '"Washer"' in UNNEST(amenities) then 'both'
             when '"Hair dryer"' in UNNEST(amenities) then 'Hair dryer'
             when '"Washer"' in UNNEST(amenities) then 'Washer' 
             else null end is not null    
)

select 
    listing_type, 
    count(*) as count
from 
    listing_type_logic
group by 
    listing_type
order by 
    count(*) desc