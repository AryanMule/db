CREATE DATABASE EmpsalarybackupSET2;
USE EmpsalarybackupSET2;

-- Create the Employee table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    salary DECIMAL(10, 2),
    designation VARCHAR(50)
);

-- Create the Salary_Backup table
CREATE TABLE Salary_Backup (
    emp_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    salary_difference DECIMAL(10, 2),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

-- Inserting sample data into Employee table
INSERT INTO Employee (emp_id, emp_name, salary, designation) VALUES
(1, 'John Doe', 60000, 'Manager'),
(2, 'Jane Smith', 100000, 'CEO'),
(3, 'Alice Johnson', 45000, 'Engineer'),
(4, 'Bob Brown', 55000, 'Manager');

-- Creating a Trigger for Salary Update
DELIMITER $$

CREATE TRIGGER AfterSalaryUpdate
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    -- Check if the salary is actually updated
    IF OLD.salary != NEW.salary THEN
        -- Insert the salary change details into the Salary_Backup table
        INSERT INTO Salary_Backup (emp_id, old_salary, new_salary, salary_difference)
        VALUES (OLD.emp_id, OLD.salary, NEW.salary, NEW.salary - OLD.salary);
    END IF;
END $$

DELIMITER ;

-- Creating a Trigger to Prevent Deletion of CEO
DELIMITER $$

CREATE TRIGGER PreventCEODeletion
BEFORE DELETE ON Employee
FOR EACH ROW
BEGIN
    -- Check if the employee being deleted is a CEO
    IF OLD.designation = 'CEO' THEN
        -- Raise an error to prevent deletion
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete employee with designation CEO';
    END IF;
END $$

DELIMITER ;

-- Sample Salary Update (This should trigger the Salary_Backup table insertion)
UPDATE Employee SET salary = 65000 WHERE emp_id = 1;

-- Sample Deletion (This should fail if the designation is CEO)
DELETE FROM Employee WHERE emp_id = 2;

-- To view the records of the Salary_Backup table
SELECT * FROM Salary_Backup;
