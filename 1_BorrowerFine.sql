DECLARE
    rollNum Borrower.Rollin%TYPE;
    nBook Borrower.NameofBook%TYPE;
    iDate Borrower.DateofIssue%TYPE;
    rdate DATE := SYSDATE;  -- Assume current date as the return date
    num_days NUMBER;
    fine_amt NUMBER := 0;
    fine_rate NUMBER;

    -- Exception handling
    e_no_data_found EXCEPTION;
BEGIN
    -- Accepting rollnum and nBook as inputs
    rollnum := &rollnum;
    nBook := '&nBook';

    -- Retrieve the issue date from the Borrower table
    SELECT DateofIssue INTO iDate
    FROM Borrower
    WHERE Rollin = rollnum AND NameofBook = nBook AND Status = 'I';

    -- Calculate the number of days since the book was issued
    num_days := rdate - iDate;

    -- Determine the fine based on the number of days
    IF num_days BETWEEN 15 AND 30 THEN
        fine_rate := 5;
        fine_amt := fine_rate * (num_days - 15);
    ELSIF num_days > 30 THEN
        fine_rate := 50;
        fine_amt := fine_rate * (num_days - 30);
    ELSE
        fine_amt := 0;
    END IF;

    -- Update the status of the book to 'R' (Returned)
    UPDATE Borrower
    SET Status = 'R'
    WHERE Rollin = rollnum AND NameofBook = nBook;

    -- If there is a fine, insert the details into the Fine table
    IF fine_amt > 0 THEN
        INSERT INTO Fine (Roll_no, Date, Amt)
        VALUES (rollnum, rdate, fine_amt);
    END IF;

    -- Display the result
    DBMS_OUTPUT.PUT_LINE('Book returned successfully. Fine amount: ' || fine_amt);

EXCEPTION
    -- Handle case where no matching data is found
    WHEN NO_DATA_FOUND THEN
        RAISE e_no_data_found;
    WHEN e_no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('No matching borrower found or book is already returned.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/
