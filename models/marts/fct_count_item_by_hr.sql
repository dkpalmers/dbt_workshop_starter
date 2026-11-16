with int_item_hours as (
    select * from {{ ref('int_item_hours') }}
)

select 
    int_item_hours.sku as sku,
    int_item_hours.hr as hr,
    count(*) as total_items_sold,
    sum(int_item_hours.order_subtotal) as total_revenue
from int_item_hours
group by hr, sku