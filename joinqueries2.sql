--Write a query that shows the total purchase sales income per dealership.
SELECT d.business_name,
    sum(s.price)::double precision::numeric::money AS purchase_income
   FROM dealerships d
     JOIN sales s ON d.dealership_id = s.dealership_id
     JOIN salestypes st ON s.sales_type_id = st.sales_type_id
  GROUP BY d.business_name
  ORDER BY (sum(s.price)::double precision::numeric::money) DESC;

  ---Write a query that shows the purchase sales income per dealership for the current month.
SELECT d.business_name, SUM(s.price), date_part('month', current_timestamp)
FROM dealerships d
INNER JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 1 AND date_part('month', s.purchase_date)=date_part('month', current_timestamp)
GROUP BY d.business_name;

--Write a query that shows the purchase sales income per dealership for the current year.
SELECT d.business_name, SUM(s.price), date_part('year', current_timestamp)
FROM dealerships d
INNER JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 1 AND date_part('year', s.purchase_date)=date_part('year', current_timestamp)
GROUP BY d.business_name;

--Write a query that shows the total lease income per dealership.
SELECT d.business_name, SUM(s.price)
FROM dealerships d
INNER JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 2
GROUP BY d.business_name;

--Write a query that shows the lease income per dealership for the current month.
SELECT d.business_name, SUM(s.price), date_part('month', current_timestamp)
FROM dealerships d
INNER JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 2 AND date_part('month', s.purchase_date)=date_part('month', current_timestamp)
GROUP BY d.business_name

---Write a query that shows the lease income per dealership for the current year.
SELECT d.business_name, SUM(s.price), date_part('year', current_timestamp)
FROM dealerships d
INNER JOIN sales s ON d.dealership_id = s.dealership_id
WHERE s.sales_type_id = 2 AND date_part('year', s.purchase_date)=date_part('year', current_timestamp)
GROUP BY d.business_name

--Write a query that shows the total income (purchase and lease) per employee.
select
  e.last_name || ', ' || e.first_name as employee_name,
  sum(s.price) ::float8::numeric::money as total_sales
from employees e
  join sales s on e.employee_id=s.employee_id
group by employee_name
order by total_sales DESC;

--OR

SELECT CONCAT(e.first_name, ' ', e.last_name) AS name, SUM(s.price)
FROM sales s
LEFT JOIN employees e ON s.employee_id = e.employee_id
GROUP BY name
ORDER BY name asc;

--Which model of vehicle has the lowest current inventory? This will help dealerships know which models the purchase from manufacturers.
---WITH CTE
WITH vm_count AS 
(
SELECT 
DISTINCT ON (d.dealership_id) d.dealership_id,
d.business_name,
(vm.name) AS MODEL,
(vm.vehicle_model_id) AS MODELID,
count(vm.vehicle_model_id) as vm_inventory
FROM vehicles v
LEFT JOIN dealerships d on v.dealership_location_id = d.dealership_id
JOIN vehicleTypes vt on v.vehicle_type_id = vt.vehicle_type_id
JOIN vehicleModel vm ON vt.vehicle_model_id = vm.vehicle_model_id
GROUP BY d.dealership_id, vm.vehicle_model_id
ORDER BY d.dealership_id, count(vm.vehicle_model_id)
)
SELECT dealership_id, business_name, model, modelid, vm_inventory 
FROM vm_count

-- Which model of vehicle has the highest current inventory? This will help dealerships know which models are, perhaps, not selling.
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

  ---Which dealerships are currently selling the least number of vehicle models? This will let dealerships market vehicle models more effectively per region.
  SELECT vmo.name,
    count(vmo.vehicle_model_id) AS vehicle_counts
   FROM vehicles v
     JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
     JOIN vehiclemodel vmo ON vt.vehicle_model_id = vmo.vehicle_model_id
  WHERE v.is_sold = false
  GROUP BY vmo.name
  ORDER BY (count(vmo.vehicle_model_id)) DESC;

  --Which dealerships are currently selling the highest number of vehicle models? This will let dealerships know which regions have either a high population, or less brand loyalty.
  SELECT d.business_name,
COUNT(vmo.name) AS model_count
FROM Vehicles v
JOIN Dealerships d ON d.dealership_id = v.dealership_location_id
VehicleTypes vt ON vt.vehicle_type_id = v.vehicle_type_id
JOIN VehicleModel vmo ON vmo.vehicle_model_id = vt.model
GROUP BY d.business_name
ORDER BY model_count DESC
LIMIT 10;

-- How many employees are there for each role?
SELECT et.name, count(e.employee_id) as employee_count
FROM employees e join employeetypes et on e.employee_type_id=et.employee_type_id
GROUP BY et.name
ORDER BY vehicle_body_type_id et.name;

--How many finance managers work at each dealership?
SELECT d. business_name,
COUNT(d.employee_id)
FROM employeestypes et
JOIN employees e ON et.employee_type_id = e.employee_type_id AND e.employee_type_id = 2
JOIN dealershipemployees de ON de.employee_id = e.employee_id
JOIN dealerships d ON de.dealership_id = d.dealership_id
GROUP BY d.dealership_id;

-- Get the names of the top 3 employees who work shifts at the most dealerships?
--?

--Get a report on the top two employees who has made the most sales through leasing vehicles.
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

  --What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?



  --- What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?



  --What are the top 5 dealerships with the most customers?


  --Who are the top 5 dealership for generating sales income?


  --Which employees generate the most income per dealership?

  --In our Vehicle inventory, show the count of each Model that is in stock.

  --In our Vehicle inventory, show the count of each Make that is in stock.

  --In our Vehicle inventory, show the count of each BodyType that is in stock.

  --Which US state's customers have the highest average purchase price for a vehicle?

  --Now using the data determined above, which 5 states have the customers with the highest average purchase price for a vehicle?
  