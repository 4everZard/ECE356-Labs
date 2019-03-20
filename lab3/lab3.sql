-- Part 1
-- show variables like "autocommit";
-- SET autocommit = 0;
-- show variables like 'tx_isolation';
-- Cycle through 0, 1, 2, AND 3 like the following:
SET SESSION tx_isolation = 2;
COMMIT;

BEGIN;
UPDATE Offering SET Enrollment = Enrollment - 20 WHERE courseID="ECE356" AND section = 2 AND termCode = 1191;
-- Check other connection now before rollback
ROLLBACK;

-- Part 2
-- Stored Procedure
DELIMITER //
CREATE PROCEDURE switchSection (
    IN inCourseID CHAR(8), 
    IN inSection1 INT(11),
    IN inSection2 INT(11),
    IN inTermCode DECIMAL(4,0),
    IN inQuantity INT(11),
    OUT outErrorCode INT(11)
    )

BEGIN

BEGIN
DECLARE rmCapacity INT;
SET outErrorCode = 0;

-- Check if initial condition are correct
IF (
(SELECT EXISTS(SELECT * FROM Offering WHERE courseID = inCourseID AND section = inSection1 AND termCode = inTermCode) = 0) OR 
(SELECT EXISTS(SELECT * FROM Offering WHERE courseID = inCourseID AND section = inSection2 AND termCode = inTermCode) = 0) OR
(inSection1 = inSection2) OR
(inQuantity <= 0)) THEN 
SET outErrorCode = -1;
END IF;

-- Code block for increasing enrollment of section 1
IF (outErrorCode = 0) THEN
UPDATE Offering SET Enrollment = Enrollment - inQuantity WHERE courseID = inCourseID AND section = inSection1 AND termCode = inTermCode;
IF ((SELECT enrollment FROM Offering WHERE courseID = inCourseID AND section = inSection1 AND termcode = inTermCode) < 0) THEN
SET outErrorCode = -2;
END IF;
END IF;

SET rmCapacity = (SELECT C.capacity FROM Offering AS O INNER JOIN Classroom AS C ON O.roomID = C.roomID WHERE O.courseID = inCourseID AND O.section = inSection2 AND O.termcode = inTermCode);

-- Code block decreasing enrollment of section 2
IF (outErrorCode = 0) THEN
UPDATE Offering SET Enrollment = Enrollment + inQuantity WHERE courseID = inCourseID AND section = inSection2 AND termCode = inTermCode;
IF ((SELECT enrollment FROM Offering WHERE courseID = inCourseID AND section = inSection2 AND termcode = inTermCode) > rmCapacity) THEN
SET outErrorCode = -3;
END IF;
END IF;

-- Rollback if there are any errors, else commit.
IF (outErrorCode < 0) THEN
ROLLBACK;
ELSE
COMMIT;
END IF;
END;

END //
DELIMITER ;

-- Test cases

-- CASE 1:
-- These calls will return error -1
SELECT * FROM Offering;
-- No course ID
CALL switchSection("ABC123", 1, 2, 1191, 1, @output);
SELECT @output;
-- Quantity is negative
CALL switchSection("ECE356", 1, 2, 1191, -1, @output);
SELECT @output;
-- No section 5 exists 
CALL switchSection("ECE356", 5, 2, 1191, 10, @output);
SELECT @output;
-- No section 6 exists
CALL switchSection("ECE356", 1, 6, 1191, 10, @output);
SELECT @output;
-- No termCode 2019 exists
CALL switchSection("ECE356", 1, 2, 2019, 10, @output);
SELECT @output;
-- inSection1==inSection2
CALL switchSection("ECE356", 1, 1, 2019, 10, @output);
SELECT @output;

-- CASE 2:
-- These calls test error -2 output. We first lower the value of enrollment of the section1
-- to 10 so if we call switchSection with inQuantity=20, we should expect to see errors
SELECT * FROM Offering;
UPDATE Offering SET Enrollment = 10 WHERE courseID = "ECE356" AND section = 1 AND termCode = 1191;
COMMIT;
SELECT * FROM Offering;
-- Trying to remove 2 students from a section of only 1
CALL switchSection("ECE356", 1, 2, 1191, 11, @output);
SELECT @output;

-- CASE 3:
-- This call will return error -3 because we exceed the room capacity of ECE 356
SELECT * FROM Offering;
UPDATE Offering SET Enrollment = 100 WHERE courseID = "ECE356" AND section = 1 AND termCode = 1191;
COMMIT;
SELECT * FROM Offering;
CALL switchSection("ECE356", 1, 2, 1191, 90, @output);
SELECT @output;


-- CASE 4:
-- Sanity check. Should get no error
SELECT * FROM Offering;
UPDATE Offering SET Enrollment = 100 WHERE courseID = "ECE356" AND section = 2 AND termCode = 1191;
COMMIT;
CALL switchSection("ECE356", 1, 2, 1191, 1, @output);
SELECT @output;

