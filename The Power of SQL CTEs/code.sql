-- create a table
CREATE TABLE business_order (
    orderid integer primary key,
    clientid integer,
    address varchar(100),
    state varchar(2)
);

-- create a table
CREATE TABLE order_details (
    orderdetailsid integer primary key,
    orderid integer,
    productid integer,
    total_amount float
);

-- insert some values
INSERT INTO business_order VALUES (1,1, '100 MAIN ST', 'NY');
INSERT INTO business_order VALUES (2,2, '5TH AVENUE', 'SF');
INSERT INTO business_order VALUES (3,3, '56 AVERY ST', 'OK');

-- insert some values
INSERT INTO order_details VALUES (1, 1, 1, 12.5);
INSERT INTO order_details VALUES (2, 1, 2, 15);
INSERT INTO order_details VALUES (3, 2, 3, 30);
INSERT INTO order_details VALUES (4, 2, 4, 62.5);
INSERT INTO order_details VALUES (5, 3, 5, 1.5);
INSERT INTO order_details VALUES (6, 3, 6, 5.9);
INSERT INTO order_details VALUES (7, 3, 7, 99.5);

-- Your select statement below. Do not erase rows above!

with total_per_order as 
(select orderid, sum(total_amount) as total 
  from order_details group by orderid)
select * from business_order 
join total_per_order 
on total_per_order.orderid = business_order.orderid;

/* 
with total_per_order as 
(select orderid, round(sum(total_amount),2) as total_value
  from order_details group by orderid),
ranked_order_details_value as
(select orderid, total_amount, 
  dense_rank() over (partition by orderid order by total_amount desc) as rnk 
  from order_details),
second_highest_value as
(select orderid,total_amount as second_highest
  from ranked_order_details_value where rnk = 2)
select business_order.orderid, business_order.clientid, business_order.address,
business_order.state, total_per_order.total_value as tv,
second_highest_value.second_highest as shv
from business_order 
join total_per_order 
on total_per_order.orderid = business_order.orderid
join second_highest_value 
on second_highest_value.orderid = business_order.orderid;
*/ 