-------------------------------------
--Create the O_RollCall Table
--CREATE TABLE O_RollCall (
    --student_id NUMBER PRIMARY KEY,
    --student_name VARCHAR2(100),
    --roll_date DATE
--);

--Create the N_RollCall Table
--CREATE TABLE N_RollCall (
    --student_id NUMBER PRIMARY KEY,
    --student_name VARCHAR2(100),
    --roll_date DATE
--);

-------------------------------------
DECLARE
    -- Parameterized cursor to select data from N_RollCall
    CURSOR rollcall(p_student_id NUMBER) IS
        SELECT student_id, student_name, roll_date FROM N_RollCall WHERE student_id = p_student_id;

    v_studid O_RollCall.student_id%TYPE;
    v_studname O_RollCall.student_name%TYPE;
    v_roll O_RollCall.roll_date%TYPE;

BEGIN
    -- Loop through the records in N_RollCall
    FOR rec IN (SELECT student_id, student_name, roll_date FROM N_RollCall) LOOP
        -- Check if the student already exists in O_RollCall
        OPEN rollcall(rec.student_id);
        FETCH rollcall INTO v_stuId, v_studname, v_roll;
        CLOSE rollcall;

        IF NOT EXISTS (SELECT 1 FROM O_RollCall WHERE student_id = rec.student_id) THEN
            -- Insert new records into O_RollCall if not present
            INSERT INTO O_RollCall (student_id, student_name, roll_date)
            VALUES (rec.student_id, rec.student_name, rec.roll_date);

            DBMS_OUTPUT.put_line('Inserted: ' || rec.student_name);
        ELSE
            DBMS_OUTPUT.put_line('Skipped (duplicate): ' || rec.student_name);
        END IF;
    END LOOP;

    COMMIT;
END;
/
