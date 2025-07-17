---Cap- Project
--Scenario
--You are hired as a Junior Data Analyst for a retail company 
--that sells electronics and accessories. 
--Your manager wants you to analyze sales and customer data using SQL in SSMS.

create database project

use project


	-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    City VARCHAR(50),
    JoinDate DATE
);

-- Insert data into Customers
INSERT INTO Customers VALUES
(1, 'John', 'Doe', 'Mumbai', '2024-01-05'),
(2, 'Alice', 'Smith', 'Delhi', '2024-02-15'),
(3, 'Bob', 'Brown', 'Bangalore', '2024-03-20'),
(4, 'Sara', 'White', 'Mumbai', '2024-01-25'),
(5, 'Mike', 'Black', 'Chennai', '2024-02-10');

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATE,
    Product VARCHAR(50),
    Quantity INT,
    Price INT
);

-- Insert data into Orders
INSERT INTO Orders VALUES
(101, 1, '2024-04-10', 'Laptop', 1, 55000),
(102, 2, '2024-04-12', 'Mouse', 2, 800),
(103, 1, '2024-04-15', 'Keyboard', 1, 1500),
(104, 3, '2024-04-20', 'Laptop', 1, 50000),
(105, 4, '2024-04-22', 'Headphones', 1, 2000),
(106, 2, '2024-04-25', 'Laptop', 1, 52000),
(107, 5, '2024-04-28', 'Mouse', 1, 700),
(108, 3, '2024-05-02', 'Keyboard', 1, 1600);


--Part A: Basic Queries
--1️⃣ Get the list of all customers from Mumbai.
--2️⃣ Show all orders for Laptops.
--3️⃣ Find the total number of orders placed.
--4 find price between 50000 and 80000

-- 1
SELECT * FROM Customers WHERE City = 'Mumbai';
-- Sara & John are from Mumbai.

-- 2
SELECT * FROM Orders WHERE Product = 'Laptop';
--Total of 3 laptos are sold

-- 3
SELECT COUNT(*) AS TotalOrders FROM Orders;

-- Total of 8 orders placed

---Customized
select * from orders where  price between 50000 and 80000;
-- There are 3 customers who shopped between 50K to 80K



--🔗 Part B: Joins
--4️⃣ Get the full name of customers and their products ordered.
--5️⃣ Find customers who have not placed any orders.

select top 1* from Customers

SELECT C.FirstName + ' ' + C.LastName AS FullName, O.Product
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID;


select c.customerid,o.orderid
from Customers c join Orders o on c.customerid = o.customerid
where o.orderid is null

SELECT *
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders);



---Part C: Aggregations
--6️⃣ Find the total revenue earned from all orders.
--7️⃣ Find total quantity of Mouses sold.


select sum(quantity * price) as Total_Revenue from orders


SELECT SUM(Quantity) AS TotalMouseQuantity
FROM Orders
WHERE Product = 'Mouse';

--D: Group By
--8️⃣ Show total sales amount per customer.
--9️⃣ Show number of orders per city.

select c.firstname , sum(o.quantity * o.price)Sales
from Customers c join orders o on c.CustomerID = o.CustomerID
group by c.FirstName

select c.city , count(o.orderid) as orders
from customers c join orders o on c.CustomerID = o.CustomerID
group by c.City

--
--🪝 Part E: Subquery & CASE
--🔟 Find customers who spent more than 50,000 in total.
--1️⃣1️⃣ Write a query to display each order with a label:
--
--‘High Value’ if Price > 50000
--
--‘Low Value’ otherwise

select 


-- 10
SELECT C.*
FROM Customers C
WHERE C.CustomerID IN (
    SELECT CustomerID
    FROM Orders
    GROUP BY CustomerID
    HAVING SUM(Price) > 50000
);

-- 11
SELECT OrderID, Price,
    CASE WHEN Price > 50000 THEN 'High Value'
         ELSE 'Low Value'
    END AS ValueLabel
FROM Orders;







--
--🪜 Part F: Window Functions
--1️⃣2️⃣ Find the running total of revenue by order date.


SELECT OrderID, OrderDate, Price,
       SUM(Price) OVER (ORDER BY OrderDate) AS RunningRevenue
FROM Orders

;--1️3️⃣ Assign a ROW_NUMBER to each order 
--by CustomerID ordered by OrderDate (oldest first).


--13 A Assign Row_Number to each customer id 
--order by Price 



SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    Price,
    ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RowNum
FROM Orders;






--14--Use RANK to rank orders by Price (highest to lowest)


SELECT 
    OrderID,
    CustomerID,
    Price,
    RANK() OVER (ORDER BY Price DESC) AS PriceRank
FROM Orders

--15Use DENSE_RANK to 
--rank orders by Price (highest to lowest) — explain difference with RANK.

-- 15
SELECT 
    OrderID,
    CustomerID,
    Price,
    DENSE_RANK() OVER (ORDER BY Price DESC) AS PriceDenseRank
FROM Orders;

--16-Find customers who have placed more than 1 order using HAVING.

SELECT 
    CustomerID,
    COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(OrderID) > 1;





