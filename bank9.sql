CREATE DATABASE bank;
USE bank;

-- Table: Branch
CREATE TABLE Branch (
    bname VARCHAR(50) PRIMARY KEY,  -- Branch name
    city VARCHAR(50) NOT NULL  -- Branch city
);

-- Table: Customers
CREATE TABLE Customers (
    cname VARCHAR(50) PRIMARY KEY,  -- Customer name
    city VARCHAR(50) NOT NULL  -- Customer city
);

-- Table: Borrow
CREATE TABLE Borrow (
    loanno INT PRIMARY KEY,  -- Loan number
    cname VARCHAR(50) NOT NULL,  -- Customer name
    bname VARCHAR(50) NOT NULL,  -- Branch name
    amount DECIMAL(10, 2) NOT NULL,  -- Loan amount
    FOREIGN KEY (bname) REFERENCES Branch(bname),  -- Foreign Key to Branch
    FOREIGN KEY (cname) REFERENCES Customers(cname)  -- Foreign Key to Customers
);

-- Table: Deposit
CREATE TABLE Deposit (
    actno INT PRIMARY KEY,  -- Account number
    cname VARCHAR(50) NOT NULL,  -- Customer name
    bname VARCHAR(50) NOT NULL,  -- Branch name
    amount DECIMAL(10, 2) NOT NULL,  -- Deposit amount
    adate DATE NOT NULL,  -- Account opening date
    FOREIGN KEY (bname) REFERENCES Branch(bname),  -- Foreign Key to Branch
    FOREIGN KEY (cname) REFERENCES Customers(cname)  -- Foreign Key to Customers
);


-- Inserting data into Branch table
INSERT INTO Branch (bname, city) 
VALUES 
    ('Perryridge', 'New York'),
    ('Karolbagh', 'Delhi'),
    ('Jodhpur', 'Rajasthan'),
    ('Nagpur', 'Maharashtra');

-- Inserting data into Customers table
INSERT INTO Customers (cname, city) 
VALUES 
    ('Anil', 'Pune'),
    ('Sunil', 'Bombay'),
    ('John', 'Nagpur'),
    ('Ravi', 'Delhi');

-- Inserting data into Deposit table
INSERT INTO Deposit (actno, cname, bname, amount, adate)
VALUES 
    (101, 'Anil', 'Perryridge', 5000, '1996-12-01'),
    (102, 'Sunil', 'Karolbagh', 4000, '1997-01-05'),
    (103, 'John', 'Jodhpur', 2000, '1995-04-10'),
    (104, 'Ravi', 'Nagpur', 6000, '1995-03-15'),
    (105, 'Sunil', 'Perryridge', 3000, '1997-04-25');

-- Inserting data into Borrow table
INSERT INTO Borrow (loanno, cname, bname, amount)
VALUES 
    (201, 'Anil', 'Perryridge', 1500),
    (202, 'John', 'Karolbagh', 5000),
    (203, 'Ravi', 'Nagpur', 3000),
    (204, 'Sunil', 'Karolbagh', 2500);

-- ***************************** 9 *****************************

-- 1. Display names of depositors having amount greater than 4000.
-- Query: Display depositors with amount > 4000
SELECT cname FROM Deposit WHERE amount > 4000;

-- 2. Display account date of customer 'Anil'
-- Query: Display account date for Anil
SELECT adate FROM Deposit WHERE cname = 'Anil';

-- 3. Display account no. and deposit amount of customers having account opened between dates '1996-12-01' and '1997-05-01'
-- Query: Display account no and deposit amount of customers with account opened between '1996-12-01' and '1997-05-01'
SELECT actno, amount FROM Deposit WHERE adate BETWEEN '1996-12-01' AND '1997-05-01';

-- 4. Find the average account balance at the 'Perryridge' branch.
-- Query: Average account balance at Perryridge branch
SELECT AVG(amount) FROM Deposit WHERE bname = 'Perryridge';

