with products as (
    select * from {{ ref('stg_jaffle_shop__raw_products') }}
),

items as (
    select * from {{ ref('stg_jaffle_shop__raw_items') }}
),

orders as (
    select * from {{ ref('stg_jaffle_shop__raw_orders') }}
)

select
    products.sku as sku,
    products.product_name as product_name,
    products.product_type as product_type,
    products.product_price as product_price,
    products.product_description as product_descr,
    items.item_id as item_id,
    -- items.order_id,
    orders.ordered_at as ordered_at,
    orders.ordered_date as ordered_date,
    orders.order_subtotal as order_subtotal,
    
    extract(hour from orders.ordered_at) as hr

from products
join items on products.sku = items.sku
join orders on items.order_id = orders.order_id
