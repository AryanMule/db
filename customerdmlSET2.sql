create DATABASE customerDMLset2;
use customerDMLset2;

-- Step 1: Create Tables
CREATE TABLE Customer (
    CustID INT PRIMARY KEY,
    Name VARCHAR(100),
    Cust_Address VARCHAR(255),
    Phone_no VARCHAR(15),
    Age INT
);

CREATE TABLE Branch (
    Branch_ID INT PRIMARY KEY,
    Branch_Name VARCHAR(100),
    Address VARCHAR(255)
);

CREATE TABLE Account (
    Account_no INT PRIMARY KEY,
    Branch_ID INT,
    CustID INT,
    date_open DATE,
    Account_type VARCHAR(50),
    Balance DECIMAL(15,2),
    FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID),
    FOREIGN KEY (CustID) REFERENCES Customer(CustID)
);

-- Step 2: Insert Sample Data into Tables

-- Inserting into Customer table
INSERT INTO Customer (CustID, Name, Cust_Address, Phone_no, Age) VALUES
(1, 'John Doe', 'Pune', '9876543210', 40),
(2, 'Jane Smith', 'Mumbai', '9123456789', 30),
(3, 'Sam Brown', 'Pune', '9324765450', 45),
(4, 'Emma White', 'Delhi', '9654321098', 25);

-- Inserting into Branch table
INSERT INTO Branch (Branch_ID, Branch_Name, Address) VALUES
(1, 'Pune Branch', 'Pune'),
(2, 'Mumbai Branch', 'Mumbai'),
(3, 'Delhi Branch', 'Delhi');

-- Inserting into Account table
INSERT INTO Account (Account_no, Branch_ID, CustID, date_open, Account_type, Balance) VALUES
(101, 1, 1, '2020-01-15', 'Saving Account', 5000),
(102, 2, 2, '2019-11-12', 'Current Account', 1500),
(103, 3, 3, '2020-06-10', 'Saving Account', 10000),
(104, 1, 4, '2021-05-22', 'Saving Account', 2000);

-- Step 3: Add the column “Email_Address” in Customer table
ALTER TABLE Customer ADD Email_Address VARCHAR(100);

-- Step 4: Change the name of column “Email_Address” to “Email_ID” in Customer table
ALTER TABLE Customer RENAME COLUMN Email_Address TO Email_ID;

-- Step 5: Display the customer details with the highest balance in the account.
SELECT c.CustID, c.Name, c.Cust_Address, c.Phone_no, c.Age, a.Account_no, a.Balance
FROM Customer c
JOIN Account a ON c.CustID = a.CustID
WHERE a.Balance = (SELECT MAX(Balance) FROM Account);

-- Step 6: Display the customer details with the lowest balance for account type = “Saving Account”.
SELECT c.CustID, c.Name, c.Cust_Address, c.Phone_no, c.Age, a.Account_no, a.Balance
FROM Customer c
JOIN Account a ON c.CustID = a.CustID
WHERE a.Account_type = 'Saving Account'
AND a.Balance = (SELECT MIN(Balance) FROM Account WHERE Account_type = 'Saving Account');

-- Step 7: Display the customer details that live in Pune and have age greater than 35.
SELECT c.CustID, c.Name, c.Cust_Address, c.Phone_no, c.Age
FROM Customer c
WHERE c.Cust_Address = 'Pune' AND c.Age > 35;

-- Step 8: Display the Cust_ID, Name, and Age of the customer in ascending order of their age.
SELECT c.CustID, c.Name, c.Age
FROM Customer c
ORDER BY c.Age ASC;

-- Step 9: Display the Name and Branch ID of the customer grouped by the Account_type
SELECT a.Account_type, b.Branch_ID, GROUP_CONCAT(c.Name) AS Customer_Names
FROM Account a
JOIN Branch b ON a.Branch_ID = b.Branch_ID
JOIN Customer c ON a.CustID = c.CustID
GROUP BY a.Account_type, b.Branch_ID;
