CREATE DATABASE hotel;
USE hotel;

CREATE TABLE Hotel (
    HotelNo INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(100)
);

CREATE TABLE Room (
    RoomNo INT,
    HotelNo INT,
    Type VARCHAR(50),
    Price DECIMAL(10, 2),
    PRIMARY KEY (HotelNo, RoomNo),  -- Composite primary key
    FOREIGN KEY (HotelNo) REFERENCES Hotel(HotelNo)  -- Foreign key referencing Hotel
);

CREATE TABLE Guest (
    GuestNo INT PRIMARY KEY,
    GuestName VARCHAR(100),
    GuestAddress VARCHAR(200)
);

-- Create Booking table
-- CREATE TABLE Booking (
--     HotelNo INT,
--     GuestNo INT,
--     DateFrom DATE,
--     DateTo DATE,
--     RoomNo INT,
--     PRIMARY KEY (HotelNo, GuestNo, DateFrom),  -- Composite primary key
--     FOREIGN KEY (HotelNo) REFERENCES Hotel(HotelNo),
--     FOREIGN KEY (RoomNo, HotelNo) REFERENCES Room(HotelNo, RoomNo),
--     FOREIGN KEY (GuestNo) REFERENCES Guest(GuestNo)
-- );
-- Drop the existing Booking table if needed
DROP TABLE IF EXISTS Booking;

-- Recreate the Booking table with the corrected foreign key constraint
CREATE TABLE Booking (
    HotelNo INT,
    GuestNo INT,
    DateFrom DATE,
    DateTo DATE,
    RoomNo INT,
    PRIMARY KEY (HotelNo, GuestNo, DateFrom),  -- Composite primary key
    FOREIGN KEY (HotelNo) REFERENCES Hotel(HotelNo),
    FOREIGN KEY (HotelNo, RoomNo) REFERENCES Room(HotelNo, RoomNo),  -- Corrected column order
    FOREIGN KEY (GuestNo) REFERENCES Guest(GuestNo)
);

-- Insert sample data into Hotel table
INSERT INTO Hotel (HotelNo, Name, City) VALUES
(1, 'Grosvenor Hotel', 'London'),
(2, 'Holiday Inn', 'Paris'),
(3, 'Marriott Hotel', 'New York');

-- Insert sample data into Room table
INSERT INTO Room (RoomNo, HotelNo, Type, Price) VALUES
(101, 1, 'Single', 100.00),
(102, 1, 'Double', 150.00),
(103, 1, 'Suite', 250.00),
(201, 2, 'Single', 80.00),
(202, 2, 'Double', 120.00),
(301, 3, 'Single', 130.00),
(302, 3, 'Double', 180.00);

-- Insert sample data into Guest table
INSERT INTO Guest (GuestNo, GuestName, GuestAddress) VALUES
(1, 'John Doe', '123 Main St, London'),
(2, 'Jane Smith', '456 Oak St, Paris'),
(3, 'Michael Johnson', '789 Pine St, New York');

-- Insert sample data into Booking table
INSERT INTO Booking (HotelNo, RoomNo, GuestNo, DateFrom, DateTo) VALUES
(1, 101, 1, '2024-11-01', '2024-11-05'),
(2, 202, 2, '2024-11-01', '2024-11-03'),
(3, 301, 3, '2024-11-01', '2024-11-10');

-- Query 1: List full details of all hotels
SELECT * FROM Hotel;

-- Query 2: Count the number of hotels
SELECT COUNT(*) AS NumberOfHotels FROM Hotel;

-- Query 3: List price and type of rooms at Grosvenor Hotel
SELECT RoomNo, Type, Price
FROM Room
WHERE HotelNo = (SELECT HotelNo FROM Hotel WHERE Name = 'Grosvenor Hotel');

-- Query 4: List the number of rooms in each hotel
SELECT HotelNo, COUNT(*) AS NumberOfRooms
FROM Room
GROUP BY HotelNo;

-- Query 5: Increase price of all rooms by 5%
UPDATE Room
SET Price = Price * 1.05;

-- Query 6: List full details of all hotels located in London
SELECT * FROM Hotel
WHERE City = 'London';

-- Query 7: Find the average price of a room
SELECT AVG(Price) AS AverageRoomPrice FROM Room;

-- Query 8: List all guests currently staying at the Grosvenor Hotel
SELECT G.GuestName, G.GuestAddress, B.DateFrom, B.DateTo
FROM Booking B
JOIN Guest G ON B.GuestNo = G.GuestNo
WHERE B.HotelNo = (SELECT HotelNo FROM Hotel WHERE Name = 'Grosvenor Hotel')
AND CURDATE() BETWEEN B.DateFrom AND B.DateTo;

