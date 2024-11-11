-- Create the Employee Table
CREATE DATABASE employeeset2;
use employeeset2;
-- Create the Employee Table
CREATE TABLE Employee (
    emp_id      INT PRIMARY KEY,
    emp_name    VARCHAR(100),
    dept_id     INT,
    DoJ         DATE,        -- Date of Joining
    salary      DECIMAL(10, 2),
    commission  DECIMAL(10, 2),  -- Increased precision for commission
    job_title   VARCHAR(50)
);

-- Insert sample data into Employee table
INSERT INTO Employee (emp_id, emp_name, dept_id, DoJ, salary, commission, job_title)
VALUES (115, 'John Doe', 101, '2010-06-15', 50000, 1500.00, 'Software Engineer');

INSERT INTO Employee (emp_id, emp_name, dept_id, DoJ, salary, commission, job_title)
VALUES (116, 'Jane Smith', 102, '2015-08-20', 60000, 2000.00, 'Project Manager');

INSERT INTO Employee (emp_id, emp_name, dept_id, DoJ, salary, commission, job_title)
VALUES (117, 'Emily White', 103, '2020-02-01', 45000, 1200.00, 'Developer');

-- Create the Salary_Increment Table
CREATE TABLE Salary_Increment (
    emp_id      INT PRIMARY KEY,
    new_salary  DECIMAL(10, 2)
);

DELIMITER $$

CREATE PROCEDURE Update_Salary(IN p_emp_id INT)
BEGIN
    -- Variables to hold employee details
    DECLARE v_salary DECIMAL(10, 2);
    DECLARE v_new_salary DECIMAL(10, 2);
    DECLARE v_experience INT;
    DECLARE v_increment DECIMAL(5, 2);
    
    -- Declare a handler for the case when the employee is not found
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_salary = NULL;  -- Setting a flag to indicate no data was found

    -- Fetch current salary and years of experience based on Date of Joining (DoJ)
    SELECT salary, FLOOR(TIMESTAMPDIFF(MONTH, DoJ, CURDATE()) / 12) 
    INTO v_salary, v_experience
    FROM Employee
    WHERE emp_id = p_emp_id;

    -- Check if the employee was found (v_salary will be NULL if not found)
    IF v_salary IS NULL THEN
        -- Handle the case where the employee does not exist
        SELECT CONCAT('Error: Employee ID ', p_emp_id, ' does not exist.') AS error_message;
    ELSE
        -- Apply the increment percentage based on years of experience
        IF v_experience > 10 THEN
            SET v_increment := 0.20; -- 20% increase
        ELSEIF v_experience > 5 THEN
            SET v_increment := 0.10; -- 10% increase
        ELSE
            SET v_increment := 0.05; -- 5% increase
        END IF;

        -- Calculate the new salary after applying increment
        SET v_new_salary := v_salary * (1 + v_increment);

        -- Insert the incremented salary into the Salary_Increment table
        INSERT INTO Salary_Increment (emp_id, new_salary)
        VALUES (p_emp_id, v_new_salary);

        -- Display success message
        SELECT CONCAT('Salary updated successfully for Employee ID: ', p_emp_id) AS message;
        SELECT CONCAT('Old Salary: ', v_salary, ', New Salary: ', v_new_salary) AS salary_details;
    END IF;

END$$

DELIMITER ;

CALL Update_Salary(115);
SELECT * FROM Salary_Increment WHERE emp_id = 115;
CALL Update_Salary(999);  -- assuming 999 is not a valid emp_id
