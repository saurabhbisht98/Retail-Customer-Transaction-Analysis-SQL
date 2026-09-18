---------------------------- DATA PREPARATIONS AND UNDERSTANDING -------------------------


-----Q1  What is the total Number of rows in each of the 3 table in the database?
  select count(*) as Total_number_of_rows  from customer 
  union
  select count(*) as Total_number_of_rows  from prod_cat_info
  union
  select count(*) as Total_number_of_rows  from Transactions



----Q2 what is the total number of transactions that have a return?
select count (distinct(transaction_id)) as total_trans from Transactions
where Qty < 0 

---Q3 As you would have noticed, the dates provided across the datasets are not in a correct format. 
---As first steps, pls convert the date variables into valid date fromats before proceeding ahead.
select * from Transactions
 select CONVERT (date,tran_date,105) as tran_date from Transactions


----4. What is the time range of the transaction data available for analysis? Show the
---output in number of days, months and years simultaneously in different columns.

select DATEDIFF(YEAR ,MIN( CONVERT (date,tran_date,105)), MAX( CONVERT (date,tran_date,105))) as diffrance_year,
DATEDIFF(MONTH ,MIN( CONVERT (date,tran_date,105)), MAX( CONVERT (date,tran_date,105))) as diffrance_month ,
DATEDIFF(DAY ,MIN( CONVERT (date,tran_date,105)), MAX( CONVERT (date,tran_date,105))) as diffrance_days
from Transactions

SELECT * from prod_cat_info
----5. Which product category does the sub-category "DIY" belong to?
select prod_cat,prod_subcat from prod_cat_info 
where prod_subcat = 'DIY'


--------------------------------------------------DATA ANALYSIS------------------------------------------------
----1. Which channel is most frequently used for transactions?

select top 1  store_type ,count (*) as cnt from  Transactions
group by store_type 
order by cnt desc


----2. What is the count of Male and Female customers in the database?
select  * from  Customer
select Gender, count(*)  as  count_of_gender from Customer
where Gender is not null
group by Gender

----3. From which city do we have the maximum number of customers and how many?
select  top 1 city_code,count(*)as count_of_city from Customer
where city_code is not null
group by city_code
order by count_of_city desc


----4. How many sub-categories are there under the Books category?

select * from prod_cat_info
select prod_cat,prod_subcat from prod_cat_info
where prod_cat = 'Books'

----5. What is the maximum quantity of products ever ordered?
select prod_cat_code, max(Qty) as max_qty from Transactions 
group by prod_cat_code


----6. What is the net total revenue generated in categories Electronics and Books?
select top 1 * from Transactions
select  top 1 * from prod_cat_info

select sum( cast(total_amt as float)) as total_revenue from  Transactions T
join prod_cat_info  C
on T.prod_cat_code = C.prod_cat_code and T.prod_subcat_code = C.prod_sub_cat_code
where prod_cat  = 'Books'  or prod_cat =  'Electronics'



----7. How many customers have >10 transactions with us, excluding returns?
select  cust_id , count(distinct(transaction_id)) as cnt_tran from Transactions
where Qty > 0
group by cust_id
having count(distinct(transaction_id))> 10 


----8. What is the combined revenue earned from the "Electronics" & "Clothing"
-------categories, from "Flagship stores"?

select sum(cast (Total_amt as float))combiend_revenue from Transactions as T 
join prod_cat_info as P 
on T. prod_cat_code = P.prod_cat_code and T.prod_subcat_code = P.prod_sub_cat_code
WHERE prod_cat IN ('Clothing', 'Electronics') and Store_type ='flagship store' and Qty > 0 


----9. What is the total revenue generated from "Male" customers in "Electronics" category?
------ Output should display total revenue by prod sub-cat.

select  prod_cat ,prod_subcat, Gender,sum(cast(total_amt as float)) as total_revenue from Customer as C 
join Transactions as T 
on C.customer_Id = T.cust_id
join prod_cat_info as P 
on T.prod_cat_code  = P.prod_cat_code
where Gender = 'M' and prod_cat = 'Electronics'
group by prod_cat ,prod_subcat, Gender

