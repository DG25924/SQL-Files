USE TSQLV6;

DROP TABLE IF EXISTS dbo.OrderDetails, dbo.Orders;

CREATE TABLE dbo.Orders
(
    orderid INT NOT NULL,
    custid INT NULL,
    empid INT NOT NULL,
    orderdate DATE NOT NULL,
    requireddate DATE NOT NULL,
    shippeddate DATE NULL,
    shipperid INT NOT NULL,
    freight MONEY NOT NULL
    CONSTRAINT DFT_Orders_freight DEFAULT(0),
    shipname NVARCHAR(40) NOT NULL,
    shipaddress NVARCHAR(60) NOT NULL,
    shipcity NVARCHAR(15) NOT NULL,
    shipregion NVARCHAR(15) NULL,
    shippostalcode NVARCHAR(10) NULL,
    shipcountry NVARCHAR(15) NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY(orderid)
);

CREATE TABLE dbo.OrderDetails
(
orderid INT NOT NULL,
productid INT NOT NULL,
unitprice MONEY NOT NULL
CONSTRAINT DFT_OrderDetails_unitprice DEFAULT(0),
qty SMALLINT NOT NULL
CONSTRAINT DFT_OrderDetails_qty DEFAULT(1),
discount NUMERIC(4, 3) NOT NULL
CONSTRAINT DFT_OrderDetails_discount DEFAULT(0),
CONSTRAINT PK_OrderDetails PRIMARY KEY(orderid, productid),
CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY(orderid)
REFERENCES dbo.Orders(orderid),
CONSTRAINT CHK_discount CHECK (discount BETWEEN 0 AND 1),
CONSTRAINT CHK_qty CHECK (qty > 0),
CONSTRAINT CHK_unitprice CHECK (unitprice >= 0)
);
GO
INSERT INTO dbo.Orders SELECT * FROM Sales.Orders;
INSERT INTO dbo.OrderDetails SELECT * FROM Sales.OrderDetails;

DROP TABLE IF EXISTS dbo.T1, dbo.T2;
CREATE TABLE dbo.T1
(
keycol INT NOT NULL
CONSTRAINT PK_T1 PRIMARY KEY,
col1 INT NOT NULL,
col2 INT NOT NULL,
col3 INT NOT NULL,
col4 VARCHAR(10) NOT NULL
);
CREATE TABLE dbo.T2
(
keycol INT NOT NULL
CONSTRAINT PK_T2 PRIMARY KEY,
col1 INT NOT NULL,
col2 INT NOT NULL,
col3 INT NOT NULL,
col4 VARCHAR(10) NOT NULL
);
GO
INSERT INTO dbo.T1(keycol, col1, col2, col3, col4)
VALUES(2, 10, 5, 30, 'D'),
(3, 40, 15, 20, 'A'),
(5, 17, 60, 12, 'B');
INSERT INTO dbo.T2(keycol, col1, col2, col3, col4)
VALUES(3, 200, 32, 11, 'ABC'),
(5, 400, 43, 10, 'ABC'),
(7, 600, 54, 90, 'XYZ');

UPDATE dbo.OrderDetails
SET discount += 0.05
WHERE productid = 51;

UPDATE dbo.T1
SET col1 += 10, col2 += 10;


UPDATE OD
    SET discount += 0.05
    FROM dbo.OrderDetails AS OD
    INNER JOIN dbo.Orders AS O
    ON O.orderid = OD.orderid
    WHERE O.custid = 1;

DROP TABLE IF EXISTS dbo.MySequences;

CREATE TABLE dbo.MySequences
(
    id VARCHAR(10) NOT NULL CONSTRAINT PK_MySequences PRIMARY KEY(id),
    val INT NOT NULL
);

INSERT INTO dbo.MySequences VALUES('SEQ1', 0);

DECLARE @nextval AS INT;

UPDATE dbo.MySequences
    SET @nextval = val+= 1
    WHERE id = 'SEQ1';

SELECT @nextval;

WITH C AS
(
    SELECT *
    FROM dbo.Orders
    ORDER BY orderid DESC
    OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY
)

