select 
    id as listing_id,
    amenities_unnested as amenities 
from {{ref('listings')}},
     unnest(amenities) amenities_unnested
where 
    is_listing_active is true
