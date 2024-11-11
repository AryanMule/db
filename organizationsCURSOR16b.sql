CREATE DATABASE organizations;
USE organizations;


-- Step 1: Create the employee and increment_salary tables
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary DECIMAL(10, 2)
);

CREATE TABLE increment_salary (
    employee_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    increment_date DATE
);

-- Insert sample data into the employees table
INSERT INTO employees (employee_id, employee_name, salary) VALUES
(1, 'John Doe', 3000),
(2, 'Jane Smith', 4500),
(3, 'Sam Brown', 2800),
(4, 'Emma White', 5200);

-- Step 2: Write a PL/SQL block to update the salary for employees below average salary
DELIMITER $$

CREATE PROCEDURE increase_salary_for_below_avg()
BEGIN
    DECLARE avg_salary DECIMAL(10, 2);
    DECLARE done INT DEFAULT 0;
    DECLARE employee_id INT;
    DECLARE old_salary DECIMAL(10, 2);
    DECLARE new_salary DECIMAL(10, 2);

    -- Declare the cursor
    DECLARE employee_cursor CURSOR FOR 
        SELECT employee_id, salary
        FROM employees
        WHERE salary < (SELECT AVG(salary) FROM employees);

    -- Declare the CONTINUE HANDLER
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Get the average salary
    SELECT AVG(salary) INTO avg_salary FROM employees;

    OPEN employee_cursor;

    -- Iterate over the records returned by the cursor
    read_loop: LOOP
        FETCH employee_cursor INTO employee_id, old_salary;

        -- Exit the loop if no more rows are available
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate the new salary
        SET new_salary = old_salary * 1.10;

        -- Update the employee's salary
        UPDATE employees
        SET salary = new_salary
        WHERE employee_id = employee_id;

        -- Record the increment in the increment_salary table
        INSERT INTO increment_salary (employee_id, old_salary, new_salary, increment_date)
        VALUES (employee_id, old_salary, new_salary, CURRENT_DATE);

    END LOOP;

    CLOSE employee_cursor;

    -- Output the result
    SELECT 'Salary updated for employees below average salary.' AS result;
END$$

DELIMITER ;

-- Call the procedure to execute it
CALL increase_salary_for_below_avg();

-- Check the results
SELECT * FROM employees;
SELECT * FROM increment_salary;

