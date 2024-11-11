CREATE DATABASE LibraryDB;
USE LibraryDB;


CREATE TABLE PUBLISHER (
    PID INT PRIMARY KEY,
    PNAME VARCHAR(100),
    ADDRESS VARCHAR(255),
    STATE VARCHAR(50),
    PHONE VARCHAR(15),
    EMAILID VARCHAR(100)
);

CREATE TABLE BOOK (
    ISBN INT PRIMARY KEY,
    BOOK_TITLE VARCHAR(100),
    CATEGORY VARCHAR(50),
    PRICE DECIMAL(10, 2),
    COPYRIGHT_DATE DATE,
    YEAR INT,
    PAGE_COUNT INT,
    PID INT,
    FOREIGN KEY (PID) REFERENCES PUBLISHER(PID)
);

CREATE TABLE AUTHOR (
    AID INT PRIMARY KEY,
    ANAME VARCHAR(100),
    STATE VARCHAR(50),
    CITY VARCHAR(50),
    ZIP VARCHAR(10),
    PHONE VARCHAR(15),
    URL VARCHAR(100)
);

CREATE TABLE AUTHOR_BOOK (
    AID INT,
    ISBN INT,
    PRIMARY KEY (AID, ISBN),
    FOREIGN KEY (AID) REFERENCES AUTHOR(AID),
    FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN)
);

CREATE TABLE REVIEW (
    RID INT PRIMARY KEY,
    ISBN INT,
    RATING INT,
    FOREIGN KEY (ISBN) REFERENCES BOOK(ISBN)
);


-- Publisher Sample Data
INSERT INTO PUBLISHER (PID, PNAME, ADDRESS, STATE, PHONE, EMAILID)
VALUES
(1, 'MEHTA', '1234 Mehta Street', 'Maharashtra', '9876543210', 'mehta@example.com'),
(2, 'RUPA', '5678 Rupa Lane', 'Karnataka', '1122334455', 'rupa@example.com');

-- Book Sample Data
INSERT INTO BOOK (ISBN, BOOK_TITLE, CATEGORY, PRICE, COPYRIGHT_DATE, YEAR, PAGE_COUNT, PID)
VALUES
(101, 'Revolution 2020', 'Fiction', 300.00, '2020-05-15', 2020, 300, 1),
(102, 'The Alchemist', 'Fiction', 200.00, '2018-10-01', 2018, 400, 2);

-- Author Sample Data
INSERT INTO AUTHOR (AID, ANAME, STATE, CITY, ZIP, PHONE, URL)
VALUES
(1, 'CHETAN BHAGAT', 'Maharashtra', 'Mumbai', '400001', '9876543210', 'chetanbhagat.com'),
(2, 'PAULO COELHO', 'Karnataka', 'Bangalore', '500001', '1234567890', 'paulocoelho.com');

-- Author-Book Sample Data
INSERT INTO AUTHOR_BOOK (AID, ISBN)
VALUES
(1, 101),
(2, 102);

-- Review Sample Data
INSERT INTO REVIEW (RID, ISBN, RATING)
VALUES
(1, 101, 4),
(2, 102, 5);




-- 1. Retrieve city, phone, URL of author whose name is 'CHETAN BHAGAT'
-- Query: Display city, phone, and URL of the author
SELECT CITY, PHONE, URL
FROM AUTHOR
WHERE ANAME = 'CHETAN BHAGAT';

-- 2. Retrieve book title, reviewable id, and rating of all books
-- Query: Show book title, review id, and rating of books
SELECT BOOK_TITLE, RID, RATING
FROM BOOK
JOIN REVIEW ON BOOK.ISBN = REVIEW.ISBN;

-- 3. Retrieve book title, price, author name, and URL for publishers 'MEHTA'
-- Query: Show book title, price, author name, and URL for publisher 'MEHTA'
SELECT BOOK_TITLE, PRICE, ANAME, URL
FROM BOOK
JOIN AUTHOR_BOOK ON BOOK.ISBN = AUTHOR_BOOK.ISBN
JOIN AUTHOR ON AUTHOR_BOOK.AID = AUTHOR.AID
JOIN PUBLISHER ON BOOK.PID = PUBLISHER.PID
WHERE PUBLISHER.PNAME = 'MEHTA';

-- 4. In a PUBLISHER relation, change the phone number of 'MEHTA' to 123456
-- Query: Update phone number of 'MEHTA' publisher
UPDATE PUBLISHER 
SET PHONE = '123456' 
WHERE PNAME = 'MEHTA' AND PID = 1;


-- 5. Calculate and display the average, maximum, minimum price of each publisher
-- Query: Show average, max, and min price for each publisher
SELECT PNAME, AVG(PRICE) AS AVG_PRICE, MAX(PRICE) AS MAX_PRICE, MIN(PRICE) AS MIN_PRICE
FROM BOOK
JOIN PUBLISHER ON BOOK.PID = PUBLISHER.PID
GROUP BY PUBLISHER.PNAME;

-- 6. Delete details of all books having a page count less than 100
-- Query: Delete books with less than 100 pages
SET SQL_SAFE_UPDATES = 0;
DELETE FROM BOOK
WHERE PAGE_COUNT < 100;
SET SQL_SAFE_UPDATES = 1;

-- 7. Retrieve details of all authors residing in city Pune and whose name begins with character 'C'
-- Query: Show details of authors from Pune with name starting with 'C'
SELECT *
FROM AUTHOR
WHERE CITY = 'Pune' AND ANAME LIKE 'C%';

-- 8. Retrieve details of authors residing in the same city as 'Korth'
-- Query: Show authors from the same city as 'Korth'
SELECT *
FROM AUTHOR
WHERE CITY = (SELECT CITY FROM AUTHOR WHERE ANAME = 'Korth');

-- 9. Create a procedure to update the value of page count of a book of given ISBN
-- Query: Create procedure to update page count of a book by ISBN
DELIMITER $$
CREATE PROCEDURE UpdatePageCount(IN BookISBN INT, IN NewPageCount INT)
BEGIN
    UPDATE BOOK
    SET PAGE_COUNT = NewPageCount
    WHERE ISBN = BookISBN;
END$$
DELIMITER ;

-- 10. Create a function that returns the price of book with a given ISBN
-- Query: Create function to return price of a book by ISBN
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
CREATE FUNCTION GetBookPrice(BookISBN INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE BookPrice DECIMAL(10,2);
    SELECT PRICE INTO BookPrice
    FROM BOOK
    WHERE ISBN = BookISBN;
    RETURN BookPrice;
END;
$$
DELIMITER ;

