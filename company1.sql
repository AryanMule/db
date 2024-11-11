CREATE DATABASE company;
USE company;

CREATE TABLE dept (
    deptno INT PRIMARY KEY,
    deptname VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE emp (
    eno INT PRIMARY KEY,
    ename VARCHAR(50),
    job VARCHAR(50),
    hiredate DATE,
    salary DECIMAL(10, 2),
    commission DECIMAL(10, 2),
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES dept(deptno)
);

-- Insert data into dept table
INSERT INTO dept (deptno, deptname, location) VALUES (10, 'Dev', 'New York');
INSERT INTO dept (deptno, deptname, location) VALUES (20, 'Sales', 'Chicago');

-- Insert data into emp table
INSERT INTO emp (eno, ename, job, hiredate, salary, commission, deptno) 
VALUES (1, 'Alice', 'manager', '1981-03-15', 60000, 5000, 10);
INSERT INTO emp (eno, ename, job, hiredate, salary, commission, deptno) 
VALUES (2, 'Bob', 'salesman', '1981-08-20', 40000, 3000, 20);
INSERT INTO emp (eno, ename, job, hiredate, salary, commission, deptno) 
VALUES (3, 'Ivy', 'analyst', '1980-09-10', 50000, NULL, 10);


-- List the maximum salary paid to salesman
SELECT MAX(salary) AS max_salary
FROM emp
WHERE job="salesman";

-- List name of emp whose name start with ‘I
SELECT ename
FROM emp
WHERE ename LIKE "I%";

-- List details of employees who joined before ’30-sept-81’.
SELECT *
FROM emp
WHERE hiredate < "1981-09-30";

-- List the employee details in the descending order of their basic salary.
SELECT * 
FROM emp
ORDER BY salary DESC;

--  List the number of employees and average salary for employees in department number ‘20’.
SELECT COUNT(*) AS numOfEmp , AVG(salary) AS avgSalary
FROM emp
WHERE deptno="20";

-- List the average salary and minimum salary of the employees hire-date-wise for department number ‘10’.
SELECT hiredate, AVG(salary) as avgSalary, MIN(salary) as minSalary
FROM emp
WHERE deptno="10"
GROUP BY hiredate;

--  List employee names and their department names.
SELECT e.ename, d.deptname
FROM emp e
JOIN dept d ON e.deptno = d.deptno;

-- List the total salary paid to each department.
SELECT d.deptname, SUM(e.salary) AS totalSalary
FROM emp e
JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptname;

-- List details of employees working in the ‘Dev’ department.
SELECT e.*
FROM emp e
JOIN dept d ON e.deptno = d.deptno
WHERE d.deptname = 'Dev';

-- Update the salary of all employees in department number 10 by 5%.
UPDATE emp
SET salary = salary * 1.05
WHERE deptno = "10";