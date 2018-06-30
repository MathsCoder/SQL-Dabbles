## 3. The With Clause ##

WITH playlist_info AS(        
     SELECT
         p.playlist_id,
         p.name playlist_name,
         COUNT(t.track_id) number_of_tracks,
         SUM(t.milliseconds/1000) length_seconds
         
         
     FROM playlist p
     LEFT JOIN playlist_track pt ON pt.playlist_id = p.playlist_id
     LEFT JOIN track t ON t.track_id = pt.track_id
     GROUP BY p.playlist_id
    )
    SELECT
    playlist_id,
    playlist_name,
    number_of_tracks,
    length_seconds
    FROM playlist_info

## 4. Creating Views ##

CREATE VIEW chinook.customer_gt_90_dollars AS
        SELECT c.*
        FROM chinook.customer c
        INNER JOIN chinook.invoice i ON i.customer_id = c.customer_id
        GROUP BY c.customer_id
        HAVING SUM(i.total) > 90;
    
SELECT * FROM chinook.customer_gt_90_dollars;
    


## 5. Combining Rows With Union ##

SELECT * FROM customer_usa
UNION
SELECT * FROM customer_gt_90_dollars

## 6. Combining Rows Using Intersect and Except ##

SELECT e.first_name || " " || e.last_name employee_name, COUNT(cd.customer_id) customers_usa_gt_90
FROM employee e
    LEFT JOIN (SELECT * from customer_usa

    INTERSECT

    SELECT * from customer_gt_90_dollars) cd ON cd.support_rep_id = e.employee_id
WHERE e.title = "Sales Support Agent"
GROUP BY employee_name
ORDER BY employee_name

## 7. Multiple Named Subqueries ##

WITH
    customers_india AS
        (
        SELECT * FROM customer
        WHERE country = "India"
        ),
    sales_per_customer AS
        (
         SELECT
             customer_id,
             SUM(total) total
         FROM invoice
         GROUP BY customer_id
        )
SELECT
    ci.first_name || " " || ci.last_name customer_name,
    spc.total total_purchases
FROM customers_india ci
LEFT JOIN sales_per_customer spc ON ci.customer_id = spc.customer_id
ORDER BY customer_name


## 8. Challenge: Each Country's Best Customer ##


WITH

    sales_per_customer AS
        (
         SELECT
             customer_id,
             SUM(total) total
         FROM invoice
         GROUP BY customer_id
        )
SELECT
    c.country,
    c.first_name || " " || c.last_name customer_name,
    MAX(spc.total) total_purchased
FROM customer c
LEFT JOIN sales_per_customer spc ON c.customer_id = spc.customer_id
GROUP by c.country
ORDER BY c.country