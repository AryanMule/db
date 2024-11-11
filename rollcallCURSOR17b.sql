CREATE DATABASE IF NOT EXISTS rollcallCURSOR;
USE rollcallCURSOR;

-- Step 1: Create the N_RollCall and O_RollCall tables
CREATE TABLE IF NOT EXISTS N_RollCall (
    roll_no INT PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS O_RollCall (
    roll_no INT PRIMARY KEY,
    student_name VARCHAR(100)
);

-- Step 2: Insert sample data into N_RollCall table
INSERT INTO N_RollCall (roll_no, student_name) VALUES
(1, 'John Doe'),
(2, 'Jane Smith'),
(3, 'Sam Brown');

-- Step 3: Create the stored procedure with cursor to merge data
DELIMITER $$

CREATE PROCEDURE merge_rollcall_data()
BEGIN
    -- Declare cursor to fetch data from N_RollCall
    DECLARE done INT DEFAULT 0;
    DECLARE v_roll_no INT;
    DECLARE v_student_name VARCHAR(100);

    -- Declare the cursor
    DECLARE c_n_rollcall CURSOR FOR
        SELECT roll_no, student_name FROM N_RollCall;

    -- Declare CONTINUE HANDLER for when the cursor is exhausted
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN c_n_rollcall;

    -- Loop through the cursor
    read_loop: LOOP
        FETCH c_n_rollcall INTO v_roll_no, v_student_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insert into O_RollCall if the roll_no does not already exist
        INSERT INTO O_RollCall (roll_no, student_name)
        SELECT v_roll_no, v_student_name
        WHERE NOT EXISTS (
            SELECT 1 FROM O_RollCall WHERE roll_no = v_roll_no
        );
    END LOOP;

    -- Close the cursor
    CLOSE c_n_rollcall;

    -- Output message
    SELECT 'Data merged successfully.' AS message;
END$$

DELIMITER ;

-- Step 4: Execute the procedure to merge the data
CALL merge_rollcall_data();

-- Step 5: Check the results
SELECT * FROM O_RollCall;
