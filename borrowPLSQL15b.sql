-- Create database and use it
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Create Borrow table
CREATE TABLE IF NOT EXISTS Borrow (
    Roll_no INT,
    Name VARCHAR(100),
    DateofIssue DATE,
    NameofBook VARCHAR(100),
    Status CHAR(1) DEFAULT 'I',  -- 'I' for Issued, 'R' for Returned
    PRIMARY KEY (Roll_no, NameofBook)
);

-- Create Fine table
CREATE TABLE IF NOT EXISTS Fine (
    Roll_no INT,
    Date DATE,
    Amt DECIMAL(10, 2),
    PRIMARY KEY (Roll_no, Date)
);

-- Insert sample data
INSERT INTO Borrow (Roll_no, Name, DateofIssue, NameofBook, Status) VALUES
(1, 'John Doe', '2023-10-01', 'SQL Fundamentals', 'I'),
(2, 'Jane Smith', '2023-10-15', 'Advanced PL/SQL', 'I');

-- Change delimiter to allow creating procedure
DELIMITER $$

CREATE PROCEDURE ReturnBook(IN in_roll_no INT, IN in_name_of_book VARCHAR(100))
BEGIN
    -- Declare variables
    DECLARE v_date_of_issue DATE;
    DECLARE v_days INT;
    DECLARE v_fine_amt DECIMAL(10, 2);
    DECLARE book_not_found TINYINT DEFAULT 0;

    -- Declare a handler for "not found" condition
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET book_not_found = 1;

    -- Fetch DateofIssue and check if the book exists
    SELECT DateofIssue INTO v_date_of_issue
    FROM Borrow
    WHERE Roll_no = in_roll_no AND NameofBook = in_name_of_book AND Status = 'I';

    -- Check if book was not found
    IF book_not_found = 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Book not found or already returned.';
    END IF;

    -- Calculate days since DateofIssue
    SET v_days = DATEDIFF(CURDATE(), v_date_of_issue);

    -- Calculate fine based on the number of days
    IF v_days > 30 THEN
        SET v_fine_amt = (v_days - 30) * 50 + (15 * 5); -- 5 per day for first 15 days, then 50 per day
    ELSEIF v_days > 15 THEN
        SET v_fine_amt = (v_days - 15) * 5;  -- Rs. 5 per day for days 15-30
    ELSE
        SET v_fine_amt = 0;  -- No fine for days <= 15
    END IF;

    -- Update the status of the book in Borrow table to 'R'
    UPDATE Borrow
    SET Status = 'R'
    WHERE Roll_no = in_roll_no AND NameofBook = in_name_of_book;

    -- Insert fine record if applicable
    IF v_fine_amt > 0 THEN
        INSERT INTO Fine (Roll_no, Date, Amt)
        VALUES (in_roll_no, CURDATE(), v_fine_amt);
    END IF;

    -- Display appropriate message
    IF v_fine_amt > 0 THEN
        SELECT CONCAT('Book returned. Fine imposed: Rs ', v_fine_amt) AS Message;
    ELSE
        SELECT 'Book returned with no fine.' AS Message;
    END IF;

END$$

DELIMITER ;

-- Test the procedure
CALL ReturnBook(1, 'SQL Fundamentals'); -- Should calculate fine based on date difference
CALL ReturnBook(2, 'Advanced PL/SQL'); -- Should update status without fine if under 15 days

-- Verify results
SELECT * FROM Borrow;
SELECT * FROM Fine;
