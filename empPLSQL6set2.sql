CREATE DATABASE employeePLSQLset2;
USE employeePLSQLset2;

-- Create Employee table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    dept_id INT,
    emp_name VARCHAR(100),
    DoJ DATE,
    salary DECIMAL(10, 2),
    commission DECIMAL(5, 2) DEFAULT NULL,
    job_title VARCHAR(100)
);

-- Insert sample data into Employee table
INSERT INTO Employee (emp_id, dept_id, emp_name, DoJ, salary, commission, job_title) VALUES
(1, 101, 'John Doe', '2010-05-10', 12000, NULL, 'Manager'),
(2, 102, 'Jane Smith', '2015-03-22', 8500, NULL, 'Developer'),
(3, 103, 'Sam Brown', '2010-01-15', 9500, NULL, 'Analyst'),
(4, 101, 'Emma White', '2009-11-01', 2000, NULL, 'Clerk'),
(5, 102, 'Oliver Blue', '2018-08-30', 13000, NULL, 'Lead Developer');

-- Create Stored Procedure for recording commission based on salary and experience
DELIMITER $$

CREATE PROCEDURE RecordCommission()
BEGIN
    DECLARE emp_id INT; -- Declare emp_id variable
	DECLARE DoJ INT ;
    DECLARE emp_salary DECIMAL(10, 2);
    DECLARE emp_experience INT;
    DECLARE done INT DEFAULT 0;

    -- Cursor to iterate over each employee
    DECLARE emp_cursor CURSOR FOR 
        SELECT emp_id, salary, DoJ FROM Employee WHERE commission IS NULL;

    -- Declare CONTINUE HANDLER for the end of the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN emp_cursor;

    -- Loop to process each employee
    employee_loop: LOOP
        FETCH emp_cursor INTO emp_id, emp_salary, DoJ;

        -- Exit condition for cursor
        IF done THEN
            LEAVE employee_loop;
        END IF;

        -- Calculate years of experience
        SET emp_experience = TIMESTAMPDIFF(YEAR, DoJ, CURDATE());

        -- Update commission based on conditions
        IF emp_salary > 10000 THEN
            UPDATE Employee SET commission = emp_salary * 0.004 WHERE emp_id = emp_id;
        ELSEIF emp_salary <= 10000 AND emp_experience > 10 THEN
            UPDATE Employee SET commission = emp_salary * 0.0035 WHERE emp_id = emp_id;
        ELSEIF emp_salary < 3000 THEN
            UPDATE Employee SET commission = emp_salary * 0.0025 WHERE emp_id = emp_id;
        ELSE
            UPDATE Employee SET commission = emp_salary * 0.0015 WHERE emp_id = emp_id;
        END IF;
    END LOOP;

    CLOSE emp_cursor;
END $$

DELIMITER ;

-- Call the procedure to calculate and record commissions for all employees
CALL RecordCommission();

-- Display the employee details along with the calculated commission
SELECT * FROM Employee;

-- Create a PLSQL Function to get the manager's name for a given department ID
DELIMITER $$

CREATE FUNCTION GetManagerName(dept_id INT) 
RETURNS VARCHAR(100) DETERMINISTIC
BEGIN
    DECLARE manager_name VARCHAR(100);

    -- Fetch the manager name for the given department
    SELECT emp_name INTO manager_name
    FROM Employee
    WHERE dept_id = dept_id AND job_title = 'Manager';

    RETURN manager_name;
END $$

DELIMITER ;

-- Call the function with department ID (e.g., department ID 101 for testing)
SELECT GetManagerName(101) AS Manager_Name;