-- Query 9: List the number of rooms in each hotel in London
SELECT HotelNo, COUNT(*) AS NumberOfRooms
FROM Room
WHERE HotelNo IN (SELECT HotelNo FROM Hotel WHERE City = 'London')
GROUP BY HotelNo;

-- Query 10: Create a view to display booking details and query it
CREATE VIEW BookingDetails AS
SELECT B.HotelNo, H.Name AS HotelName, G.GuestName, G.GuestAddress, B.DateFrom, B.DateTo, R.Type AS RoomType, R.Price
FROM Booking B
JOIN Hotel H ON B.HotelNo = H.HotelNo
JOIN Guest G ON B.GuestNo = G.GuestNo
JOIN Room R ON B.RoomNo = R.RoomNo AND B.HotelNo = R.HotelNo;
-- Query the view to get all booking details
SELECT * FROM BookingDetails;


-- ************************  4 ***************************
-- Query 1: Total revenue per night from all double rooms
SELECT SUM(Price) AS TotalRevenue
FROM Room
WHERE Type = 'Double';

-- Query 2: Details of all rooms at the Grosvenor Hotel, including guest info if occupied
SELECT R.RoomNo, R.Type, R.Price, G.GuestName
FROM Room R
LEFT JOIN Booking B ON R.RoomNo = B.RoomNo AND R.HotelNo = B.HotelNo
LEFT JOIN Guest G ON B.GuestNo = G.GuestNo
WHERE R.HotelNo = (SELECT HotelNo FROM Hotel WHERE Name = 'Grosvenor Hotel');

-- Query 3: Average number of bookings per hotel in April
SELECT B.HotelNo, COUNT(*) / 30 AS AvgBookingsPerDayInApril
FROM Booking B
WHERE MONTH(B.DateFrom) = 4
GROUP BY B.HotelNo;

-- Query 4: Create an index on Room Price and demonstrate improved performance
CREATE INDEX idx_room_price ON Room(Price);
-- Query the Room table using the index to test performance (compare with/without index)
SELECT * FROM Room WHERE Price < 150;

-- Query 5: List full details of all hotels
SELECT * FROM Hotel;

-- Query 6: List full details of all hotels in London
SELECT * FROM Hotel WHERE City = 'London';

-- Query 7: Update the price of all rooms by 5%
UPDATE Room SET Price = Price * 1.05;

-- Query 8: Number of rooms in each hotel in London
SELECT H.HotelNo, COUNT(*) AS NumberOfRooms
FROM Room R
JOIN Hotel H ON R.HotelNo = H.HotelNo
WHERE H.City = 'London'
GROUP BY H.HotelNo;

-- Query 9: List all double or family rooms with a price below £40.00 per night, ordered by price
SELECT RoomNo, HotelNo, Type, Price
FROM Room
WHERE (Type = 'Double' OR Type = 'Family') AND Price < 40.00
ORDER BY Price ASC;





-- ************************  5 ***************************

-- 1. List full details of all hotels.
SELECT * FROM Hotel;

-- 2. How many hotels are there?
SELECT COUNT(*) AS NumberOfHotels FROM Hotel;

-- 3. List the price and type of all rooms at the Grosvenor Hotel.
SELECT RoomNo, Type, Price
FROM Room
WHERE HotelNo = (SELECT HotelNo FROM Hotel WHERE Name = 'Grosvenor Hotel');

-- 4. List the number of rooms in each hotel.
SELECT HotelNo, COUNT(*) AS NumberOfRooms
FROM Room
GROUP BY HotelNo;

-- 5. List all guests currently staying at the Grosvenor Hotel.
SELECT G.GuestName, G.GuestAddress, B.DateFrom, B.DateTo
FROM Booking B
JOIN Guest G ON B.GuestNo = G.GuestNo
WHERE B.HotelNo = (SELECT HotelNo FROM Hotel WHERE Name = 'Grosvenor Hotel')
AND CURDATE() BETWEEN B.DateFrom AND B.DateTo;

-- 6. List all double or family rooms with a price below £40.00 per night, in ascending order of price.
SELECT RoomNo, HotelNo, Type, Price
FROM Room
WHERE (Type = 'Double' OR Type = 'Family') AND Price < 40.00
ORDER BY Price ASC;

