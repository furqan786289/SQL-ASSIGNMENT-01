

   --PART 1: QUERYING DATA (SELECT)


-- 1.1 Display all columns and all rows from Customers
SELECT *
FROM Customers;

-- 1.2 Display FirstName, LastName and Country of all customers
SELECT FirstName, LastName, Country
FROM Customers;

-- 1.3 Display ProductName and Price with column aliases
SELECT ProductName AS Product,
       Price AS UnitPrice
FROM Products;

-- 1.4 Display each country only once
SELECT DISTINCT Country
FROM Customers;

-- 1.5 Display salary after a 10% raise
SELECT FirstName,
       Salary,
       Salary * 1.10 AS SalaryAfterRaise
FROM Employees;



   --PART 2: FILTERING DATA (WHERE)


-- 2.1 Display all customers who live in Pakistan
SELECT *
FROM Customers
WHERE Country = 'Pakistan';

-- 2.2 Display products costing more than 100
SELECT ProductName, Price
FROM Products
WHERE Price > 100;

-- 2.3 Display employees earning 60000 or less
SELECT FirstName, Department, Salary
FROM Employees
WHERE Salary <= 60000;

-- 2.4 Display orders whose status is not Cancelled
SELECT *
FROM Orders
WHERE Status <> 'Cancelled';

-- 2.5 Display customers whose LoyaltyPoints are NULL
SELECT FirstName, LastName
FROM Customers
WHERE LoyaltyPoints IS NULL;



   --PART 3: SORTING DATA (ORDER BY)


-- 3.1 Sort products from lowest price to highest price
SELECT ProductName, Price
FROM Products
ORDER BY Price ASC;

-- 3.2 Sort customers from oldest to youngest
SELECT FirstName, Age
FROM Customers
ORDER BY Age DESC;

-- 3.3 Sort employees alphabetically by LastName
SELECT *
FROM Employees
ORDER BY LastName ASC;

-- 3.4 Sort customers by Country, then LoyaltyPoints descending
SELECT FirstName, Country, LoyaltyPoints
FROM Customers
ORDER BY Country ASC,
         LoyaltyPoints DESC;

-- 3.5 Display Delivered orders with the most recent order first
SELECT OrderID, OrderDate, Amount
FROM Orders
WHERE Status = 'Delivered'
ORDER BY OrderDate DESC;



   --PART 4: AND, OR AND NOT


-- 4.1 Customers who live in Pakistan AND are older than 30
SELECT *
FROM Customers
WHERE Country = 'Pakistan'
  AND Age > 30;

-- 4.2 Products in Furniture OR costing less than 10
SELECT *
FROM Products
WHERE Category = 'Furniture'
   OR Price < 10;

-- 4.3 Sales employees earning more than 50000
SELECT *
FROM Employees
WHERE Department = 'Sales'
  AND Salary > 50000;

-- 4.4 Customers who do NOT live in Pakistan
SELECT *
FROM Customers
WHERE NOT Country = 'Pakistan';

-- 4.5 Customers in USA or UAE who have more than 400 LoyaltyPoints
SELECT *
FROM Customers
WHERE (Country = 'USA' OR Country = 'UAE')
  AND LoyaltyPoints > 400;



   --PART 5: TOP


-- 5.1 Display the first 3 rows from Customers
-- Note: Without ORDER BY, SQL Server does not guarntee row order.
SELECT TOP 3 *
FROM Customers;

-- 5.2 Display the 5 most expensive products
SELECT TOP 5 ProductName, Price
FROM Products
ORDER BY Price DESC;

-- 5.3 Display the 3 youngest customers
SELECT TOP 3 FirstName, Age
FROM Customers
ORDER BY Age ASC;

-- 5.4 Display the highest-paid employee (one row)
SELECT TOP 1 FirstName, LastName, Salary
FROM Employees
ORDER BY Salary DESC;

-- 5.5 Display the 2 most recent Delivered orders
SELECT TOP 2 OrderID, OrderDate, Amount
FROM Orders
WHERE Status = 'Delivered'
ORDER BY OrderDate DESC;



   --PART 6: SET OPERATORS

