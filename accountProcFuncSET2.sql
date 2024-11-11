-- Create the database
CREATE DATABASE accountProcFuncSET2;
USE accountProcFuncSET2;

-- Create the Account Table
CREATE TABLE Account (
    Account_No INT PRIMARY KEY,
    Cust_Name VARCHAR(100),
    Balance DECIMAL(10, 2),
    NoOfYears INT
);

-- Create the Earned_Interest Table
CREATE TABLE Earned_Interest (
    Account_No INT PRIMARY KEY,
    Interest_Amt DECIMAL(10, 2),
    FOREIGN KEY (Account_No) REFERENCES Account(Account_No)
);

-- Inserting sample data into Account table
INSERT INTO Account (Account_No, Cust_Name, Balance, NoOfYears) VALUES
(101, 'John Doe', 100000, 5),
(102, 'Jane Smith', 25000, 2),
(103, 'Alice Johnson', 70000, 3),
(104, 'Bob Brown', 5000, 1);

-- Procedure to Calculate and Store Simple Interest
DELIMITER $$

CREATE PROCEDURE CalculateAndStoreInterest(IN input_Account_No INT, IN Interest_Rate DECIMAL(5, 2))
BEGIN
    DECLARE principal DECIMAL(10, 2);
    DECLARE years INT;
    DECLARE interest_amount DECIMAL(10, 2);
    
    -- Fetch Balance and NoOfYears for the given Account_No
    SELECT Balance, NoOfYears INTO principal, years
    FROM Account
    WHERE Account_No = input_Account_No;
    
    -- Calculate the Simple Interest
    SET interest_amount = (principal * Interest_Rate * years) / 100;
    
    -- Insert the interest amount into Earned_Interest table
    INSERT INTO Earned_Interest (Account_No, Interest_Amt)
    VALUES (input_Account_No, interest_amount);
    
    -- Display all records from Earned_Interest table
    SELECT * FROM Earned_Interest;
END $$

DELIMITER ;

-- Call the procedure to calculate and store the interest for Account_No 101 with an interest rate of 5%
CALL CalculateAndStoreInterest(101, 5);

-- Procedure to Display Accounts with Balance Greater Than 50,000
DELIMITER $$

CREATE PROCEDURE GetHighBalanceAccounts()
BEGIN
    -- Return all records with Balance > 50000
    SELECT Account_No, Cust_Name, Balance, NoOfYears
    FROM Account
    WHERE Balance > 50000;
END $$

DELIMITER ;

-- Call the procedure to get accounts with balance greater than 50,000
CALL GetHighBalanceAccounts();
