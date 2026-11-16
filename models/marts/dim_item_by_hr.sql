with int_item_hours as (
    select * from {{ ref('int_item_hours') }}
)

select 
    sku,
    hr,
    product_name,
    product_type,
    product_descr,
    
from int_item_hours