CREATE DATABASE company_db;
USE company_db;

CREATE TABLE employee (
    employee_name VARCHAR(50) PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE works (
    employee_name VARCHAR(50),
    company_name VARCHAR(50),
    salary DECIMAL(10, 2),
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name)
);

CREATE TABLE company (
    company_name VARCHAR(50) PRIMARY KEY,
    city VARCHAR(50)
);

CREATE TABLE manages (
    employee_name VARCHAR(50),
    manager_name VARCHAR(50),
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name)
);

INSERT INTO employee (employee_name, street, city)
VALUES 
('Alice Johnson', '123 Maple St', 'New York'),
('Bob Smith', '456 Oak St', 'San Francisco'),
('Charlie Brown', '789 Pine St', 'Los Angeles'),
('Daisy Green', '101 Elm St', 'Chicago'),
('Edward White', '202 Cedar St', 'New York');

INSERT INTO company (company_name, city)
VALUES 
('First Bank Corporation', 'New York'),
('Tech Solutions', 'San Francisco'),
('Small Bank Corporation', 'Chicago'),
('MegaCorp', 'Los Angeles'),
('Finance Hub', 'New York');

INSERT INTO works (employee_name, company_name, salary)
VALUES 
('Alice Johnson', 'First Bank Corporation', 12000),
('Bob Smith', 'Tech Solutions', 15000),
('Charlie Brown', 'Small Bank Corporation', 9000),
('Daisy Green', 'First Bank Corporation', 11000),
('Edward White', 'Finance Hub', 13000),
('Alice Johnson', 'Finance Hub', 14000);   
INSERT INTO manages (employee_name, manager_name)
VALUES 
('Alice Johnson', 'Bob Smith'),
('Charlie Brown', 'Alice Johnson'),
('Daisy Green', 'Charlie Brown'),
('Edward White', 'Daisy Green');


-- Find the names of all employees who work for First Bank Corporation
SELECT employee_name
FROM works
WHERE company_name = 'First Bank Corporation';

-- Find all employees who do not work for First Bank Corporation
SELECT employee_name
FROM works
WHERE company_name != 'First Bank Corporation';

-- Find the company that has the most employees:   
SELECT company_name
FROM works
GROUP BY company_name
ORDER BY COUNT(employee_name) DESC
LIMIT 1;

-- Find all companies located in every city in which Small Bank Corporation is located:
SELECT DISTINCT c1.company_name
FROM company AS c1
WHERE NOT EXISTS (
    SELECT city
    FROM company AS c2
    WHERE c2.company_name = 'Small Bank Corporation'
    AND c2.city NOT IN (SELECT city FROM company WHERE company_name = c1.company_name)
);

-- Find details of employees having a salary greater than 10,000:
SELECT e.employee_name, e.street, e.city, w.salary
FROM employee AS e
JOIN works AS w ON e.employee_name = w.employee_name
WHERE w.salary > 10000;

-- Update salary of all employees who work for First Bank Corporation by 10%:
UPDATE works
SET salary = salary * 1.10
WHERE company_name = 'First Bank Corporation';

-- Find employee and their managers:
SELECT m.employee_name AS employee, m.manager_name AS manager
FROM manages AS m;

-- Find the names, street, and cities of all employees who work for First Bank Corporation and earn more than 10,000:
SELECT e.employee_name, e.street, e.city
FROM employee AS e
JOIN works AS w ON e.employee_name = w.employee_name
WHERE w.company_name = 'First Bank Corporation' AND w.salary > 10000;

-- Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation:
SELECT company_name
FROM works
GROUP BY company_name
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM works
    WHERE company_name = 'First Bank Corporation'
);

