-- Write a query that shows the total purchase sales income per dealership.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  d.dealership_id;

-- Write a query that shows the purchase sales income per dealership for the current month.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE
  date_part('month', s.purchase_date) = date_part('month', CURRENT_DATE) -- AND date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Write a query that shows the purchase sales income per dealership for the current year.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE
  date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Write a query that shows the total lease income per dealership.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
GROUP BY
  d.dealership_id;

-- Write a query that shows the lease income per dealership for the current month.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
  AND date_part('month', s.purchase_date) = date_part('month', CURRENT_DATE) -- AND date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Write a query that shows the lease income per dealership for the current year.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
  AND date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Write a query that shows the total income (purchase and lease) per employee.
SELECT
  CONCAT(e.first_name, ' ', e.last_name) AS employee,
  SUM(s.price)
FROM
  sales s
  JOIN employees e ON s.employee_id = e.employee_id
GROUP BY
  e.employee_id;
 44  customer_loyalty.sql 
@@ -0,0 +1,44 @@
-- What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT
  c.state,
  COUNT(s.sale_id)
FROM
  customers c
  JOIN sales s ON s.customer_id = c.customer_id
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  c.state
ORDER BY
  COUNT(s.sale_id) DESC
LIMIT
  5;

-- What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT
  c.zipcode,
  COUNT(s.sale_id)
FROM
  customers c
  JOIN sales s ON s.customer_id = c.customer_id
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  c.zipcode
ORDER BY
  COUNT(s.sale_id) DESC
LIMIT
  5;

-- What are the top 5 dealerships with the most customers?
SELECT
  d.business_name,
  COUNT(c.customer_id)
FROM
  customers c
  JOIN sales s ON s.customer_id = c.customer_id
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  d.dealership_id
ORDER BY
  COUNT(c.customer_id) DESC
LIMIT
  5;


  ----Employee Recognition
  Which employees were hired this month?
-- Which employees were hired this year?
-- Which employee has been working the longest at each dealership?
-- What are the 10 most veteran employees across all dealerships in the Carnival platform?


-- How many emloyees are there for each role?
SELECT
  et.name,
  COUNT(e.employee_id)
FROM
  employeetypes et
  JOIN employees e ON et.employee_type_id = e.employee_type_id
GROUP BY
  et.employee_type_id 

  -- How many finance managers work at each dealership?
SELECT
  d.business_name,
  COUNT(e.employee_id)
FROM
  employeetypes et
  JOIN employees e ON et.employee_type_id = e.employee_type_id
  JOIN dealershipemployees de ON de.employee_id = e.employee_id
  JOIN dealerships d ON de.dealership_id = d.dealership_id
WHERE
  LOWER(et.name) LIKE '%finance%'
GROUP BY
  d.dealership_id;

-- Get the names of the top 3 employees who work shifts at the most dealerships?
SELECT
  e.first_name,
  e.last_name,
  COUNT(d.dealership_id)
FROM
  employees e
  JOIN dealershipemployees de ON de.employee_id = e.employee_id
  JOIN dealerships d ON de.dealership_id = d.dealership_id
GROUP BY
  e.employee_id
ORDER BY
  COUNT(d.dealership_id) DESC
LIMIT
  3;

-- Get a report on the top two employees who has made the most sales through leasing vehicles.
SELECT
  e.first_name,
  e.last_name,
  COUNT(s.sale_id)
FROM
  employees e
  JOIN sales s ON s.employee_id = e.employee_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
GROUP BY
  e.employee_id
ORDER BY
  COUNT(s.sale_id) DESC
LIMIT
  2;

-- Get a report on the the two employees who has made the least number of non-lease sales.
SELECT
  e.first_name,
  e.last_name,
  COUNT(s.sale_id)
FROM
  employees e
  JOIN sales s ON s.employee_id = e.employee_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) NOT LIKE '%lease%'
GROUP BY
  e.employee_id
ORDER BY
  COUNT(s.sale_id) ASC
LIMIT
  2;
 63  inventory_turnover.sql 
@@ -0,0 +1,63 @@
-- Across all dealerships, which model of vehicle has the lowest current inventory?
-- This will help dealerships know which models the purchase from manufacturers.
SELECT
  mo.name,
  COUNT(v.vehicle_id)
FROM
  vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  mo.vehicle_model_id
ORDER BY
  COUNT(v.vehicle_id) ASC;

  ---Inventory

-- Across all dealerships, which model of vehicle has the highest current inventory? 
-- This will help dealerships know which models are, perhaps, not selling.
SELECT
  mo.name,
  COUNT(v.vehicle_id)
FROM
  vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  mo.vehicle_model_id
ORDER BY
  COUNT(v.vehicle_id) DESC;

-- Which dealerships are currently selling the least number of vehicle models? 
-- This will let dealerships market vehicle models more effectively per region.
SELECT
  d.business_name,
  COUNT(mo.vehicle_model_id)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN vehicles v ON s.vehicle_id = v.vehicle_id
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  d.dealership_id
ORDER BY
  COUNT(mo.vehicle_model_id);

-- Which dealerships are currently selling the highest number of vehicle models? 
-- This will let dealerships know which regions have either a high population, or less brand loyalty.
SELECT
  d.business_name,
  COUNT(mo.vehicle_model_id)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN vehicles v ON s.vehicle_id = v.vehicle_id
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  d.dealership_id
ORDER BY
  COUNT(mo.vehicle_model_id) DESC;