CREATE DATABASE project;
USE project;

-- Table: Project
CREATE TABLE Project (
    project_id VARCHAR(10) PRIMARY KEY,
    proj_name VARCHAR(50) NOT NULL,
    chief_arch VARCHAR(50)
);

-- Table: Employee
CREATE TABLE Employee (
    Emp_id INT PRIMARY KEY,
    Emp_name VARCHAR(50) NOT NULL
);

-- Table: Assigned-To (many-to-many relationship table)
CREATE TABLE Assigned_To (
    Project_id VARCHAR(10),
    Emp_id INT,
    PRIMARY KEY (Project_id, Emp_id),
    FOREIGN KEY (Project_id) REFERENCES Project(project_id),
    FOREIGN KEY (Emp_id) REFERENCES Employee(Emp_id)
);


-- Inserting data into Project table
INSERT INTO Project (project_id, proj_name, chief_arch)
VALUES 
    ('C353', 'Database Project', 'Alice Smith'),
    ('C354', 'Web Development', 'Bob Johnson'),
    ('C453', 'Mobile App', 'Carol Davis');

-- Inserting data into Employee table
INSERT INTO Employee (Emp_id, Emp_name)
VALUES 
    (101, 'John Doe'),
    (102, 'Jane Roe'),
    (103, 'Jim Poe'),
    (104, 'Ann Joe'),
    (105, 'Sam Moe');

-- Inserting data into Assigned_To table (relationships between employees and projects)
INSERT INTO Assigned_To (Project_id, Emp_id)
VALUES 
    ('C353', 101),
    ('C353', 102),
    ('C354', 101),
    ('C354', 103),
    ('C453', 104),
    ('C354', 105);

-- 1. Get the details of employees working on project C353
SELECT E.*
FROM Employee E
JOIN Assigned_To A ON E.Emp_id = A.Emp_id
WHERE A.Project_id = 'C353';

-- 2. Get employee number (Emp_id) of employees working on project C353
SELECT E.Emp_id
FROM Employee E
JOIN Assigned_To A ON E.Emp_id = A.Emp_id
WHERE A.Project_id = 'C353';

-- 3. Obtain details of employees working on 'Database Project'
SELECT E.*
FROM Employee E
JOIN Assigned_To A ON E.Emp_id = A.Emp_id
JOIN Project P ON A.Project_id = P.project_id
WHERE P.proj_name = 'Database Project';

-- 4. Get details of employees working on both C353 and C354
SELECT E.*
FROM Employee E
WHERE E.Emp_id IN (
    SELECT A1.Emp_id
    FROM Assigned_To A1
    JOIN Assigned_To A2 ON A1.Emp_id = A2.Emp_id
    WHERE A1.Project_id = 'C353' AND A2.Project_id = 'C354'
);

-- 5. Get employee numbers (Emp_id) of employees who do not work on project C453
SELECT E.Emp_id
FROM Employee E
WHERE E.Emp_id NOT IN (
    SELECT A.Emp_id
    FROM Assigned_To A
    WHERE A.Project_id = 'C453'
);
