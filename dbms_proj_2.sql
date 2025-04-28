CREATE DATABASE Projd;
USE Projd;
CREATE TABLE Person (  
    Person_ID INT PRIMARY KEY,  
    Name VARCHAR(100),  
    Date_of_Birth DATE,  
    Address VARCHAR(255),  
    Contact_Number VARCHAR(15),  
    Gender VARCHAR(10),  
    Role VARCHAR(50)  -- e.g., Victim, Suspect, Witness, Officer  
);  

CREATE TABLE Crime (  
    Crime_ID INT PRIMARY KEY,  
    Crime_Type VARCHAR(50),  -- e.g., Theft, Assault, Murder  
    Crime_Date_Time DATETIME,  
    Crime_Location VARCHAR(255),  
    Description TEXT,  
    Status VARCHAR(20)  -- Open, Under Investigation, Closed  
);  

CREATE TABLE Criminal (  
    Criminal_ID INT PRIMARY KEY,  
    Crime_ID INT,  
    Arrest_Status VARCHAR(20),  -- Arrested/Not Arrested  
    Criminal_Record TEXT,  
    FOREIGN KEY (Criminal_ID) REFERENCES Person(Person_ID),  
    FOREIGN KEY (Crime_ID) REFERENCES Crime(Crime_ID)  
);  

CREATE TABLE Victim (  
    Victim_ID INT PRIMARY KEY,  
    Crime_ID INT,  
    Injuries TEXT,  -- details of any injuries  
    Compensation_Status VARCHAR(20),  
    FOREIGN KEY (Victim_ID) REFERENCES Person(Person_ID),  
    FOREIGN KEY (Crime_ID) REFERENCES Crime(Crime_ID)  
);  

CREATE TABLE Witness (  
    Witness_ID INT PRIMARY KEY,  
    Crime_ID INT,  
    Statement TEXT,  
    FOREIGN KEY (Witness_ID) REFERENCES Person(Person_ID),  
    FOREIGN KEY (Crime_ID) REFERENCES Crime(Crime_ID)  
);  

CREATE TABLE Police_Officer (  
    Officer_ID INT PRIMARY KEY,  
    Badge_Number VARCHAR(50),  
    Officer_Rank VARCHAR(50),  
    Department VARCHAR(50),  
    FOREIGN KEY (Officer_ID) REFERENCES Person(Person_ID)  
);  

CREATE TABLE Investigation (  
    Investigation_ID INT PRIMARY KEY,  
    Crime_ID INT,  
    Officer_ID INT,  
    Investigation_Start_Date DATETIME,  
    Investigation_End_Date DATETIME,  
    Findings TEXT,  
    FOREIGN KEY (Crime_ID) REFERENCES Crime(Crime_ID),  
    FOREIGN KEY (Officer_ID) REFERENCES Police_Officer(Officer_ID)  
);  

CREATE TABLE Evidence (  
    Evidence_ID INT PRIMARY KEY,  
    Crime_ID INT,  
    Description TEXT,  
    Collected_By INT,  
    Storage_Location VARCHAR(255),  
    FOREIGN KEY (Crime_ID) REFERENCES Crime(Crime_ID),  
    FOREIGN KEY (Collected_By) REFERENCES Police_Officer(Officer_ID)  
);  

CREATE TABLE Cases (  
    Case_ID INT PRIMARY KEY,  
    Crime_ID INT,  
    Assigned_Officer INT,  
    Case_Status VARCHAR(20),  -- Open, Closed, In Court  
    Court_Date DATE,  
    Verdict TEXT,  
    FOREIGN KEY (Crime_ID) REFERENCES Crime(Crime_ID),  
    FOREIGN KEY (Assigned_Officer) REFERENCES Police_Officer(Officer_ID)  
);  

CREATE TABLE Arrest (  
    Arrest_ID INT PRIMARY KEY,  
    Criminal_ID INT,  
    Officer_ID INT,  
    Arrest_Date DATETIME,  
    Arrest_Location VARCHAR(255),  
    FOREIGN KEY (Criminal_ID) REFERENCES Criminal(Criminal_ID),  
    FOREIGN KEY (Officer_ID) REFERENCES Police_Officer(Officer_ID)  
);
-- Insert people (roles vary)
INSERT INTO Person VALUES
(1, 'John Doe', '1985-03-14', '123 Main St', '9876543210', 'Male', 'Victim'),
(2, 'Jane Smith', '1990-06-20', '456 Maple Ave', '9123456780', 'Female', 'Witness'),
(3, 'Tom Hardy', '1982-11-05', '789 Elm St', '9001234567', 'Male', 'Suspect'),
(4, 'Officer Ray', '1975-07-22', 'Police HQ', '9887766554', 'Male', 'Officer');

-- Insert crime
INSERT INTO Crime VALUES
(101, 'Theft', '2024-03-10 22:30:00', 'Downtown Mall', 'Mobile phone stolen from handbag', 'Under Investigation');
(102, 'murder', '2024-03-10 22:30:00', 'rvu', 'body was found in room 202', 'Under Investigation');

-- Criminal details
INSERT INTO Criminal VALUES
(3, 101, 'Not Arrested', 'Previous petty theft in 2021');

-- Victim details
INSERT INTO Victim VALUES
(1, 101, 'Minor scratches', 'Pending');

-- Witness details
INSERT INTO Witness VALUES
(2, 101, 'Saw a man snatch the bag and run towards the parking lot');

-- Officer details
INSERT INTO Police_Officer VALUES
(4, 'BN1234', 'Inspector', 'Downtown Division');

-- Investigation
INSERT INTO Investigation VALUES
(1001, 101, 4, '2024-03-11 09:00:00', NULL, 'Initial inquiry complete. Awaiting CCTV analysis.');

-- Evidence
INSERT INTO Evidence VALUES
(501, 101, 'Bag found near trash can', 4, 'Locker 12 - Downtown PD');

-- Case
INSERT INTO Cases VALUES
(2001, 101, 4, 'Open', NULL, NULL);

-- Arrest (none yet)
-- INSERT INTO Arrest VALUES ... (leave blank if no arrest yet)
SELECT c.Crime_ID, c.Crime_Type, c.Crime_Location, c.Crime_Date_Time, c.Status,
       p.Name AS Officer_Name, po.Officer_Rank
FROM Crime c
JOIN Cases cs ON c.Crime_ID = cs.Crime_ID
JOIN Police_Officer po ON cs.Assigned_Officer = po.Officer_ID
JOIN Person p ON po.Officer_ID = p.Person_ID;
SELECT p.Name AS Criminal_Name, c.Crime_Type, c.Crime_Location, cr.Arrest_Status
FROM Criminal cr
JOIN Person p ON cr.Criminal_ID = p.Person_ID
JOIN Crime c ON cr.Crime_ID = c.Crime_ID;
SELECT p.Name, v.Injuries, v.Compensation_Status, c.Crime_Type
FROM Victim v
JOIN Person p ON v.Victim_ID = p.Person_ID
JOIN Crime c ON v.Crime_ID = c.Crime_ID;
SELECT e.Description, e.Storage_Location, c.Crime_Type, p.Name AS Collected_By
FROM Evidence e
JOIN Crime c ON e.Crime_ID = c.Crime_ID
JOIN Police_Officer po ON e.Collected_By = po.Officer_ID
JOIN Person p ON po.Officer_ID = p.Person_ID;
SELECT Crime_ID, Crime_Type, Crime_Date_Time, Status
FROM Crime
WHERE Status = 'Under Investigation';