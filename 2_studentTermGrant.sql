DECLARE
    roll_no Stud.Roll%TYPE;
    attendance Stud.Att%TYPE;
    status_msg VARCHAR2(20);

    -- Exception for handling no matching data
    e_no_data_found EXCEPTION;
BEGIN
    -- Accepting roll_no as input
    roll_no := &roll_no;

    -- Retrieve attendance for the given roll number
    SELECT Att INTO attendance FROM Stud WHERE Roll = roll_no;

    -- Control structure to check attendance percentage
    IF attendance < 75 THEN
        status_msg := 'Term not granted';
        UPDATE Stud
        SET Status = 'D'  -- D for Term not granted
        WHERE Roll = roll_no;
    ELSE
        status_msg := 'Term granted';
        UPDATE Stud
        SET Status = 'ND'  -- ND for Term granted
        WHERE Roll = roll_no;
    END IF;

    -- Display the appropriate message
    DBMS_OUTPUT.PUT_LINE(status_msg);

EXCEPTION
    -- Handle case where no matching data is found
    WHEN NO_DATA_FOUND THEN
        RAISE e_no_data_found;
    WHEN e_no_data_found THEN
        DBMS_OUTPUT.PUT_LINE('No student found with the entered roll number.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/ 



--------------------------------------------------
--Create the Table: The Stud table will contain the Roll (Roll number), Att (Attendance percentage), Status fields.

--CREATE TABLE Stud (
    --Roll INT PRIMARY KEY,
    --Att NUMBER(5, 2),    -- Attendance percentage (e.g., 75.50)
    --Status CHAR(2)       -- 'D' for term not granted, 'ND' for term granted
)
--------------------------------------------------
