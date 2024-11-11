CREATE DATABASE empTriggerSET2;
USE empTriggerSET2;

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    dept_id INT,
    emp_name VARCHAR(100),
    DoJ DATE,  -- Date of Joining
    salary DECIMAL(10, 2),
    commission DECIMAL(10, 2),
    job_title VARCHAR(100)
);

CREATE TABLE Job_History (
    emp_id INT,
    old_job_title VARCHAR(100),
    old_dept_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

INSERT INTO Employee (emp_id, dept_id, emp_name, DoJ, salary, commission, job_title)
VALUES (1, 101, 'John Doe', '2020-01-15', 60000, 5000, 'Software Engineer');


-- Trigger to Ensure Salary is Not Decreased
DELIMITER $$

CREATE TRIGGER PreventSalaryDecrease
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    -- Check if the new salary is lower than the old salary
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be decreased!';
    END IF;
END $$

DELIMITER ;


-- Trigger to Insert Job Title Changes into Job_History Table
DELIMITER $$

CREATE TRIGGER LogJobTitleChange
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    -- Check if the job title has changed
    IF OLD.job_title <> NEW.job_title THEN
        -- Insert old job details into job_history table
        INSERT INTO Job_History (emp_id, old_job_title, old_dept_id, start_date, end_date)
        VALUES (OLD.emp_id, OLD.job_title, OLD.dept_id, OLD.DoJ, CURDATE());
    END IF;
END $$

DELIMITER ;



UPDATE Employee
SET salary = 55000
WHERE emp_id = 1;
-- This will throw an error: "Salary cannot be decreased!"

UPDATE Employee
SET job_title = 'Senior Software Engineer'
WHERE emp_id = 1;
-- This will insert a record into Job_History table with old job title and dates

SELECT * FROM Job_History WHERE emp_id = 1;
-- This should show the record for the job title change with the correct employee ID, old job title, old department ID, start date, and end date.
