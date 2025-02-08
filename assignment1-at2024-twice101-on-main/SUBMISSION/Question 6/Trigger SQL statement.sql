
--Purpose: Ensures that a customer cannot order more units of a product than are currently in stock.
--Trigger logic: If NEW.Oquantity exceeds the stock, the trigger prevents the insert with an error
--Error Handling: return an error message: "Insufficient stock for the product" when stock is insufficie

CREATE TRIGGER check_product_stock
BEFORE INSERT ON order_contains
FOR EACH ROW
BEGIN
    -- Check if the requested quantity exceeds the available stock
    SELECT CASE 
        WHEN NEW.Oquantity > (SELECT Pstock_count 
                              FROM Products 
                              WHERE Pproduct_number = NEW.Pproduct_number)
        THEN RAISE(ABORT, 'Error: Insufficient stock for the product.')
    END;
END;
