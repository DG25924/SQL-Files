
USE TSQLV6;

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;

SELECT orderid, custid, empid, orderdate, freight
FROM Sales.Orders
WHERE custid = 71;

SELECT empid, YEAR(orderdate) AS orderyear, SUM(freight) AS totalfreight,
COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

SELECT orderid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE YEAR(orderdate) > 2021;

SELECT DISTINCT empid, YEAR(orderdate) as orderyear
FROM Sales.Orders
WHERE custid = 71;

SELECT * FROM Sales.Shippers;

SELECT TOP(5) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

SELECT TOP(1) PERCENT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC
OFFSET 50 ROWS FETCH NEXT 50 ROWS ONLY;

SELECT orderid, custid, val, ROW_NUMBER() OVER(PARTITION BY custid
                                                ORDER BY val) AS rownum
FROM Sales.OrderValues
ORDER BY custid, val;

SELECT orderid, empid, custid, orderdate
FROM Sales.Orders
WHERE orderid IN(10248, 10249, 10250);

SELECT orderid, empid, custid, orderdate
FROM Sales.Orders
WHERE orderid BETWEEN 10230 AND 10300;

SELECT orderid, productid, qty, unitprice, discount, qty*unitprice*(1-discount) AS val
FROM Sales.OrderDetails;         


