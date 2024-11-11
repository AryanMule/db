CREATE DATABASE empCursorSET2;
USE empCursorSET2;

CREATE TABLE Employee (
    Emp_id INT PRIMARY KEY,
    Emp_Name VARCHAR(100),
    Salary DECIMAL(10, 2)
);

-- Insert sample data into Employee table
INSERT INTO Employee (Emp_id, Emp_Name, Salary) VALUES
(1, 'John Doe', 55000),
(2, 'Jane Smith', 45000),
(3, 'Alice Johnson', 60000),
(4, 'Bob Brown', 30000),
(5, 'Chris White', 75000);


-- 1. Explicit Cursor to display records of all employees with salary greater than 50,000
DELIMITER $$
CREATE PROCEDURE DisplayHighSalaryEmployees()
BEGIN
    DECLARE emp_id INT;
    DECLARE emp_name VARCHAR(100);
    DECLARE emp_salary DECIMAL(10, 2);
    DECLARE done INT DEFAULT 0;

    -- Cursor to select employees with salary > 50,000
    DECLARE high_salary_cursor CURSOR FOR 
        SELECT Emp_id, Emp_Name, Salary FROM Employee WHERE Salary > 50000;

    -- Declare the handler to set done to 1 when no more rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Temporary table to store the results
    CREATE TEMPORARY TABLE IF NOT EXISTS TempHighSalaryEmployees (
        Employee_Details VARCHAR(255)
    );

    -- Clear the temporary table in case there is leftover data from previous runs
    DELETE FROM TempHighSalaryEmployees;

    -- Open the cursor
    OPEN high_salary_cursor;

    employee_loop: LOOP
        FETCH high_salary_cursor INTO emp_id, emp_name, emp_salary;

        -- Exit the loop if there are no more rows
        IF done THEN
            LEAVE employee_loop;
        END IF;

        -- Insert employee details into the temporary table
        INSERT INTO TempHighSalaryEmployees (Employee_Details) 
        VALUES (CONCAT('Employee ID: ', emp_id, ', Name: ', emp_name, ', Salary: ', emp_salary));
    END LOOP;

    CLOSE high_salary_cursor;

    -- Return the results from the temporary table
    SELECT * FROM TempHighSalaryEmployees;

    -- Drop the temporary table after use
    DROP TEMPORARY TABLE TempHighSalaryEmployees;
END $$
DELIMITER ;

-- Call the procedure to display employees with salary > 50,000
SET SQL_SAFE_UPDATES = 0;
CALL DisplayHighSalaryEmployees();
SET SQL_SAFE_UPDATES = 1;


-- 2. PL/SQL Block using Implicit Cursor to display total number of tuples in Employee table
DELIMITER $$
CREATE PROCEDURE DisplayTotalEmployees()
BEGIN
    DECLARE total_employees INT;

    -- Using an implicit cursor to get the total count of rows
    SELECT COUNT(*) INTO total_employees FROM Employee;

    -- Display the total count of employees
    SELECT CONCAT('Total number of employees: ', total_employees) AS Total_Employees;
END $$

DELIMITER ;

-- Call the procedure to display total number of employees
CALL DisplayTotalEmployees();


-- 3. PL/SQL Block using Parameterized Cursor to display salary of employee by ID
DELIMITER $$
CREATE PROCEDURE DisplayEmployeeSalaryById(emp_id_param INT)
BEGIN
    DECLARE emp_salary DECIMAL(10, 2);

    -- Parameterized cursor to get the salary for a specific employee ID
    SELECT Salary INTO emp_salary
    FROM Employee
    WHERE Emp_id = emp_id_param;

    -- Display the salary for the provided employee ID
    SELECT CONCAT('Salary of employee with ID ', emp_id_param, ': ', emp_salary) AS Employee_Salary;
END $$
DELIMITER ;

-- Call the procedure with an employee ID (e.g., ID 1)
CALL DisplayEmployeeSalaryById(1);