-- 5. Find the names of all branches where the average account balance is more than $1,200.
-- Query: Branch names where average balance is greater than 1200
SELECT bname FROM Deposit GROUP BY bname HAVING AVG(amount) > 1200;

-- 6. Delete depositors having deposit less than 5000.
-- Query: Delete depositors with less than 5000 deposit
DELETE FROM Deposit WHERE amount < 5000;

-- 7. Create a view on Deposit table.
-- Query: Create view for Deposit table
CREATE VIEW Deposit_View AS 
SELECT * FROM Deposit;


-- ***************************** 10 *****************************
-- Queries for view on Branch
-- a. Display names of all branches located in city 'Bombay'.
SELECT bname FROM Branch WHERE city = 'Bombay';

-- b. Display account no. and amount of depositors.
SELECT actno, amount FROM Deposit;

-- c. Update the city of customer 'Anil' from 'Pune' to 'Mumbai'
UPDATE Customers SET city = 'Mumbai' WHERE cname = 'Anil';

-- d. Find the number of depositors in the bank.
SELECT COUNT(DISTINCT cname) AS num_depositors FROM Deposit;

-- e. Calculate Min, Max amount of customers.
SELECT MIN(amount) AS Min_Amount, MAX(amount) AS Max_Amount FROM Deposit;

-- f. Create an index on Deposit table.
CREATE INDEX idx_amount ON Deposit(amount);

-- g. Create View on Borrow table.
CREATE VIEW Borrow_View AS 
SELECT * FROM Borrow;

-- ***************************** 11 *****************************

-- a. Display account date of customer 'Anil'.
SELECT adate FROM Deposit WHERE cname = 'Anil';

-- b. Modify the size of attribute 'amount' in Deposit.
ALTER TABLE Deposit MODIFY amount DECIMAL(12, 2);

-- c. Display names of customers living in city 'Pune'.
SELECT cname FROM Customers WHERE city = 'Pune';

-- d. Display name of the city where branch 'KAROLBAGH' is located.
SELECT city FROM Branch WHERE bname = 'KAROLBAGH';

-- e. Find the number of tuples in the customer relation.
SELECT COUNT(*) AS num_tuples FROM Customers;

-- f. Delete all records of customer 'Sunil'.
DELETE FROM Customers WHERE cname = 'Sunil';

-- g. Create a view on Deposit table.
CREATE VIEW Deposit_View_2 AS
SELECT * FROM Deposit;



-- ***************************** 12 *****************************

-- 1. Display customer name having living city 'Bombay' and branch city 'Nagpur'.
SELECT cname FROM Customers C, Branch B, Deposit D 
WHERE C.city = 'Bombay' AND B.city = 'Nagpur' AND C.cname = D.cname AND D.bname = B.bname;

-- 2. Display customer name having same living city as their branch city.
SELECT C.cname 
FROM Customers C, Branch B, Deposit D 
WHERE C.city = B.city AND C.cname = D.cname AND D.bname = B.bname;

-- 3. Display customer name who are borrowers as well as depositors and having living city 'Nagpur'.
SELECT DISTINCT C.cname 
FROM Customers C 
JOIN Borrow B ON C.cname = B.cname 
JOIN Deposit D ON C.cname = D.cname 
WHERE C.city = 'Nagpur';

-- 4. Display borrower names having deposit amount greater than 1000 and loan amount greater than 2000.
SELECT B.cname 
FROM Borrow B 
JOIN Deposit D ON B.cname = D.cname 
WHERE D.amount > 1000 AND B.amount > 2000;

-- 5. Display customer name living in the city where branch of depositor 'Sunil' is located.
SELECT DISTINCT C.cname 
FROM Customers C, Branch B, Deposit D 
WHERE C.city = B.city AND D.cname = 'Sunil' AND D.bname = B.bname AND C.cname != 'Sunil';

-- 6. Create an index on Deposit table.
CREATE INDEX idx_customer_deposit ON Deposit(cname, amount);
