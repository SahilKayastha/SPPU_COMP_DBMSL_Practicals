--------------------------------------------------------------------------------------------------------------------
-- Create the Library Table
-- CREATE TABLE Library (
--     book_id NUMBER PRIMARY KEY,
--     book_name VARCHAR2(100),
--     author_name VARCHAR2(100),
--     published_year NUMBER
-- );
-- Insert sample data into the Library table:

-- Create the Library_Audit Table : This table will store the old values of the records when an update or delete operation is performed on the Library table.
-- CREATE TABLE Library_Audit (
--     audit_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
--     book_id NUMBER,
--     book_name VARCHAR2(100),
--     author_name VARCHAR2(100),
--     published_year NUMBER,
--     operation_type VARCHAR2(10), -- Will store whether it's 'UPDATE' or 'DELETE'
--     audit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
-- );

--Create the Trigger on the Library Table
---The BEFORE UPDATE OR DELETE trigger will fire whenever a record in the Library table is about to be updated or deleted. The old values will be inserted into the Library_Audit table.
-------------------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_Library_Audit BEFORE UPDATE OR DELETE ON Library FOR EACH ROW
BEGIN
    -- Capture old values before an update or delete
    IF UPDATING THEN
        INSERT INTO Library_Audit (book_id, book_name, author_name, published_year, operation_type)
        VALUES (:OLD.book_id, :OLD.book_name, :OLD.author_name, :OLD.published_year, 'UPDATE');
        
    ELSIF DELETING THEN
        INSERT INTO Library_Audit (book_id, book_name, author_name, published_year, operation_type)
        VALUES (:OLD.book_id, :OLD.book_name, :OLD.author_name, :OLD.published_year, 'DELETE');
    END IF;
END;
/
