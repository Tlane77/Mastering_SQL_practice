---Creating Three Vehicle Tables
CREATE TABLE "VehicleBodyType" (
 "vehicle_body_type_id" int,
 "name" varchar(20)
);
CREATE INDEX "pk" ON "VehicleBodyType" ("vehicle_body_type_id");
CREATE TABLE "VehicleModel" (
 "vehicle_model_id" int,
 "name" varchar(20)
);
CREATE INDEX "pk" ON "VehicleModel" ("vehicle_model_id");
CREATE TABLE "VehicleMake" (
 "vehicle_make_id" int,
 "name" varchar(20)
);
CREATE INDEX "pk" ON "VehicleMake" ("vehicle_make_id"); 