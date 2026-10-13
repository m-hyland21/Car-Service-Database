-- Create Customer Table --
CREATE TABLE Customer (
	customer_ID varchar(10) NOT NULL, -- Unique identifier for each customer, must not be NULL --
	customer_name varchar(30) DEFAULT 'Unknown Name',-- The customer's first and last name. Sets default to 'Unknown name' --
	customer_email_address varchar(100) DEFAULT NULL, -- The customer's email address. Sets default to NULL if not given --
	customer_phone_number varchar(15) DEFAULT '000-000-0000', -- The customer's phone number. Sets default to '000-000-0000' if not given --
	CONSTRAINT PK_Customer PRIMARY KEY (customer_ID) -- Ensures customer_ID is unique --
);

-- Create Car Table --
CREATE TABLE Car (
	registration_number varchar(10) NOT NULL, -- Unique identifier for the car, must not be NULL --
	make varchar(20) DEFAULT 'Unknown Make' , -- Make of the car (e.g. Seat). Sets default value to 'Unknown Make' --
	model varchar(20) DEFAULT 'Unknown Model' , -- Model of the car (e.g. Ibiza). Sets default value to 'Unknown Model' --
	date_of_manufacture DATE, -- Date the car was manufactured --
	customer_ID varchar(10), -- References to the Customer table --
	CONSTRAINT PK_Car PRIMARY KEY (registration_number), -- Ensures registration_number is unique --
	CONSTRAINT FK_Car_Customer FOREIGN KEY (customer_ID) REFERENCES Customer (customer_ID) -- References customer_ID in Customer table --
	ON DELETE CASCADE -- If something is deleted in the Customer table, any associated records in the Car table will be deleted --
);

-- Create Service Table --
CREATE TABLE Service ( -- Use square brackets to avoid issues with reserved keyword 'Service' --
	service_ID varchar(10) NOT NULL, -- Unique identifier for service, must not be NULL --
	dropoff_date DATE DEFAULT (CURRENT_DATE), -- Date car was left for service. Sets default to current date --
	dropoff_time TIME(0) DEFAULT '09:00' , -- Time car was left for service. Sets default to '09:00' --
	work_required varchar(100) DEFAULT 'Annual Service' , -- Description of work required for service. Sets Default to 'Annual Service' --
	next_service DATE DEFAULT (DATE_ADD(CURRENT_DATE,INTERVAL 1 YEAR)), -- Date of next service. Sets default to one year from current date --
	mileage INT, -- Current mileage of car at time of service --
	registration_number varchar(10), -- Reference to the Car Table --
	CONSTRAINT PK_Service PRIMARY KEY (service_ID), -- Ensures service_ID is unique --
	CONSTRAINT FK_Service_Car FOREIGN KEY (registration_number) REFERENCES Car (registration_number) -- References registration_number in Car Table --
	ON DELETE CASCADE, -- If something is deleted in the Car table, any associated service records in the Service table will be deleted --
	CONSTRAINT check_mileage CHECK (mileage >= 0) -- Ensures mileage is a valid value and is not negative --
);

-- Create Employee Table -- 
CREATE TABLE Employee (
	employee_ID varchar(10) NOT NULL, -- Unique identifier for each employee, must not be NULL --
	employee_name varchar(50), -- The employee's first and last name --
	employee_phone_number varchar(15) DEFAULT '000-000-0000', -- The employee's phone number. Sets default to '000-000-0000' --
	grade varchar(20) DEFAULT 'Mechanic' , -- The grade of employee (e.g. Senior Mechanic). Sets default to 'Mechanic' --
	CONSTRAINT PK_Employee PRIMARY KEY (employee_ID)-- Ensures employee_ID is unique --
);


-- Create Works_on Table --
CREATE TABLE Works_on (
	service_ID varchar(10) NOT NULL, -- Unique identifier for each service, must not be NULL --
	employee_ID varchar(10) NOT NULL, -- Unique identiier for each employee, must not be NULL --
	time_spent TIME(0) DEFAULT '00:00', -- Tracks the time spent on a service, default is set to '00:00' --
	CONSTRAINT PK_Works_on PRIMARY KEY (service_ID, employee_ID), -- Ensures service_ID and employee_ID are unique --
	CONSTRAINT FK_Works_on_Service FOREIGN KEY (service_ID) REFERENCES Service (service_ID)
	ON DELETE CASCADE, -- If something is deleted in the Service table, any associated records in the Works_on table will be deleted --
	CONSTRAINT FK_Works_on_Employee FOREIGN KEY (employee_ID) REFERENCES Employee (employee_ID)
	ON DELETE CASCADE -- If something is deleted in the Employee table, any associated records in the Works_on table will be deleted --
);
-- This table acts as a link table to show the time_spent on a service and by which employee -- 