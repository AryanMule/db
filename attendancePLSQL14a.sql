CREATE DATABASE studattendance;
USE studattendance;

CREATE TABLE Stud (
    Roll INT PRIMARY KEY,
    Att INT,
    Status VARCHAR(2)
);

-- Sample data for testing
INSERT INTO Stud (Roll, Att, Status) VALUES 
(101, 70, 'ND'),
(102, 80, 'ND'),
(103, 50, 'ND');



DELIMITER $$

CREATE PROCEDURE CheckAttendance(IN roll_no INT)
BEGIN
    -- Declare a variable to store attendance
    DECLARE v_attendance INT;
    
    -- Declare a handler for the case when no data is found
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'Error: Roll number not found.' AS Error_Message;
    END;

    -- Select attendance for the given roll number
    SELECT Att INTO v_attendance
    FROM Stud
    WHERE Roll = roll_no;

    -- Check if attendance is below 75%
    IF v_attendance < 75 THEN
        -- Update status to 'D' if attendance is below 75%
        UPDATE Stud
        SET Status = 'D'
        WHERE Roll = roll_no;
        SELECT 'Term not granted' AS Message;
    ELSE
        -- Update status to 'ND' if attendance is 75% or more
        UPDATE Stud
        SET Status = 'ND'
        WHERE Roll = roll_no;
        SELECT 'Term granted' AS Message;
    END IF;
END$$

DELIMITER ;



CALL CheckAttendance(101);
CALL CheckAttendance(102);
