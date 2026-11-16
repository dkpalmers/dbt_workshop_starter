with dim_item_by_hr as (
    select distinct
        sku,
        hr,
        product_name,
        product_type,
        product_descr
    from {{ ref('dim_item_by_hr') }}
),

fct_count_item_by_hr as (
    select * from {{ ref('fct_count_item_by_hr') }}
),

sku_sales_by_hr as (
    select
        sku,
        hr,
        sum(total_items_sold) as total_items_sold,
        sum(total_revenue) as total_revenue
    from fct_count_item_by_hr
    group by sku, hr
),

ranked_skus as (
    select
        sku_sales_by_hr.sku,
        sku_sales_by_hr.hr,
        dim_item_by_hr.product_name,
        dim_item_by_hr.product_type,
        dim_item_by_hr.product_descr,
        sku_sales_by_hr.total_items_sold,
        sku_sales_by_hr.total_revenue,
        rank() over (
            partition by sku_sales_by_hr.hr, dim_item_by_hr.product_type
            order by sku_sales_by_hr.total_items_sold desc
        ) as sales_rank
    from sku_sales_by_hr
    join dim_item_by_hr
        on sku_sales_by_hr.sku = dim_item_by_hr.sku
        and sku_sales_by_hr.hr = dim_item_by_hr.hr
)

select
    sku,
    hr,
    product_name,
    product_type,
    product_descr,
    total_items_sold,
    total_revenue
from ranked_skus
where sales_rank = 1
order by product_type, cast(hr as integer)