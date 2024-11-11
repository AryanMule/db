-- Create the database
CREATE DATABASE clientmaster;
USE clientmaster;

-- Create the table
CREATE TABLE client_master (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(100),
    bal_due DECIMAL(10, 2)
);

-- Insert sample data with unique client_id values
INSERT INTO client_master (client_id, client_name, bal_due) VALUES
(1, 'John Doe', 500.00),
(2, 'Jane Smith', -100.00),  -- This violates the business rule
(3, 'Sam Brown', 200.00),
(4, 'Emma White', -50.00);   -- This also violates the business rule

-- Change delimiter to allow creating the procedure
DELIMITER $$

CREATE PROCEDURE CheckBalanceDue(IN in_client_id INT)
BEGIN
    -- Declare variable to store balance due
    DECLARE v_bal_due DECIMAL(10, 2);

    -- Retrieve the balance due for the specified client
    SELECT bal_due INTO v_bal_due
    FROM client_master
    WHERE client_id = in_client_id;

    -- Check if balance due violates the business rule (less than 0)
    IF v_bal_due < 0 THEN
        -- Raise a user-defined exception
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Business Rule Violation: Balance due cannot be negative.';
    ELSE
        -- If rule is not violated, display balance due
        SELECT 'Balance due is valid.' AS Message, v_bal_due AS Current_Balance;
    END IF;
END$$

DELIMITER ;

-- Test the procedure
CALL CheckBalanceDue(1); -- This should return a valid balance
CALL CheckBalanceDue(2); -- This should trigger the user-defined exception
