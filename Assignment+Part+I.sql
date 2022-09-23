use supply_db ;

/*
Question : Golf related products

List all products in categories related to golf. Display the Product_Id, Product_Name in the output. Sort the output in the order of product id.
Hint: You can identify a Golf category by the name of the category that contains golf.

*/
 select Product_Name, Product_Id 
 from product_info 
 inner join category
 on category.id = product_info.category_id
 where lower(category.name) like "%golf%"
 ;
-- **********************************************************************************************************************************

/*
Question : Most sold golf products

Find the top 10 most sold products (based on sales) in categories related to golf. Display the Product_Name and Sales column in the output. Sort the output in the descending order of sales.
Hint: You can identify a Golf category by the name of the category that contains golf.

HINT:
Use orders, ordered_items, product_info, and category tables from the Supply chain dataset.


*/

with Prod_summ as (
          select Product_Name, Product_Id
         from product_info 
         inner join category
         on category.id = product_info.category_id
         where lower(category.name) like "%golf%"
 ),
 
 item_summ as (
         select item_id, Sales as s, Quantity as q
         from ordered_items
 )
 
select Product_Name, sum(s) as Sales
from Prod_summ
inner join item_summ
on Prod_summ.Product_Id = item_summ.item_id
group by Product_Name
order by Sales desc
limit 10;
-- **********************************************************************************************************************************

/*
Question: Segment wise orders

Find the number of orders by each customer segment for orders. Sort the result from the highest to the lowest 
number of orders.The output table should have the following information:
-Customer_segment
-Orders


*/

 select segment as Customer_segment, count(order_id) as Orders
 from orders
 inner join customer_info
 on orders.customer_id = customer_info.id
 group by Customer_segment
 order by Orders desc;

-- **********************************************************************************************************************************
/*
Question : Percentage of order split

Description: Find the percentage of split of orders by each customer segment for orders that took six days 
to ship (based on Real_Shipping_Days). Sort the result from the highest to the lowest percentage of split orders,
rounding off to one decimal place. The output table should have the following information:
-Customer_segment
-Percentage_order_split

HINT:
Use the orders and customer_info tables from the Supply chain dataset.


*/
with summ as (
 select segment as Customer_segment, 
        Real_Shipping_Days
 from orders
 inner join customer_info
 on orders.customer_id = customer_info.id
 where Real_Shipping_Days = 6
 )
 select Customer_segment, 
        round((count(Real_Shipping_Days)/(select count(*)
											 from orders
											 inner join customer_info
											 on orders.customer_id = customer_info.id
											 where Real_Shipping_Days = 6)
									      )*100,1) as Percentage_order_split
 from summ
 group by Customer_segment
 order by Percentage_order_split desc
 ;
-- **********************************************************************************************************************************

 
  