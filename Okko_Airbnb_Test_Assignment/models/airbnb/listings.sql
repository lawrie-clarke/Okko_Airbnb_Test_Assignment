with listings_union as

(
    select 
        *
    from 
        {{source('airbnb','listings_20240614')}}
    union all
    select 
        *
    from 
        {{source('airbnb','listings_20240906')}}
),

listings_logic as

(
    select 
        id,
        JSON_EXTRACT_ARRAY(amenities) as amenities,
        if(scrape_id = (max(scrape_id) over (order by scrape_id rows between unbounded preceding and unbounded following)),true,false) as is_listing_active,
        format_date('%Y-%m',max(last_scraped) over (order by last_scraped rows between unbounded preceding and unbounded following)) as max_scrape_month,
        last_scraped,
        row_number() over (partition by id order by scrape_id desc) as latest_record_counter,
    from 
        listings_union
)

select
    id,
    amenities,
    is_listing_active,
    max_scrape_month,
    if(is_listing_active = false,format_date('%Y-%m',last_scraped),max_scrape_month) as last_scrape_active_month
from 
    listings_logic
where 
    latest_record_counter = 1