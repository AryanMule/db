CREATE DATABASE accountmaster;
USE accountmaster;


CREATE TABLE account_master (
    account_id INT PRIMARY KEY,
    account_holder_name VARCHAR(100),
    current_balance DECIMAL(10, 2)
);


INSERT INTO account_master (account_id, account_holder_name, current_balance) VALUES
(1, 'John Doe', 5000.00),
(2, 'Jane Smith', 3000.00),
(3, 'Sam Brown', 1500.00);

DELIMITER $$

CREATE PROCEDURE withdraw_funds(IN v_account_id INT, IN v_withdraw_amount DECIMAL(10,2))
BEGIN
    DECLARE v_balance DECIMAL(10, 2);
    
    -- Fetch the current balance from account_master table
    SELECT current_balance
    INTO v_balance
    FROM account_master
    WHERE account_id = v_account_id;
    
    -- Check if withdrawal amount is greater than current balance
    IF v_withdraw_amount > v_balance THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Insufficient funds for withdrawal';
    ELSE
        -- Perform the withdrawal (Update the account balance)
        UPDATE account_master
        SET current_balance = current_balance - v_withdraw_amount
        WHERE account_id = v_account_id;
        
        -- Fetch the updated balance after withdrawal
        SELECT current_balance
        INTO v_balance
        FROM account_master
        WHERE account_id = v_account_id;

        SELECT CONCAT('Withdrawal successful. New balance: ', v_balance) AS message;
    END IF;
END$$

DELIMITER ;




-- Example: Withdraw 2000 from account_id 1
-- Example: Withdraw 2000 from account_id 1
CALL withdraw_funds(1, 2000);
