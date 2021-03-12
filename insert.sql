--Let's add a new sales type and add a new record for a sale that is of the newly added sales type.
-- INSERT statement to add a new sale:
INSERT INTO public.sales(sales_type_id, vehicle_id, employee_id, dealership_id, price, invoice_number)
VALUES (3, 21, 12, 7, 55999, 123477289);

-- INSERT statement to add a new sales type:
INSERT INTO public.salestypes(name)
VALUES ('Rent');

--Must run sales type first due to foreign constraints above. 


--Inserting Multiple Rows
INSERT INTO 
public.sales(sales_type_id, vehicle_id, employee_id, dealership_id, price, invoice_number)
VALUES 
(3, 21, 12, 7, 55999, 123477289),
(3, 14, 3, 7, 19999, 232727349),
(3, 6, 75, 7, 39500, 8635482010);

--Carnival Practice

--Pick two of your friends or family and write a single INSERT statement to add both of them to the Customers table.

--Think of your dream car. In order to add this car to the Vehicles table, you might need to add data to the VehicleTypes table. Make sure the statements are ordered so that you can execute all your INSERT statements together.

--Use INSERT statements to add a new employee with the following info. This employee works shifts at the first three dealerships listed in your Dealerships table:

--Name: Kennie Maharg
--Email: kmaharge@com.com
--Phone: 598-678-4885
--Role: Customer Service
