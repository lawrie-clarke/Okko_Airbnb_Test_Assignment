select 
    count(*) as inactive_listings_count
from 
    {{ref('listings')}}
where 
    is_listing_active is false