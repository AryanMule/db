CREATE DATABASE productsCursorSET2;
USE productsCursorSET2;

CREATE TABLE Products (
    Product_id INT PRIMARY KEY,
    Product_Name VARCHAR(100),
    Product_Type VARCHAR(50),
    Price DECIMAL(10, 2)
);

INSERT INTO Products (Product_id, Product_Name, Product_Type, Price) VALUES
(1, 'T-shirt', 'Apparel', 1500),
(2, 'Jeans', 'Apparel', 3000),
(3, 'Jacket', 'Apparel', 7000),
(4, 'Sneakers', 'Footwear', 4000),
(5, 'Shirt', 'Apparel', 2500),
(6, 'Cap', 'Apparel', 1200),
(7, 'Laptop', 'Electronics', 50000);

-- Parameterized Cursor for Displaying Products in a Given Price Range and Type ‘Apparel
DELIMITER $$

CREATE PROCEDURE DisplayProductsInPriceRange(min_price DECIMAL(10, 2), max_price DECIMAL(10, 2))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE prod_id INT;
    DECLARE prod_name VARCHAR(100);
    DECLARE prod_type VARCHAR(50);
    DECLARE prod_price DECIMAL(10, 2);
    
    -- Declare a cursor to select products of type 'Apparel' within the price range
    DECLARE product_cursor CURSOR FOR
        SELECT Product_id, Product_Name, Product_Type, Price
        FROM Products
        WHERE Product_Type = 'Apparel' AND Price BETWEEN min_price AND max_price;
        
    -- Declare a handler to close the cursor when no rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN product_cursor;

    -- Loop through the cursor and display results
    product_loop: LOOP
        FETCH product_cursor INTO prod_id, prod_name, prod_type, prod_price;
        
        IF done THEN
            LEAVE product_loop;
        END IF;

        -- Output the product details (you can replace this with a SELECT statement if needed)
        SELECT prod_id AS Product_ID, prod_name AS Product_Name, prod_price AS Price;
    END LOOP;

    CLOSE product_cursor;
END $$

DELIMITER ;
-- Call procedure with a price range of 1000 to 3000
CALL DisplayProductsInPriceRange(1000, 3000);


-- Explicit Cursor to Display Information of All Products with Price Greater than 5000
DELIMITER $$

CREATE PROCEDURE DisplayHighPriceProducts()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE prod_id INT;
    DECLARE prod_name VARCHAR(100);
    DECLARE prod_type VARCHAR(50);
    DECLARE prod_price DECIMAL(10, 2);
    
    -- Declare an explicit cursor to select products with Price > 5000
    DECLARE high_price_cursor CURSOR FOR
        SELECT Product_id, Product_Name, Product_Type, Price
        FROM Products
        WHERE Price > 5000;
        
    -- Declare a handler to close the cursor when no rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN high_price_cursor;

    -- Loop through the cursor and display results
    product_loop: LOOP
        FETCH high_price_cursor INTO prod_id, prod_name, prod_type, prod_price;
        
        IF done THEN
            LEAVE product_loop;
        END IF;

        -- Output the product details (you can replace this with a SELECT statement if needed)
        SELECT prod_id AS Product_ID, prod_name AS Product_Name, prod_price AS Price;
    END LOOP;

    CLOSE high_price_cursor;
END $$

DELIMITER ;
CALL DisplayHighPriceProducts();



DELIMITER $$

CREATE PROCEDURE UpdateProductPrice()
BEGIN
    -- Declare the variable to store the number of affected rows
    DECLARE rows_affected INT;

    -- Implicit cursor for the update operation
    UPDATE Products
    SET Price = Price + 1000;

    -- Get the number of affected rows using ROW_COUNT()
    SET rows_affected = ROW_COUNT();

    -- Display the number of rows affected
    SELECT rows_affected AS Rows_Affected;
END $$

DELIMITER ;

-- Call the stored procedure to execute the update and check the number of rows affected
SET SQL_SAFE_UPDATES = 0;
CALL UpdateProductPrice();
SET SQL_SAFE_UPDATES = 1;




