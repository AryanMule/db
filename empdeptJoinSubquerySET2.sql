CREATE DATABASE empdeptJoinSubquerySET2;
USE empdeptJoinSubquerySET2;

CREATE TABLE Manager (
    Manager_id INT PRIMARY KEY,
    Manager_name VARCHAR(50)
);

CREATE TABLE Locations (
    Location_id INT PRIMARY KEY,
    Street_address VARCHAR(100),
    Postal_code VARCHAR(20),
    City VARCHAR(50),
    State VARCHAR(50),
    Country_id VARCHAR(3)
);

CREATE TABLE Departments (
    Department_id INT PRIMARY KEY,
    Department_name VARCHAR(50),
    Manager_id INT,
    Location_id INT,
    FOREIGN KEY (Manager_id) REFERENCES Manager(Manager_id),
    FOREIGN KEY (Location_id) REFERENCES Locations(Location_id)
);

CREATE TABLE Employee (
    Employee_id INT PRIMARY KEY,
    First_name VARCHAR(50),
    Last_name VARCHAR(50),
    Hire_date DATE,
    Salary DECIMAL(10, 2),
    Job_title VARCHAR(50),
    Manager_id INT,
    Department_id INT,
    FOREIGN KEY (Manager_id) REFERENCES Manager(Manager_id),
    FOREIGN KEY (Department_id) REFERENCES Departments(Department_id)
);

INSERT INTO Manager (Manager_id, Manager_name) VALUES
(1, 'Alice Johnson'),
(2, 'Bob Brown'),
(3, 'Charles Green');


INSERT INTO Locations (Location_id, Street_address, Postal_code, City, State, Country_id) VALUES
(1, '123 Maple Street', '10001', 'New York', 'NY', 'USA'),
(2, '456 Oak Avenue', '94105', 'San Francisco', 'CA', 'USA'),
(3, '789 Pine Lane', '94107', 'San Francisco', 'CA', 'USA');


INSERT INTO Departments (Department_id, Department_name, Manager_id, Location_id) VALUES
(101, 'Engineering', 1, 1),
(102, 'Sales', 2, 2),
(103, 'Marketing', 3, 3);




INSERT INTO Employee (Employee_id, First_name, Last_name, Hire_date, Salary, Job_title, Manager_id, Department_id) VALUES
(1, 'John', 'Doe', '2020-01-01', 60000, 'Engineer', 1, 101),
(2, 'Jane', 'Smith', '2019-05-10', 75000, 'Sales Executive', 2, 102),
(3, 'Emily', 'Jones', '2018-11-20', 80000, 'Marketing Manager', 3, 103),
(4, 'Michael', 'Singh', '2021-03-15', 65000, 'Engineer', 1, 101),
(5, 'Anna', 'Taylor', '2022-06-25', 70000, 'Engineer', 1, 101),
(6, 'James', 'Brown', '2020-02-25', 55000, 'Sales Representative', 2, 102);


-- Write a query to find the names (first_name, last_name) and the salaries of the employees who have a
-- higher salary than the employee whose last_name=''Singh”.
SELECT First_name, Last_name, Salary
FROM Employee
WHERE Salary > (
    SELECT Salary
    FROM Employee
    WHERE Last_name = 'Singh'
);

-- Write a query to find the names (first_name, last_name) of the employees who have a manager and
-- work for a department based in the United States
SELECT e.First_name, e.Last_name
FROM Employee e
JOIN Departments d ON e.Department_id = d.Department_id
JOIN Locations l ON d.Location_id = l.Location_id
WHERE e.Manager_id IS NOT NULL
AND l.Country_id = 'USA';

-- Write a query to find the names (first_name, last_name), the salary of the employees whose salary is
-- greater than the average salary.
SELECT First_name, Last_name, Salary
FROM Employee
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employee
);

-- Write a query to find the employee id, name (last_name) along with their manager_id, manager name
-- (last_name).
SELECT e.Employee_id, e.Last_name AS Employee_Last_Name, e.Manager_id, m.Manager_name AS Manager_Name
FROM Employee e
JOIN Manager m ON e.Manager_id = m.Manager_id;

-- Find the names and hire date of the employees who were hired after 'Jones'.
SELECT First_name, Last_name, Hire_date
FROM Employee
WHERE Hire_date > (
    SELECT Hire_date
    FROM Employee
    WHERE Last_name = 'Jones'
);



-- ******************************************  PROB17 SET2  *************************************************

-- Query 1: Find employees in IT departments with a salary above the average salary.
SELECT e.First_name, e.Last_name, e.Salary
FROM Employee e
JOIN Departments d ON e.Department_id = d.Department_id
WHERE e.Salary > (SELECT AVG(Salary) FROM Employee)
  AND d.Department_name LIKE '%IT%';

-- Query 2: Find employees who earn the same salary as the minimum salary across all departments.
SELECT e.First_name, e.Last_name, e.Salary
FROM Employee e
WHERE e.Salary = (SELECT MIN(Salary) FROM Employee);

-- Query 3: Find employees whose salary is above the average for their respective departments.
SELECT e.Employee_id, e.First_name, e.Last_name, e.Salary
FROM Employee e
JOIN Departments d ON e.Department_id = d.Department_id
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employee
    WHERE Department_id = e.Department_id
);

-- Query 4: Display the department name, manager name, and city.
SELECT d.Department_name, m.Manager_name, l.City
FROM Departments d
JOIN Manager m ON d.Manager_id = m.Manager_id
JOIN Locations l ON d.Location_id = l.Location_id;

-- Query 5: Find managers with experience over 15 years.
SELECT e.First_name, e.Last_name, e.Hire_date, e.Salary
FROM Employee e
JOIN Manager m ON e.Employee_id = m.Manager_id
WHERE DATEDIFF(CURDATE(), e.Hire_date) / 365 > 15;

