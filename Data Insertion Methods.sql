USE TSQLV6;


-- Dropping the table "Orders", in case it exists


DROP TABLE IF EXISTS dbo.Orders;


-- Creating the Table "Orders" with OrderID, ordering Date, Employee ID and Customer ID Fields 

CREATE TABLE dbo.Orders
(
    orderid INT NOT NULL
    CONSTRAINT PK_Orders PRIMARY KEY,
    orderdate DATE NOT NULL
    CONSTRAINT DFT_orderdate DEFAULT (SYSDATETIME()),
    empid INT NOT NULL,
    custid VARCHAR(10) NOT NULL

);

/*
Inserting some values into the table "Orders"
*/

INSERT INTO dbo.Orders(orderid, orderdate, empid, custid)
    VALUES(100001, '20220212', 3, 'A');

INSERT INTO dbo.Orders(orderid, empid, custid)

VALUES(10002, 5, 'B');

INSERT INTO dbo.Orders
(orderid, orderdate, empid, custid)

VALUES
    (10003, '20220213', 4, 'B'),
    (10004, '20220214', 1, 'A'),
    (10005, '20220213', 1, 'C'),
    (10006, '20220215', 3, 'C');

SELECT * FROM ( VALUES
(10003, '20220213', 4, 'B'),
(10004, '20220214', 1, 'A'),
(10005, '20220213', 1, 'C'),
(10006, '20220215', 3, 'C') )
AS O(orderid, orderdate, empid, custid);

/*
Using the Insert-Select Statement
*/

INSERT INTO dbo.Orders(orderid, orderdate, empid, custid)
    SELECT orderid, orderdate, empid, custid
    FROM Sales.Orders
    WHERE shipcountry = N'UK';

/*
Select-Into Statement
*/


DROP TABLE IF EXISTS dbo.Orders;

SELECT orderid, orderdate, empid, custid
    INTO dbo.Orders
    FROM Sales.Orders;
    
     




