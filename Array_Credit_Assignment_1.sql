/*

##### Assignment 1
Imagine for a moment you're helping to design the initial schema for our white label portal product that we offer to clients.

Customers log into the portal, branded to a particular client and are able to order credit reports. 
A total of 6 products are offered: Partial and Full reports for each of the three credit bureaus (Equifax, Experian, and TransUnion). 
We then bill our clients based on the number of each report their customers order.

Describe the data schema for these entities. Include entity names, properties, data types, relationships and any relevant indexes, 
keys and constraints.

*/

--- Create Database
CREATE DATABASE creditDB;

--- Switch to Database created above.
USE creditDB;

--- Create clients table - Client details
CREATE TABLE clients
(
"id" BIGINT PRIMARY KEY IDENTITY(1,1),
"name" VARCHAR(255) UNIQUE NOT NULL,
"email" VARCHAR(255),
"phone" VARCHAR(15),
"address" VARCHAR(255),
"city" VARCHAR(255),
"state" VARCHAR(255),
"country" VARCHAR(255),
"zipcode" VARCHAR(255)
);


--- Create customers table - Customer Details
CREATE TABLE customers
(
"id" BIGINT PRIMARY KEY IDENTITY(1,1),
"account_id" BIGINT NOT NULL,
"first_name" VARCHAR(255) NOT NULL,
"last_name" VARCHAR(255) NOT NULL,
"email" VARCHAR(255) NOT NULL,
"username" VARCHAR(255) NOT NULL,
"password" CHAR(128) NOT NULL,
"phone" VARCHAR(15),
"dob" DATE,
"address" VARCHAR(255),
"city" VARCHAR(255),
"state" VARCHAR(255),
"country" VARCHAR(255),
"zipcode" VARCHAR(255),
"client_id" BIGINT NOT NULL,
CONSTRAINT client_account_unique UNIQUE(client_id,account_id),
CONSTRAINT fk_client_id_customers_clients FOREIGN KEY(client_id)
REFERENCES clients(id)
);


--- Create products table - Product details.
CREATE TABLE products
(
"id" BIGINT PRIMARY KEY IDENTITY(1,1),
"name" VARCHAR(255) UNIQUE NOT NULL,
"price" FLOAT NOT NULL,
"currency" VARCHAR(20) NOT NULL,
"country" VARCHAR(50) NOT NULL
);


--- Create product_ordered table - tracks all the orders placed by cutomers.
CREATE TABLE product_ordered
(
"id" BIGINT PRIMARY KEY IDENTITY(1,1),
"client_id" BIGINT,
"product_id" BIGINT,
"customer_id" BIGINT,
"order_date" DATE,
CONSTRAINT fk_client_id_po_clients FOREIGN KEY(client_id)
REFERENCES clients(id),
CONSTRAINT fk_product_id_po_products FOREIGN KEY(product_id)
REFERENCES products(id),
CONSTRAINT fk_customer_id_po_customers FOREIGN KEY(customer_id)
REFERENCES customers(id)
);



--- Inserting sample data.

INSERT INTO products VALUES('1B TransUnion',10,'USD','USA');
INSERT INTO products VALUES('3B TransUnion',30,'USD','USA');

INSERT INTO products VALUES('1B Equifax',15,'USD','USA');
INSERT INTO products VALUES('3B Equifax',35,'USD','USA');

INSERT INTO products VALUES('1B Experian',10,'USD','USA');
INSERT INTO products VALUES('3B Experian',40,'USD','USA');


INSERT INTO clients(name,email,phone,address,city,state,country,zipcode)
VALUES('Bank Of America','management@bofa.com','111-111-1111','151 Ray St','Boston','Massachusetts','USA','02125'),
		('CitiGroup','management@citi.com','222-222-2222','19 Blu Dr','San Jose','California','USA','95126'),
		('JPMorgan','management@jpmorg.com','333-333-3333','222 Dorchester St','Boston','Massachusetts','USA','02125'),
		('Morgan Stanley','management@morganstan.com','444-444-4444','1 New Cres','San Francisco','California','USA','94004');

INSERT INTO customers(account_id,first_name,last_name,email,username,password,phone,dob,client_id)
VALUES(123,'Grace','Smith','gsmith@citigrouptest.com','gsmith','hashed_password','999-999-9999','1980-01-01',2);

INSERT INTO customers(account_id,first_name,last_name,email,username,password,address,city,state,country,zipcode,client_id)
VALUES(456,'William','Wright','wwright@jpmorgantest.com','wwright','hashed_password','ABC Street','Buffalo','NY','USA','11111',3);

INSERT INTO customers(account_id,first_name,last_name,email,username,password,phone,dob,client_id)
VALUES(789,'Jasmeet','Singh','jsingh@bofatest.com','jsingh','hashed_password','888-888-8888','1990-01-01',1);

INSERT INTO product_ordered 
VALUES(1,2,3,'2022-02-01'),(3,2,2,'2022-03-04'),(1,2,3,'2022-02-16'),(2,2,1,'2022-06-01'),
	  (1,1,3,'2022-03-06'),(2,1,1,'2022-08-09');

INSERT INTO product_ordered 
VALUES(1,2,3,'2021-11-22'),(3,2,2,'2021-12-12');


/*
##### Assignment 2
Not long after the initial launch, the CTO comes to you and asks to build a report showing the number of 3B TransUnion reports 
ordered per month, for each client.

Using the schema you designed above, what would be the query you'd use to retrieve this information?
*/

--- Total no of 3B Transunion reports ordered per month, per client.
SELECT c.name as client_name,datename(mm,po.order_date) as month,count(p.name) as total_reports
FROM product_ordered po
JOIN products p
ON po.product_id = p.id
JOIN clients c
ON po.client_id = c.id
WHERE p.name ='3B Transunion'
AND datename(yy,po.order_date) = 2022
GROUP BY c.name,datename(mm,po.order_date)
ORDER BY datename(mm,po.order_date);



-----

/*
##### Assignment 4

You've been asked to demonstrate to a junior engineer the use of CTEs. Write a query that would identify clients that 
have done over 100 reports in the last 30 days. 
The query should return the client's name and the number of reports within the last 30 days.

*/


--- Fetch clients with more than 100 reports in last 30 days.

WITH cte_count_report AS (

	SELECT po.client_id, count(product_id) as product_count,c.name
	FROM product_ordered po
	JOIN clients c
	ON po.client_id = c.id
	WHERE order_date >= DATEADD(day,-30, GETDATE())
	GROUP BY po.client_id,c.name
)

SELECT cr.name,cr.product_count
FROM cte_count_report cr
WHERE cr.product_count > 100;

-----

