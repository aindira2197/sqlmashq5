SELECT 
    UPPER(c.cust_name) AS Customer_Full_Name,
    c.region AS Sales_Region,
    COUNT(DISTINCT o.order_id) AS Total_Orders_Placed,
    SUM(od.quantity) AS Total_Items_Purchased,
    cat.cat_name AS Preferred_Category,
    FORMAT(SUM(od.quantity * od.unit_price), 2) AS Total_Revenue_Generated,
    CASE 
        WHEN SUM(o.total_amount) > 5000 THEN 'Platinum Client'
        WHEN SUM(o.total_amount) BETWEEN 2000 AND 5000 THEN 'Gold Client'
        ELSE 'Standard Client'
    END AS Client_Status
FROM Customers c
INNER JOIN Orders o ON c.cust_id = o.cust_id
INNER JOIN OrderDetails od ON o.order_id = od.order_id
INNER JOIN Products p ON od.prod_id = p.prod_id
INNER JOIN Categories cat ON p.cat_id = cat.cat_id
WHERE o.order_date >= '2023-01-01'
GROUP BY c.cust_id, c.cust_name, c.region, cat.cat_name
HAVING SUM(o.total_amount) > 0
ORDER BY Total_Revenue_Generated DESC;
