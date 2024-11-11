CREATE DATABASE bankmanager;
USE bankmanager;

CREATE TABLE IF NOT EXISTS Account (
    Account_No INT PRIMARY KEY,
    Last_Transaction_Date DATE,
    Status VARCHAR(10)
);

-- Insert sample data for testing
INSERT INTO Account (Account_No, Last_Transaction_Date, Status)
VALUES 
    (1, DATE_SUB(CURDATE(), INTERVAL 400 DAY), 'Inactive'),
    (2, DATE_SUB(CURDATE(), INTERVAL 100 DAY), 'Inactive'),
    (3, DATE_SUB(CURDATE(), INTERVAL 500 DAY), 'Inactive'),
    (4, DATE_SUB(CURDATE(), INTERVAL 200 DAY), 'Active');

-- Change the delimiter to create the procedure
DELIMITER $$

-- Create the stored procedure to activate accounts
CREATE PROCEDURE ActivateInactiveAccounts()
BEGIN
    -- Update accounts that have been inactive for more than 365 days
    UPDATE Account
    SET Status = 'Active'
    WHERE Status = 'Inactive' AND DATEDIFF(CURDATE(), Last_Transaction_Date) > 365
    AND Account_No IS NOT NULL;  -- Ensure a key column is used in the WHERE clause
    -- Check how many rows were updated and display an appropriate message
    IF ROW_COUNT() > 0 THEN
        SELECT CONCAT(ROW_COUNT(), ' account(s) were reactivated.') AS Message;
    ELSE
        SELECT 'No accounts were found for reactivation.' AS Message;
    END IF;

END$$

-- Reset the delimiter
DELIMITER ;

-- Execute the procedure
CALL ActivateInactiveAccounts();

-- To check the result after running the procedure
SELECT * FROM Account;
