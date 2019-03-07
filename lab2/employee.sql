-- Create tables for schema in BCNF forms
CREATE TABLE Employee (
    empID       INT(11) PRIMARY KEY,
    firstName   VARCHAR(50),
    lastName    VARCHAR(50),
    job         INT(11),
    salary      INT(11)
)

CREATE TABLE EmpMiddleNames (
    empID           INT(11),
    middleNameNum   INT(11),
    middleName      VARCHAR(50),
    PRIMARY KEY (empID, middleNameNum)
)

CREATE TABLE Department (
    deptID      INT(11) PRIMARY KEY,
    deptName    VARCHAR(50)
)

CREATE TABLE EmpDept (
    empID   INT(11),
    deptID  INT(11),
    PRIMARY KEY (empID, deptID),
    FOREIGN KEY (empID) REFERENCES Employee(empID),
    FOREIGN KEY (deptID) REFERENCES Department(deptID)
)

CREATE TABLE DeptPostalCodes (
    postalCode  VARCHAR(6) PRIMARY KEY,
    city        VARCHAR(50),
    provinc     VARCHAR(50)
)

CREATE TABLE DeptAddress (
    deptID      INT(11),
    postalCode  VARCHAR(6),
    streetName  VARCHAR(50),
    streetNum   INT(11),
    PRIMARY KEY (deptID, postalCode, streetName, streetNum),
    FOREIGN KEY (deptID) REFERENCES Department(deptID),
    FOREIGN KEY (postalCode) REFERENCES DeptPostalCodes(postalCode)
)

CREATE TABLE Project (
    projID     INT(11) PRIMARY KEY,
    title      VARCHAR(50),
    budget     INT(11),
    funds      INT(11)
)

CREATE TABLE Assigned (
    empID       INT(11),
    projID      INT(11),
    role        VARCHAR(100)
    PRIMARY KEY (empID, deptID, role),
    FOREIGN KEY (empID) REFERENCES Employee(empID),
    FOREIGN KEY (projID) REFERENCES Project(projID)
)

-- Create Views for original schema
CREATE VIEW EmployeeOriginal AS (
    SELECT e.empID, CONCAT(e.firstName, " ", m.middleName, " ",  e.lastName) AS empName, e.job, e.deptID, e.salary
        FROM Employee AS e INNER JOIN EmpMiddleNames AS m USING(empID);
)

CREATE VIEW DepartmentOriginal AS (
    SELECT d.deptID, d.deptName, CONCAT(da.streetNumber, " ", da.streetName, " ", p.cityName, " ", p.province, " ", p.postalCode) AS location 
        FROM Department AS d INNER JOIN DepartmentAddress AS da USING(deptID) INNER JOIN PostalCode AS p USING(postalCode);
)

-- Create payRaise procedure
DELIMITER //
CREATE PROCEDURE payRaise (IN inEmpID INT(11), IN inPercentageRaise DOUBLE(4, 2), OUT errorCode INT(11))
BEGIN
DECLARE tempSalary INT;
IF inPercentageRaise > 10 OR inPercentageRaise < 0 THEN
    SET errorCode = -1;
ELSEIF (SELECT COUNT(*) FROM Employee WHERE empID = inEmpID) = 0 THEN
    SET errorCode = -2;
ELSE
    SELECT salary INTO tempSalary FROM Employee WHERE empID = inEmpID;
    SET tempSalary = tempSalary*(1 + inPercentageRaise/100);
    UPDATE Employee SET salary = tempSalary WHERE empID = inEmpID;
    SET errorCode = 0;
END IF;
END //
DELIMITER ;

-- Call procedure to give waterloo employees a 5% pay raise
DECLARE my_cursor CURSOR FAST_FORWARD FOR (
    SELECT empID 
        FROM Employee AS e INNER JOIN EmpDept AS ed USING(empID) INNER JOIN DeptAddress AS da USING(deptID) INNER JOIN DeptPostalCodes AS dpc USING(postalCode)
        WHERE dpc.city = "Waterloo"
);
OPEN my_cursor
FETCH NEXT FROM my_cursor INTO @cursorId

WHILE @@FETCH_STATUS = 0
BEGIN
    CALL payRaise(@cursorId, 5, @output);
    SELECT @output;
    FETCH NEXT FROM my_cursor INTO @cursorId
END;

CLOSE my_cursor;
DEALLOCATE my_cursor;
