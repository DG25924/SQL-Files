USE TSQLV6;

DROP TABLE IF EXISTS dbo.Orders;

---------------------------------------------------------
-- Creating a New table "Orders" in the dbo Schema, with some initialized values

CREATE TABLE dbo.Orders

(
orderid INT NOT NULL
CONSTRAINT PK_Orders PRIMARY KEY,
orderdate DATE NOT NULL
CONSTRAINT DFT_orderdate DEFAULT(SYSDATETIME()),
empid INT NOT NULL,
custid VARCHAR(10) NOT NULL
);

INSERT INTO dbo.Orders(orderid, orderdate, empid, custid)
VALUES(10001, '20220212', 3, 'A');

INSERT INTO dbo.Orders(orderid, orderdate, empid, custid)
VALUES
(10003, '20220212', 4, 'B'),
(10004, '20220212', 1, 'A'),
(10005, '20220212', 1, 'C'),
(10006, '20220212', 3, 'C');

------------------------------------------------------
-- Deriving Data Tables using specific values from a schematic table

SELECT * FROM 
(
    VALUES
(10003, '20220212', 4, 'B'),
(10004, '20220212', 1, 'A'),
(10005, '20220212', 1, 'C'),
(10006, '20220212', 3, 'C')  
) AS O(orderid, orderdate, empid, custid);


INSERT INTO dbo.Orders(orderid, orderdate, empid, custid)
SELECT orderid, orderdate, empid, custid
FROM Sales.Orders
WHERE shipcountry = N'UK';
---------------------------------------------------------

DROP TABLE IF EXISTS dbo.Orders;

SELECT orderid, orderdate, empid, custid
INTO dbo.Orders
FROM Sales.Orders

---------------------------------------------------------
-- Fetching the 'Country', 'Region' and 'CITY' columns from a schematic table into a new derived table "Locations"

DROP TABLE IF EXISTS dbo.Locations;
SELECT country, region, city
INTO dbo.Locations
FROM Sales.Customers

EXCEPT SELECT country, region, city
FROM HR.Employees;
GO
-----------------------------------------------------------

DROP TABLE IF EXISTS dbo.T1

CREATE TABLE dbo.T1
(
keycol INT NOT NULL IDENTITY(1, 1)

CONSTRAINT PK_T1 PRIMARY KEY,

datacol VARCHAR(10) NOT NULL

CONSTRAINT CHK_T1_datacol CHECK(datacol LIKE '[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%')
);

INSERT INTO dbo.T1(datacol) VALUES('AAAAA'), ('CCCCC'),('BBBBB');

SELECT * FROM dbo.T1;

GO

--------------------------------------------------------------

DECLARE @new_key AS INT;

INSERT INTO dbo.T1(datacol) VALUES('AAAAA');

SET @new_key = SCOPE_IDENTITY();

SELECT @new_key AS new_key;

---------------------------------------------------------------

DROP TABLE IF EXISTS dbo.Customers, dbo.CustomersStage;
GO

CREATE TABLE dbo.Customers
(

custid INT NOT NULL,

companyname VARCHAR(25) NOT NULL,

phone VARCHAR(20) NOT NULL,

address VARCHAR(50) NOT NULL,

CONSTRAINT PK_Customers PRIMARY KEY(custid)
);

INSERT INTO dbo.Customers(custid, companyname, phone, address)

VALUES
(1, 'cust 1', '(111) 111-1111', 'address 1'),
(2, 'cust 2', '(222) 222-2222', 'address 2'),
(3, 'cust 3', '(333) 333-3333', 'address 3'),
(4, 'cust 4', '(444) 444-4444', 'address 4'),
(5, 'cust 5', '(555) 555-5555', 'address 5');

CREATE TABLE dbo.CustomersStage

(

custid INT NOT NULL,

companyname VARCHAR(25) NOT NULL,

phone VARCHAR(20) NOT NULL,

address VARCHAR(50) NOT NULL,

CONSTRAINT PK_CustomersStage PRIMARY KEY(custid)

);

INSERT INTO dbo.CustomersStage(custid, companyname, phone, address)

VALUES
(2, 'AAAAA', '(222) 222-2222', 'address 2'),
(3, 'cust 3', '(333) 333-3333', 'address 3'),
(5, 'BBBBB', 'CCCCC', 'DDDDD'),
(6, 'cust 6 (new)', '(666) 666-6666', 'address 6'),
(7, 'cust 7 (new)', '(777) 777-7777', 'address 7');

SELECT * FROM dbo.Customers

SELECT * FROM dbo.CustomersStage;

GO

-------------------------------------------------------------------

MERGE INTO dbo.Customers AS TGT
USING dbo.CustomersStage AS SRC

ON TGT.custid = SRC.custid

WHEN MATCHED THEN
UPDATE SET
TGT.companyname = SRC.companyname,
TGT.phone = SRC.phone,
TGT.address = SRC.address
WHEN NOT MATCHED THEN
INSERT (custid, companyname, phone, address)
VALUES(SRC.custid, SRC.companyname, SRC.phone, SRC.address);

--------------------------------------------------------------------

SELECT * FROM dbo.Customers;

---------------------------------------------------------------------

