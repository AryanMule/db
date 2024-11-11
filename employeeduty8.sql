CREATE DATABASE employeeduty;
USE employeeduty;

-- Table: Employee
CREATE TABLE Employee (
    emp_no INT PRIMARY KEY,  -- Employee number (Primary Key)
    name VARCHAR(50) NOT NULL,  -- Employee name
    skill VARCHAR(50) NOT NULL,  -- Employee skill (e.g., Chef, Manager, etc.)
    pay_rate DECIMAL(10, 2) NOT NULL  -- Employee's pay rate
);

-- Table: Position
CREATE TABLE `Position` (
    posting_no INT PRIMARY KEY,  -- Position number (Primary Key)
    skill VARCHAR(50) NOT NULL  -- Skill required for the position (e.g., Chef, Manager, etc.)
);

-- Table: Duty_allocation
CREATE TABLE Duty_allocation (
    posting_no INT,  -- Position number (Foreign Key)
    emp_no INT,  -- Employee number (Foreign Key)
    day DATE,  -- Date of duty
    shift VARCHAR(10),  -- Shift (e.g., morning, evening, night)
    PRIMARY KEY (posting_no, emp_no, day, shift),  -- Composite primary key
    FOREIGN KEY (posting_no) REFERENCES `Position`(posting_no),  -- Foreign Key to Position table
    FOREIGN KEY (emp_no) REFERENCES Employee(emp_no)  -- Foreign Key to Employee table
);

-- Inserting data into Employee table
INSERT INTO Employee (emp_no, name, skill, pay_rate)
VALUES 
    (123459, 'John Doe', 'Chef', 15.50),
    (123460, 'Jane Roe', 'Chef', 16.00),
    (123461, 'Sam Poe', 'Manager', 18.00),
    (123462, 'Ann Joe', 'Waiter', 14.00),
    (123463, 'xyz', 'Chef', 17.00);

-- Inserting data into Position table
INSERT INTO `Position` (posting_no, skill)
VALUES 
    (1, 'Chef'),
    (2, 'Manager'),
    (3, 'Waiter');

-- Inserting data into Duty_allocation table
INSERT INTO Duty_allocation (posting_no, emp_no, day, shift)
VALUES 
    (1, 123459, '1986-04-10', 'morning'),
    (1, 123460, '1986-04-11', 'evening'),
    (2, 123461, '1986-04-15', 'morning'),
    (3, 123462, '1986-04-20', 'night'),
    (1, 123463, '1986-04-15', 'morning');

-- 1. Get the duty allocation details for emp_no 123461 for the month of April 1986.
SELECT * 
FROM Duty_allocation
WHERE emp_no = 123461 
  AND MONTH(day) = 4 
  AND YEAR(day) = 1986;

-- 2. Find the shift details for Employee ‘xyz’.
SELECT DA.shift, DA.day, DA.posting_no 
FROM Duty_allocation DA
JOIN Employee E ON DA.emp_no = E.emp_no
WHERE E.name = 'xyz';

-- 3. Get employees whose rate of pay is more than or equal to the rate of pay of employee ‘xyz’.
SELECT * 
FROM Employee
WHERE pay_rate >= (SELECT pay_rate FROM Employee WHERE name = 'xyz');

-- 4. Get the names and pay rates of employees with emp_no less than 123460 whose rate of pay is more than the rate of pay of at least one employee with emp_no greater than or equal to 123460.
SELECT E1.name, E1.pay_rate
FROM Employee E1
WHERE E1.emp_no < 123460 
  AND E1.pay_rate > (SELECT MIN(E2.pay_rate) 
                     FROM Employee E2 
                     WHERE E2.emp_no >= 123460);

-- 5. Find the names of employees who are assigned to all positions that require a Chef’s skill.
SELECT E.name
FROM Employee E
WHERE E.skill = 'Chef'
  AND NOT EXISTS (
      SELECT P.posting_no
      FROM `Position` P
      WHERE P.skill = 'Chef'
        AND NOT EXISTS (
            SELECT DA.posting_no
            FROM Duty_allocation DA
            WHERE DA.posting_no = P.posting_no
              AND DA.emp_no = E.emp_no
        )
  );

-- 6. Find the employees with the lowest pay rate.
SELECT * 
FROM Employee
WHERE pay_rate = (SELECT MIN(pay_rate) FROM Employee);

-- 7. Get the employee numbers of all employees working on at least two dates.
SELECT emp_no
FROM Duty_allocation
GROUP BY emp_no
HAVING COUNT(DISTINCT day) >= 2;

-- 8. Get a list of names of employees with the skill of Chef who are assigned a duty.
SELECT DISTINCT E.name
FROM Employee E
JOIN Duty_allocation DA ON E.emp_no = DA.emp_no
WHERE E.skill = 'Chef';

-- 9. Get a list of employees not assigned a duty.
SELECT name
FROM Employee E
WHERE NOT EXISTS (
    SELECT 1 
    FROM Duty_allocation DA 
    WHERE E.emp_no = DA.emp_no
);

-- 10. Get a count of different employees on each shift.
SELECT shift, COUNT(DISTINCT emp_no) AS employee_count
FROM Duty_allocation
GROUP BY shift;
