CREATE DATABASE customerdmlSET22;
USE customerdmlSET22;

-- Create Customer table
CREATE TABLE Customer (
    CustID INT PRIMARY KEY,
    Name VARCHAR(100),
    Cust_Address VARCHAR(200),
    Phone_no VARCHAR(15),
    Email_ID VARCHAR(50),
    Age INT
);

-- Insert data into Customer table
INSERT INTO Customer (CustID, Name, Cust_Address, Phone_no, Email_ID, Age) VALUES
(1, 'Alice Green', 'Pune', '9876543210', 'alice@example.com', 28),
(2, 'Bob Smith', 'Mumbai', '9876543211', 'bob@example.com', 35),
(3, 'Aria Brown', 'Pune', '9876543212', 'aria@example.com', 42),
(4, 'John Doe', 'Delhi', '9876543213', 'john@example.com', 30);

-- Create Branch table
CREATE TABLE Branch (
    BranchID INT PRIMARY KEY,
    Branch_Name VARCHAR(100),
    Address VARCHAR(200)
);

-- Insert data into Branch table
INSERT INTO Branch (BranchID, Branch_Name, Address) VALUES
(1, 'Central', 'Mumbai'),
(2, 'East', 'Pune'),
(3, 'West', 'Delhi');

-- Create Account table
CREATE TABLE Account (
    Account_no INT PRIMARY KEY,
    BranchID INT,
    CustID INT,
    date_open DATE,
    Account_type VARCHAR(20),
    Balance DECIMAL(10, 2),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (CustID) REFERENCES Customer(CustID)
);

-- Insert data into Account table
INSERT INTO Account (Account_no, BranchID, CustID, date_open, Account_type, Balance) VALUES
(1001, 1, 1, '2021-01-15', 'Saving Account', 75000),
(1002, 2, 2, '2022-03-20', 'Current Account', 45000),
(1003, 3, 3, '2020-07-12', 'Saving Account', 55000),
(1004, 2, 4, '2019-11-10', 'Saving Account', 15000);

-- Step 2: Modify the size of column “Email_ID” to 20 in Customer table.
ALTER TABLE Customer MODIFY Email_ID VARCHAR(20);

-- Step 3: Change the column “Email_ID” to Not Null in Customer table.
ALTER TABLE Customer MODIFY Email_ID VARCHAR(20) NOT NULL;

-- Step 4: Display the total customers with balance > 50,000 Rs.
SELECT COUNT(*) AS Total_Customers_With_High_Balance
FROM Account
WHERE Balance > 50000;

-- Step 5: Display average balance for account type=”Saving Account”.
SELECT AVG(Balance) AS Avg_Balance_Saving_Account
FROM Account
WHERE Account_type = 'Saving Account';

-- Step 6: Display customer details for those who live in Pune or have names starting with 'A'.
SELECT *
FROM Customer
WHERE Cust_Address = 'Pune' OR Name LIKE 'A%';

-- Step 7: Create a table Saving_Account using Account Table for accounts of type 'Saving Account'.
CREATE TABLE Saving_Account AS
SELECT Account_no, BranchID, CustID, date_open, Balance
FROM Account
WHERE Account_type = 'Saving Account';

-- Step 8: Display customer details age-wise with balance >= 20,000 Rs.
SELECT Customer.*
FROM Customer
JOIN Account ON Customer.CustID = Account.CustID
WHERE Account.Balance >= 20000
ORDER BY Customer.Age;