-- 7. How many different guests have made bookings for August?
SELECT COUNT(DISTINCT GuestNo) AS UniqueGuestsInAugust
FROM Booking
WHERE MONTH(DateFrom) = 8 OR MONTH(DateTo) = 8;

-- 8. What is the total income from bookings for the Grosvenor Hotel today?
SELECT SUM(R.Price) AS TotalIncomeToday
FROM Booking B
JOIN Room R ON B.HotelNo = R.HotelNo AND B.RoomNo = R.RoomNo
WHERE B.HotelNo = (SELECT HotelNo FROM Hotel WHERE Name = 'Grosvenor Hotel')
AND CURDATE() BETWEEN B.DateFrom AND B.DateTo;

-- 9. What is the most commonly booked room type for each hotel in London?
SELECT H.HotelNo, H.Name AS HotelName, R.Type, COUNT(R.Type) AS BookingCount
FROM Booking B
JOIN Hotel H ON B.HotelNo = H.HotelNo
JOIN Room R ON B.HotelNo = R.HotelNo AND B.RoomNo = R.RoomNo
WHERE H.City = 'London'
GROUP BY H.HotelNo, R.Type
ORDER BY H.HotelNo, BookingCount DESC;

-- 10. Update the price of all rooms by 5%.
UPDATE Room
SET Price = Price * 1.05;







-- ************************  6 ***************************
-- 1. List full details of all hotels.
SELECT * FROM Hotel;

-- 2. List full details of all hotels in London.
SELECT * FROM Hotel
WHERE City = 'London';

-- 3. List all guests currently staying at the Grosvenor Hotel.
SELECT G.GuestName, G.GuestAddress, B.DateFrom, B.DateTo
FROM Booking B
JOIN Guest G ON B.GuestNo = G.GuestNo
WHERE B.HotelNo = (SELECT HotelNo FROM Hotel WHERE Name = 'Grosvenor Hotel')
AND CURDATE() BETWEEN B.DateFrom AND B.DateTo;

-- 4. List the names and addresses of all guests in London, alphabetically ordered by name.
SELECT GuestName, GuestAddress
FROM Guest
JOIN Booking B ON Guest.GuestNo = B.GuestNo
JOIN Hotel H ON B.HotelNo = H.HotelNo
WHERE H.City = 'London'
ORDER BY GuestName ASC;

-- 5. List the bookings for which no DateTo has been specified.
SELECT * FROM Booking
WHERE DateTo IS NULL;

-- 6. How many hotels are there?
SELECT COUNT(*) AS NumberOfHotels FROM Hotel;

-- 7. List the rooms that are currently unoccupied at the Grosvenor Hotel.
SELECT R.RoomNo, R.Type, R.Price
FROM Room R
LEFT JOIN Booking B ON R.HotelNo = B.HotelNo AND R.RoomNo = B.RoomNo
AND CURDATE() BETWEEN B.DateFrom AND B.DateTo
WHERE R.HotelNo = (SELECT HotelNo FROM Hotel WHERE Name = 'Grosvenor Hotel')
AND B.RoomNo IS NULL;

-- 8. What is the lost income from unoccupied rooms at each hotel today?
SELECT H.HotelNo, H.Name AS HotelName, SUM(R.Price) AS LostIncome
FROM Room R
JOIN Hotel H ON R.HotelNo = H.HotelNo
LEFT JOIN Booking B ON R.HotelNo = B.HotelNo AND R.RoomNo = B.RoomNo
AND CURDATE() BETWEEN B.DateFrom AND B.DateTo
WHERE B.RoomNo IS NULL
GROUP BY H.HotelNo, H.Name;

-- 9. Create index on one of the fields and show its performance in a query.
CREATE INDEX idx_HotelNo ON Booking (HotelNo);

-- Example query to observe performance with the index
EXPLAIN SELECT * FROM Booking WHERE HotelNo = 1;

-- 10. Create one view on the above database and query it.
-- Creating a view for room booking details including hotel, guest, and room information.
CREATE VIEW RoomBookingDetails AS
SELECT H.Name AS HotelName, H.City, R.RoomNo, R.Type AS RoomType, R.Price, 
       G.GuestName, G.GuestAddress, B.DateFrom, B.DateTo
FROM Booking B
JOIN Hotel H ON B.HotelNo = H.HotelNo
JOIN Room R ON B.HotelNo = R.HotelNo AND B.RoomNo = R.RoomNo
JOIN Guest G ON B.GuestNo = G.GuestNo;
-- Querying the view to get all room booking details.
SELECT * FROM RoomBookingDetails;




