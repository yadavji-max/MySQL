use supply_db ;

/*  Question: Month-wise NIKE sales

	Description:
		Find the combined month-wise sales and quantities sold for all the Nike products. 
        The months should be formatted as ‘YYYY-MM’ (for example, ‘2019-01’ for January 2019). 
        Sort the output based on the month column (from the oldest to newest). The output should have following columns :
			-Month
			-Quantities_sold
			-Sales
		HINT:
			Use orders, ordered_items, and product_info tables from the Supply chain dataset.
*/		

with summ as (
 select quantity, sales, orders.order_id as ood, order_date, date_format(order_date, '%Y-%m') as Month
 from product_info
     inner join ordered_items
        on product_info.product_id = ordered_items.item_id
     inner join orders 
        on orders.order_id = ordered_items.order_id
 where lower(product_name) like "%nike%"
 order by order_date
 )
 select Month, sum(quantity) as Quantities_sold, sum(sales) as Sales
 from summ
 group by Month
;

-- **********************************************************************************************************************************
/*

Question : Costliest products

Description: What are the top five costliest products in the catalogue? Provide the following information/details:
-Product_Id
-Product_Name
-Category_Name
-Department_Name
-Product_Price

Sort the result in the descending order of the Product_Price.

HINT:
Use product_info, category, and department tables from the Supply chain dataset.


*/

 select Product_Id, 
        Product_Name, 
        category.name as Category_Name,
        department.name as Department_Name,
        Product_Price
from product_info
    inner join department 
        on department.id = product_info.department_id 
    inner join category 
        on category.id = product_info.category_id 
order by Product_Price desc
limit 5;

-- **********************************************************************************************************************************

/*

Question : Cash customers

Description: Identify the top 10 most ordered items based on sales from all the ‘CASH’ type orders. 
Provide the Product Name, Sales, and Distinct Order count for these items. Sort the table in descending
order of Order counts and for the cases where the order count is the same, sort based on sales (highest to
lowest) within that group.
 
HINT: Use orders, ordered_items, and product_info tables from the Supply chain dataset.


*/
with summ as (
		select 
        Product_Name, 
        category_id,
        sum(Sales) as Sales, 
        ordered_items.order_id as iid, 
        orders.order_id as oid,
 		count(orders.order_id) as Distinct_Order_count
from orders
            
			inner join ordered_items 
			on ordered_items.order_id = orders.order_id
			inner join product_info 
			on ordered_items.item_id = product_info.product_id
            
where lower(orders.type) like "%cash%"
group by Product_Name
order by Sales desc
)
select 
        Product_Name, 
        Sales,
        Distinct_Order_count
from summ
limit 10
;

-- **********************************************************************************************************************************
/*
Question : Customers from texas

Obtain all the details from the Orders table (all columns) for customer orders in the state of Texas (TX),
whose street address contains the word ‘Plaza’ but not the word ‘Mountain’. The output should be sorted by the Order_Id.

HINT: Use orders and customer_info tables from the Supply chain dataset.

*/

select orders.* 
from orders
	inner join customer_info
		on orders.customer_id = customer_info.id
where state = "TX" and lower(street) like '%plaza%' and lower(street) not like '%mountain%'
order by order_id;


-- **********************************************************************************************************************************
/*
 
Question: Home office

For all the orders of the customers belonging to “Home Office” Segment and have ordered items belonging to
“Apparel” or “Outdoors” departments. Compute the total count of such orders. The final output should contain the 
following columns:
-Order_Count

*/

select count(orders.order_id) as Order_Count 
from orders
	inner join ordered_items
		on orders.order_id = ordered_items.order_id
	inner join product_info 
		on product_info.product_id = ordered_items.item_id
	inner join department
		on product_info.department_id = id
	inner join customer_info
		on customer_info.id = orders.customer_Id
where (lower(department.name) like '%outdoors%'  || lower(department.name) like '%apparel%') && lower(customer_info.segment) like '%home%office%';
 
-- **********************************************************************************************************************************
/*

Question : Within state ranking
 
For all the orders of the customers belonging to “Home Office” Segment and have ordered items belonging
to “Apparel” or “Outdoors” departments. Compute the count of orders for all combinations of Order_State and Order_City. 
Rank each Order_City within each Order State based on the descending order of their order count (use dense_rank). 
The states should be ordered alphabetically, and Order_Cities within each state should be ordered based on their rank. 
If there is a clash in the city ranking, in such cases, it must be ordered alphabetically based on the city name. 
The final output should contain the following columns:
-Order_State
-Order_City
-Order_Count
-City_rank

HINT: Use orders, ordered_items, product_info, customer_info, and department tables from the Supply chain dataset.

*/

select Order_State, Order_City, count(orders.order_id)  as Order_Count, dense_rank() over(partition by Order_City order by count(orders.order_id)) as City_rank
from orders
	inner join ordered_items
		on orders.order_id = ordered_items.order_id
	inner join product_info 
		on product_info.product_id = ordered_items.item_id
	inner join department
		on product_info.department_id = id
	inner join customer_info
		on customer_info.id = orders.customer_Id
where (lower(department.name) like '%outdoors%'  || lower(department.name) like '%apparel%') && lower(customer_info.segment) like '%home%office%'
group by Order_State, Order_City
order by  Order_Count desc, Order_State, City_rank, Order_City;

-- **********************************************************************************************************************************
/*
Question : Underestimated orders

Rank (using row_number so that irrespective of the duplicates, so you obtain a unique ranking) the 
shipping mode for each year, based on the number of orders when the shipping days were underestimated 
(i.e., Scheduled_Shipping_Days < Real_Shipping_Days). The shipping mode with the highest orders that meet 
the required criteria should appear first. Consider only ‘COMPLETE’ and ‘CLOSED’ orders and those belonging to 
the customer segment: ‘Consumer’. The final output should contain the following columns:
-Shipping_Mode,
-Shipping_Underestimated_Order_Count,
-Shipping_Mode_Rank

HINT: Use orders and customer_info tables from the Supply chain dataset.


*/

-- **********************************************************************************************************************************





