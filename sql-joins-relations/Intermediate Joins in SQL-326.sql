## 2. Joining Three Tables ##

SELECT il.track_id, t.name track_name, mt.name track_type, t.unit_price, il.quantity
FROM invoice_line il
INNER JOIN track t ON t.track_id = il.track_id
INNER JOIN media_type mt ON t.media_type_id = mt.media_type_id
WHERE invoice_id = 4

## 3. Joining More Than Three Tables ##

SELECT
    il.track_id,
    t.name track_name,
    ar.name artist_name,
    mt.name track_type,
    il.unit_price,
    il.quantity
    
FROM invoice_line il
INNER JOIN track t ON t.track_id = il.track_id
INNER JOIN media_type mt ON mt.media_type_id = t.media_type_id
INNER JOIN album al ON al.album_id = t.album_id
INNER JOIN artist ar ON ar.artist_id = al.artist_id
WHERE il.invoice_id = 4;

## 4. Combining Multiple Joins with Subqueries ##

SELECT
    ta.title album,
    ta.artist_name artist,
    SUM(quantity) AS tracks_purchased
FROM invoice_line il
INNER JOIN (
            SELECT
                t.album_id,
                t.track_id,
                ar.name artist_name,
                al.title
            FROM track t
            INNER JOIN album al ON al.album_id = t.album_id
            INNER JOIN artist ar ON ar.artist_id = al.artist_id
           ) ta
           ON ta.track_id = il.track_id
GROUP BY ta.album_id
ORDER BY tracks_purchased DESC LIMIT 5;

## 5. Recursive Joins ##

SELECT e1.first_name || " " || e1.last_name employee_name, e1.title employee_title, e2.first_name || " " || e2.last_name supervisor_name, e2.title supervisor_title
FROM employee e1
LEFT JOIN employee e2 on e1.reports_to=e2.employee_id
ORDER BY employee_name

## 6. Pattern Matching Using Like ##

SELECT first_name, last_name, phone
FROM customer 
WHERE first_name LIKE "%Belle%";

## 7. Generating Columns With The Case Statement ##



SELECT 
    c.first_name || " " || c.last_name customer_name, 
    COUNT(i.invoice_id) number_of_purchases, 
    SUM(i.total) total_spent,
    CASE 
       WHEN sum(i.total) < 40 THEN 'small spender'
       WHEN sum(i.total) > 100 THEN 'big spender'
       ELSE 'regular'
       END
       AS customer_category
FROM customer c
INNER JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY customer_name
ORDER BY customer_name
--, invoice i