CREATE TABLE my_first_table (
    first_column TEXT,
    second_column INT
); 

--Create a Vehicle Table
CREATE TABLE Vehicles (
  vehicle_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  vin VARCHAR(50),
  engine_type VARCHAR(2),
  vehicle_type_id INT REFERENCES VehicleTypes (vehicle_type_id),
  exterior_color VARCHAR(50),
  interior_color VARCHAR(50),
  floor_price INT,
  msr_price INT,
  miles_count INT,
  year_of_car INT
);

--Add a foreign key
FOREIGN KEY (vehicle_type_id) REFERENCES VehicleType(vehicle_type_id)

--Adding a foreign  key constraint to existing table
ALTER TABLE child_table 
  ADD CONSTRAINT constraint_name 
  FOREIGN KEY (fk_columns) 
  REFERENCES parent_table (parent_key_columns);