-- 6.1 UNION: Combined list without duplicate names
SELECT FirstName, LastName
FROM Customers
UNION
SELECT FirstName, LastName
FROM Employees;

-- 6.2 UNION ALL: Combined list including duplicate names
SELECT FirstName, LastName
FROM Customers
UNION ALL
SELECT FirstName, LastName
FROM Employees;

-- UNION returns 19 unique people; UNION ALL returns 22 rows.
-- Therefore, UNION ALL returns 3 more rows because it keeps duplicates.

-- 6.3 INTERSECT: People who are both customers and employees
SELECT FirstName, LastName
FROM Customers
INTERSECT
SELECT FirstName, LastName
FROM Employees;

-- 6.4 EXCEPT: Customers who are not employees
SELECT FirstName, LastName
FROM Customers
EXCEPT
SELECT FirstName, LastName
FROM Employees;

-- 6.5 UNION ALL with PersonType, sorted by FirstName
SELECT FirstName, LastName, 'Customer' AS PersonType
FROM Customers
UNION ALL
SELECT FirstName, LastName, 'Employee' AS PersonType
FROM Employees
ORDER BY FirstName ASC;



   --PART 7: IN AND NOT IN


-- 7.1 Customers from Pakistan, UAE or India
SELECT *
FROM Customers
WHERE Country IN ('Pakistan', 'UAE', 'India');

-- 7.2 Products in Stationery or Accessories
SELECT ProductName, Category
FROM Products
WHERE Category IN ('Stationery', 'Accessories');

-- 7.3 Customers not living in USA, China or Italy
SELECT *
FROM Customers
WHERE Country NOT IN ('USA', 'China', 'Italy');

-- 7.4 HR or Marketing employees, highest salary first
SELECT FirstName, Department, Salary
FROM Employees
WHERE Department IN ('HR', 'Marketing')
ORDER BY Salary DESC;

-- 7.5 Orders that are neither Cancelled nor Pending
SELECT *
FROM Orders
WHERE Status NOT IN ('Cancelled', 'Pending');



   --PART 8: JOINS


-- 8.1 OrderID, customer's FirstName and OrderDate for every order
SELECT Orders.OrderID,
       Customers.FirstName,
       Orders.OrderDate
FROM Orders
INNER JOIN Customers
    ON Orders.CustomerID = Customers.CustomerID;

-- 8.2 Every customer and their OrderID, including customers with no orders
SELECT Customers.FirstName,
       Orders.OrderID
FROM Customers
LEFT JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID;

-- 8.3 Every product and its OrderID using RIGHT JOIN, starting from Orders
SELECT Products.ProductName,
       Orders.OrderID
FROM Orders
RIGHT JOIN Products
    ON Orders.ProductID = Products.ProductID;

-- 8.4 Customers who have never placed an order
SELECT Customers.FirstName,
       Customers.LastName
FROM Customers
LEFT JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderID IS NULL;

-- 8.5 Delivered orders: customer, product, date and quantity
SELECT Customers.FirstName,
       Products.ProductName,
       Orders.OrderDate,
       Orders.Quantity
FROM Orders
INNER JOIN Customers
    ON Orders.CustomerID = Customers.CustomerID
INNER JOIN Products
    ON Orders.ProductID = Products.ProductID
WHERE Orders.Status = 'Delivered';



   --PART 9: SUBQUERIES


-- 9.1 Products costing more than Desk Lamp
SELECT ProductName, Price
FROM Products
WHERE Price > (
    SELECT Price
    FROM Products
    WHERE ProductName = 'Desk Lamp'
);

-- 9.2 Products costing more than the average product price
SELECT ProductName, Price
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);

-- 9.3 Customers who have placed at least one order
SELECT FirstName, LastName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
);

-- 9.4 Products that have never been ordered
SELECT ProductName
FROM Products
WHERE ProductID NOT IN (
    SELECT ProductID
    FROM Orders
);

-- 9.5 Customers who ordered at least one Electronics product
SELECT FirstName, LastName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE ProductID IN (
        SELECT ProductID
        FROM Products
        WHERE Category = 'Electronics'
    )
);