----10. What is percentage of sales and returns by product sub category; display only top 5 sub categories in terms of sales?


select t1.prod_subcat,percentage_sales,percentage_returans_sales from(
--percentage of sales
select top 5  prod_subcat, sum(cast(total_amt as float)) / (select sum(cast(total_amt as float)) as Total_amt from Transactions where Qty>0 ) as percentage_sales
from  prod_cat_info as p
join Transactions as t 
on p.prod_sub_cat_code = t.prod_subcat_code and p.prod_cat_code	= t.prod_cat_code
where Qty>0
group by prod_subcat
order by percentage_sales desc
)as t1 
join 
 -- percentage of Returns sales

( select   prod_subcat, sum(cast(total_amt as float)) / (select sum(cast(total_amt as float)) as Total_amt from Transactions where Qty<0 ) as percentage_returans_sales
from  prod_cat_info as p
join Transactions as t 
on p.prod_sub_cat_code = t.prod_subcat_code and p.prod_cat_code	= t.prod_cat_code
where Qty<0
group by prod_subcat
)as t2 
on t1.prod_subcat= t2.prod_subcat

----11. For all customers aged between 25 to 35 years find what is the net total revenue generated by these consumers in last 30 days of transactions from max transaction
--------date available in the data?

select * from (
--customer age ----------
select * from (
select cust_id , datediff(year, DOB,max_date)as age  , revenue from (
select  cust_id, DOB, max(convert (date,tran_date,105)) as max_date ,sum (cast( total_amt as float))as revenue from Customer as c
join Transactions as t 
 on c.customer_Id = t.cust_id 
 where Qty > 0 
 group by cust_id , DOB)
 as A)
 as b 
 where age between 25 and 35
                            )   as c 
                             
                             join 
(
----- last 30 dayas Transactios 

select cust_id , convert ( date , tran_date , 105) as Tran_date from Transactions 
group by cust_id ,convert ( date , tran_date , 105) 
having convert ( date , tran_date , 105)  >= (select  dateadd(day,-30 ,max( convert ( date , tran_date , 105))) as cut_off from Transactions)
 
 )  as d 
 on c.cust_id = d.cust_id 



-- 12. Which product category has seen the max value of returns in the last 3 months of  transactions?

SELECT TOP 1
       P.prod_cat,
       SUM(T.total_amt) AS return_value
FROM Transactions T
JOIN prod_cat_info P
  ON T.prod_cat_code = P.prod_cat_code
WHERE T.total_amt < 0
AND CONVERT(date, T.tran_date, 105) >= (
    SELECT DATEADD(MONTH, -3, MAX(CONVERT(date, tran_date, 105)))
    FROM Transactions
)
GROUP BY P.prod_cat
ORDER BY return_value ASC;



--13. Which store-type sells the maximum products; by value of sales amount and by quantity sold?



select Store_type, sum(Qty) as total_qty  ,sum(total_amt) as revenue from Transactions
where qty > 0 
group by Store_type
order by  total_qty desc ,revenue desc



--14. What are the categories for which average revenue is above the overall average.?

select  prod_cat_code ,avg(total_amt) as revenue_avg  from  Transactions
where total_amt >0
group by prod_cat_code 
having avg(total_amt)  >= (select avg (total_amt) as overall_avg from Transactions where qty > 0)
order by revenue_avg desc



---15. Find the average and total revenue by each subcategory for the categories which are among top 5 categories in terms of quantity sold.?

select  top 5  prod_subcat_code,sum(total_amt) as total_revenue  ,avg(total_amt)as revenue_avg   from Transactions 
where Qty > 0 and prod_cat_code in (select top 5  prod_cat_code  from Transactions 
                                      where Qty> 0 
                                      group by prod_cat_code
                                      order by sum(Qty) desc )
group by  prod_subcat_code
order by revenue_avg desc 



