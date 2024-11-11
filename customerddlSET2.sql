CREATE DATABASE customerset2;
use customerset2;


-- Create Customer table
CREATE TABLE Customer (
    CustID INT PRIMARY KEY,
    Name VARCHAR(50),
    Cust_Address VARCHAR(100),
    Phone_no VARCHAR(15),
    Email_ID VARCHAR(50),
    Age INT
);

-- Create Branch table
CREATE TABLE Branch (
    Branch_ID INT PRIMARY KEY,
    Branch_Name VARCHAR(50),
    Address VARCHAR(100)
);

-- Create Account table with foreign key references to Customer and Branch
CREATE TABLE Account (
    Account_no INT PRIMARY KEY,
    Branch_ID INT,
    CustID INT,
    open_date DATE,
    Account_type VARCHAR(20),
    Balance DECIMAL(15, 2),
    FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID),
    FOREIGN KEY (CustID) REFERENCES Customer(CustID)
);


-- Insert data into Customer table
INSERT INTO Customer (CustID, Name, Cust_Address, Phone_no, Email_ID, Age)
VALUES (101, 'John Doe', 'Mumbai', '1234567890', 'john.doe@example.com', 30),
       (102, 'Jane Smith', 'Delhi', '0987654321', 'jane.smith@example.com', 28),
       (103, 'Alice Brown', 'Mumbai', '1122334455', 'alice.brown@example.com', 34);

-- Insert data into Branch table
INSERT INTO Branch (Branch_ID, Branch_Name, Address)
VALUES (1, 'Main Branch', 'Mumbai'),
       (2, 'Delhi Branch', 'Delhi');

-- Insert data into Account table
INSERT INTO Account (Account_no, Branch_ID, CustID, open_date, Account_type, Balance)
VALUES (1001, 1, 101, '2018-08-16', 'Saving', 50000.00),
       (1002, 2, 102, '2018-02-16', 'Loan', 200000.00),
       (1003, 1, 103, '2018-08-16', 'Saving', 75000.00);



-- 3. Draw the ER Diagram
-- Here’s a simple description of the ER diagram for this schema:

-- Entities:
-- Customer with attributes CustID (PK), Name, Cust_Address, Phone_no, Email_ID, Age.
-- Branch with attributes Branch_ID (PK), Branch_Name, Address.
-- Account with attributes Account_no (PK), Branch_ID (FK), CustID (FK), open_date, Account_type, Balance.
-- Relationships:
-- One-to-Many relationship from Customer to Account (a customer can have multiple accounts).
-- One-to-Many relationship from Branch to Account (a branch can have multiple accounts).

-- 4. Create a View for Saving Accounts with Open Date as 16/8/2018
CREATE VIEW Saving_Account_View AS
SELECT c.CustID, c.Name, c.Cust_Address, c.Phone_no, c.Email_ID, c.Age, a.open_date
FROM Customer c
JOIN Account a ON c.CustID = a.CustID
WHERE a.Account_type = 'Saving' AND a.open_date = '2018-08-16';


-- 5. Update the View with Cust_Address as Pune for CustID = 103
UPDATE Customer
SET Cust_Address = 'Pune'
WHERE CustID = 103;

-- 6. Create a View for Loan Accounts with Open Date as 16/2/2018
CREATE VIEW Loan_Account_View AS
SELECT c.CustID, c.Name, c.Cust_Address, c.Phone_no, c.Email_ID, c.Age, a.open_date
FROM Customer c
JOIN Account a ON c.CustID = a.CustID
WHERE a.Account_type = 'Loan' AND a.open_date = '2018-02-16';

-- 7. Create an Index on the Primary Key Column of the Customer Table
CREATE INDEX idx_customer_custid ON Customer(CustID);

-- 8. Create an Index on the Primary Key Column of the Branch Table
CREATE INDEX idx_branch_branchid ON Branch(Branch_ID);

-- 9. Create a Sequence on Customer Table
-- Step 1: Drop the foreign key constraint temporarily
ALTER TABLE Account DROP FOREIGN KEY account_ibfk_2;
-- Step 2: Modify CustID column in Customer table to AUTO_INCREMENT
ALTER TABLE Customer MODIFY CustID INT AUTO_INCREMENT;
-- Step 3: Re-add the foreign key constraint
ALTER TABLE Account 
ADD CONSTRAINT account_ibfk_2 
FOREIGN KEY (CustID) REFERENCES Customer(CustID);


-- 10. Create a Synonym for the Branch Table
CREATE VIEW Cust_info AS
SELECT * FROM Branch;




