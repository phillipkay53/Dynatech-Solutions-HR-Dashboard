CREATE TABLE CleanedEmployeeData (
    EmployeeID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Location VARCHAR(100),
    Position VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10, 2),
    PerformanceRating INT,
    DateOfBirth DATE,
    Gender VARCHAR(10),
    ContactInfo VARCHAR(100),
    MaritalStatus VARCHAR(20),
    EmergencyContact VARCHAR(100),
    PreviousPositions VARCHAR(100),
    Education VARCHAR(50),
    Certifications VARCHAR(100),
    Address VARCHAR(200),
    WorkRemote VARCHAR(10),
    Absences INT,
    EmploymentStatus VARCHAR(20),
    Race VARCHAR(20),
    BonusReceived VARCHAR(10),
    BenefitsEligibility VARCHAR(10),
    EnrolledInBenefits VARCHAR(10),
    WorkAuthorization VARCHAR(20),
    Travel VARCHAR(10),
    CompanyAssignedComputer VARCHAR(10)
);
INSERT INTO CleanedEmployeeData
SELECT
    EmployeeID,
    Name,
    Department,
    Location,
    Position,
    HireDate,
    Salary,
    PerformanceRating,
    DateOfBirth,
    Gender,
    ContactInfo,
    MaritalStatus,
    EmergencyContact,
    PreviousPositions,
    Education,
    Certifications,
    Address,
    WorkRemote,
    Absences,
    EmploymentStatus,
    Race,
    BonusReceived,
    BenefitsEligibility,
    EnrolledInBenefits,
    WorkAuthorization,
    Travel,
    CompanyAssignedComputer
FROM
    RawEmployeeData
WHERE
    EmploymentStatus = 'Full-time';


CREATE VIEW CompanyOverview AS
SELECT
    Department,
    COUNT(EmployeeID) AS Headcount,
    AVG(Salary) AS AverageSalary
FROM
    CleanedEmployeeData
GROUP BY
    Department;


CREATE VIEW PerformanceReview AS
SELECT
    EmployeeID,
    PerformanceScore,
    COUNT(PerformanceScore) AS RatingCount
FROM
    employee_performance
GROUP BY
    EmployeeID, PerformanceScore;


SELECT
    employee_performance.EmployeeID,
    CleanedEmployeeData.Name,
    AVG(employee_performance.PerformanceScore) AS AverageRating
FROM
    employee_performance
JOIN
    CleanedEmployeeData ON employee_performance.EmployeeID = CleanedEmployeeData.EmployeeID
GROUP BY
    employee_performance.EmployeeID, CleanedEmployeeData.Name
HAVING
    AVG(employee_performance.PerformanceScore) > 4
ORDER BY
    AverageRating DESC;


SELECT
    CleanedEmployeeData.Department,
    COUNT(CleanedEmployeeData.EmployeeID) AS TotalEmployees,
    SUM(CASE WHEN employee_performance.TrainingCompleted = 'Yes' THEN 1 ELSE 0 END) AS TrainingCompleted
FROM
    employee_performance
JOIN
    CleanedEmployeeData ON employee_performance.EmployeeID = CleanedEmployeeData.EmployeeID
GROUP BY
    CleanedEmployeeData.Department;
