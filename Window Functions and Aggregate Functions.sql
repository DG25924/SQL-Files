USE TSQLV6;

SELECT empid, ordermonth, val, SUM(val)
OVER(PARTITION BY empid
        ORDER BY ordermonth
        ROWS BETWEEN UNBOUNDED PRECEDING 
                AND CURRENT ROW) AS runval 

FROM Sales.EmpOrders;

SELECT orderid, custid, val,
ROW_NUMBER() OVER(ORDER BY val) AS rownum,
RANK() OVER(ORDER BY val) AS ranknum,
dense_rank() OVER(ORDER BY val) AS dense_rank,
NTILE(10) OVER(order BY val) AS ntile

FROM Sales.OrderValues
ORDER BY val;

SELECT orderid, custid, val,

ROW_NUMBER() OVER(PARTITION BY custid
        ORDER BY val) AS rownum

FROM Sales.OrderValues
ORDER BY custid, val;

SELECT distinct val, ROW_NUMBER() OVER(ORDER BY val) AS rownum
FROM Sales.OrderValues;

SELECT val, ROW_NUMBER() OVER(ORDER BY val) AS rownum
FROM Sales.OrderValues
GROUP BY val;

SELECT custid, orderid, val,
    FIRST_VALUE(val) OVER(PARTITION BY custid
                            ORDER BY orderdate, orderid
                            ROWS BETWEEN UNBOUNDED PRECEDING
                            AND CURRENT ROW) AS firstval,
    LAST_VALUE(val) OVER(PARTITION BY custid
                            ORDER BY orderdate, orderid
                            ROWS BETWEEN UNBOUNDED PRECEDING
                            AND CURRENT ROW) AS lastval

FROM Sales.OrderValues
order BY custid, orderdate, orderid;

SELECT orderid, custid, orderdate, shippeddate
FROM sales.Orders
WHERE custid IN (9, 20, 32, 73)
    AND orderdate >= '20220101'
    ORDER BY custid, orderdate, orderid;

SELECT orderid, custid, orderdate, shippeddate,
LAST_VALUE(shippeddate) IGNORE NULLS
    OVER(PARTITION BY custid
        ORDER BY orderdate, orderid
        ROWS UNBOUNDED preceding) AS Last_known_Shipped_Date

FROM Sales.Orders
WHERE custid IN(9, 20, 32, 73)
    AND orderdate >= '20220101'
    ORDER BY custid, orderdate, orderid;

SELECT orderid, custid, val,
    SUM(val) OVER() AS totalvalue,
    SUM(val) OVER(PARTITION BY custid
                    ORDER BY orderid
                    ROWS UNBOUNDED PRECEDING) AS custtotalvalue

FROM Sales.OrderValues;

SELECT orderid, custid, val,
    100.*val/SUM(val) OVER() AS pctall,
    100.*val/SUM(val) OVER(PARTITION BY custid) AS pctcust

FROM Sales.OrderValues;

SELECT empid, ordermonth, val,
    SUM(val) OVER W AS runsum,
    MIN(val) OVER W as runmin,
    max(val) OVER W as runmax,
    AVG(val) OVER W AS runavg

FROM Sales.EmpOrders
WINDOW W AS (PARTITION BY empid
                ORDER BY ordermonth
                ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW);

SELECT custid, orderid, val,
    FIRST_VALUE(val) OVER(PO
                            ROWS BETWEEN UNBOUNDED PRECEDING
                                    AND CURRENT ROW) AS firstval,

    LAST_VALUE(val) OVER(PO 
                            ROWS BETWEEN CURRENT ROW
                                    AND UNBOUNDED FOLLOWING) AS lastval

FROM Sales.OrderValues
WINDOW PO AS (PARTITION BY custid
                ORDER BY orderdate, orderid)
ORDER BY custid, orderdate, orderid;

SELECT orderid, custid, orderdate, qty, val,
    ROW_NUMBER() OVER PO AS ordernum,
    MAX(orderdate) OVER P AS maxorderdate,
    MIN(qty) OVER POF AS runsumqty,
    SUM(val) OVER POF AS runsumval

FROM Sales.Ordervalues
WINDOW P AS (PARTITION BY custid),
        PO AS (P ORDER BY orderdate, orderid),
        POF AS (PO ROWS UNBOUNDED PRECEDING)

ORDER BY custid, orderdate, orderid;




