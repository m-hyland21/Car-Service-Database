-- STORED PROCEDURE: AddServiceBooking. --
-- Inserts a new service record based on parameter values supplied. --
-- Supports Business Process 1 (add a service booking). --

DELIMITER $$

CREATE PROCEDURE AddServiceBooking(
    IN p_serviceID        VARCHAR(10),     -- unique ID for the service. --
    IN p_registration     VARCHAR(10),     -- car registration number (FK). --
    IN p_dropoff_date     DATE,            -- date car was dropped off. --
    IN p_dropoff_time     TIME,            -- time car was dropped off. --
    IN p_work_required    VARCHAR(100),    -- description of work needed. --
    IN p_mileage          INT              -- mileage at time of service. --
)
BEGIN
    -- Insert a new service record into the Service table using the --
    -- parameter values passed into the stored procedure. --

    INSERT INTO Service (
        service_ID,             -- primary key for Service table. --
        registration_number,    -- foreign key referencing Car table. --
        dropoff_date,           -- date car arrived at the garage. --
        dropoff_time,           -- time car arrived. --
        work_required,          -- type of work requested. --
        mileage                 -- mileage value provided. --
        -- next_service is NOT included here because the trigger --
        -- will automatically calculate and set it. --
    )
    VALUES (
        p_serviceID,            -- value supplied when procedure is called. --
        p_registration,         -- registration of the car being serviced. --
        p_dropoff_date,         -- date passed to procedure. --
        p_dropoff_time,         -- time passed to procedure. --
        p_work_required,        -- work description passed to procedure. --
        p_mileage               -- mileage passed to procedure. --
    );
END $$

DELIMITER ;


-- TRIGGER: set_next_service_date. --
-- BEFORE INSERT trigger that automatically sets the next_service. --
-- date to 1 year after the drop-off date. --
-- Mirrors BEFORE INSERT triggers demonstrated in lectures. --
-- Enforces business rule: annual service cycle. --

DELIMITER $$

CREATE TRIGGER set_next_service_date
BEFORE INSERT ON Service         -- trigger fires BEFORE a new row is added. --
FOR EACH ROW                     -- applies to every inserted row individually. --
BEGIN
    -- Automatically generate the next service date by adding one year --
    -- to the dropoff_date provided in the new service booking. --
    -- Ensures consistency and prevents human error during data entry. --
    SET NEW.next_service = DATE_ADD(NEW.dropoff_date, INTERVAL 1 YEAR);
END $$

DELIMITER ;


-- Calling the stored procedure to add a new service record. --
-- Note: next_service will be set automatically by the trigger. --

CALL AddServiceBooking(
    'S2006-150',        -- service_ID. --
    'SEZ 5629',     -- registration_number (FK must exist in Car). --
    '2020-06-25',   -- dropoff_date. --
    '09:00:00',     -- dropoff_time. --
    'Annual Service', -- work_required. --
	25000           -- mileage. --
);



