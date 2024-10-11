USE TSQLV6;
DROP TABLE IF EXISTS dbo.Orders;
CREATE TABLE dbo.Orders
(
orderid INT NOT NULL
CONSTRAINT PK_Orders PRIMARY KEY,
orderdate DATE NOT NULL,
empid INT NOT NULL,
custid VARCHAR(5) NOT NULL,
qty INT NOT NULL
);


INSERT INTO dbo.Orders(orderid, orderdate, empid, custid, qty)
VALUES
(30001, '20200802', 3, 'A', 10),
(10001, '20201224', 2, 'A', 12),
(10005, '20201224', 1, 'B', 20),
(40001, '20210109', 2, 'A', 40),
(10006, '20210118', 1, 'C', 14),
(20001, '20210212', 2, 'B', 12),
(40005, '20220212', 3, 'A', 10),
(20002, '20220216', 1, 'C', 20),
(30003, '20220418', 2, 'B', 15),
(30004, '20200418', 3, 'C', 22),
(30007, '20220907', 3, 'D', 30);


SELECT * FROM dbo.Orders;

SELECT empid, custid, (SUM(qty)) AS sumqty
FROM dbo.Orders
GROUP BY empid, custid;

SELECT empid,
    SUM(CASE WHEN custid = 'A' THEN qty END) AS A,
    SUM(CASE WHEN custid = 'B' THEN qty END) AS B,
    SUM(CASE WHEN custid = 'C' THEN qty END) AS C,
    SUM(CASE WHEN custid = 'D' THEN qty END) AS D

FROM dbo.Orders
GROUP BY empid;

SELECT empid, A, B, C, D
FROM (SELECT empid, custid, qty
        FROM dbo.Orders) AS D
    PIVOT(SUM(qty) FOR custid IN(A, B, C, D)) AS P;

USE TSQLV6;

DROP TABLE IF EXISTS dbo.EmpCustOrders;
CREATE TABLE dbo.EmpCustOrders
(
empid INT NOT NULL
CONSTRAINT PK_EmpCustOrders PRIMARY KEY,
A VARCHAR(5) NULL,
B VARCHAR(5) NULL,
C VARCHAR(5) NULL,
D VARCHAR(5) NULL
);
INSERT INTO dbo.EmpCustOrders(empid, A, B, C, D)
SELECT empid, A, B, C, D
FROM (SELECT empid, custid, qty
FROM dbo.Orders) AS D
PIVOT(SUM(qty) FOR custid IN(A, B, C, D)) AS P;
SELECT * FROM dbo.EmpCustOrders;       



