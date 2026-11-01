-- FILE 2: tables.sql
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Audit_Log        CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Notification     CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Pickup           CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Donation_Request CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Food_Donation    CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Food_Category    CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Volunteer        CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE NGO              CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Donor            CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Admin            CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

--TABLE 1: Admin 
CREATE TABLE Admin (
    Admin_ID    NUMBER(5)       PRIMARY KEY,
    Name        VARCHAR2(100)   NOT NULL,
    Email       VARCHAR2(100)   UNIQUE NOT NULL,
    Password    VARCHAR2(255)   NOT NULL,
    Created_At  DATE            DEFAULT SYSDATE
);
--TABLE 2: Donor
CREATE TABLE Donor (
    Donor_ID      NUMBER(8)     PRIMARY KEY,
    Name          VARCHAR2(100) NOT NULL,
    Contact       VARCHAR2(15)  NOT NULL,
    Email         VARCHAR2(100) UNIQUE,
    Address       VARCHAR2(255),
    Type          VARCHAR2(20)  CHECK (Type IN ('Restaurant','Hostel','Household','Event','Other')),
    Registered_At DATE          DEFAULT SYSDATE,
    Is_Active     CHAR(1)       DEFAULT 'Y' CHECK (Is_Active IN ('Y','N'))
);
--TABLE 3: NGO
CREATE TABLE NGO (
    NGO_ID        NUMBER(8)     PRIMARY KEY,
    Name          VARCHAR2(100) NOT NULL,
    Contact       VARCHAR2(15)  NOT NULL,
    Email         VARCHAR2(100) UNIQUE,
    Location      VARCHAR2(255),
    License_No    VARCHAR2(50)  UNIQUE,
    Registered_At DATE          DEFAULT SYSDATE,
    Is_Active     CHAR(1)       DEFAULT 'Y' CHECK (Is_Active IN ('Y','N'))
);
--TABLE 4: Volunteer
CREATE TABLE Volunteer (
    Volunteer_ID  NUMBER(8)     PRIMARY KEY,
    Name          VARCHAR2(100) NOT NULL,
    Contact       VARCHAR2(15)  NOT NULL,
    Email         VARCHAR2(100) UNIQUE,
    Area_Covered  VARCHAR2(100),
    Availability  VARCHAR2(20)  DEFAULT 'Available'
                  CHECK (Availability IN ('Available','Busy','Inactive')),
    Joined_Date   DATE          DEFAULT SYSDATE
);
--TABLE 5: Food_Category
CREATE TABLE Food_Category (
    Category_ID   NUMBER(5)     PRIMARY KEY,
    Category_Name VARCHAR2(50)  NOT NULL UNIQUE,
    Description   VARCHAR2(200)
);
--TABLE 6: Food_Donation
CREATE TABLE Food_Donation (
    Donation_ID   NUMBER(10)    PRIMARY KEY,
    Donor_ID      NUMBER(8)     NOT NULL,
    Category_ID   NUMBER(5),
    Food_Type     VARCHAR2(100) NOT NULL,
    Quantity      NUMBER(8,2)   NOT NULL CHECK (Quantity > 0),
    Unit          VARCHAR2(20)  DEFAULT 'kg'
                  CHECK (Unit IN ('kg','litres','packets','portions','boxes')),
    Expiry_Time   TIMESTAMP     NOT NULL,
    Listed_At     TIMESTAMP     DEFAULT SYSTIMESTAMP,
    Status        VARCHAR2(20)  DEFAULT 'Available'
                  CHECK (Status IN ('Available','Requested','Assigned','Collected','Expired','Cancelled')),
    Notes         VARCHAR2(500),
    CONSTRAINT fk_donation_donor    FOREIGN KEY (Donor_ID)    REFERENCES Donor(Donor_ID),
    CONSTRAINT fk_donation_category FOREIGN KEY (Category_ID) REFERENCES Food_Category(Category_ID)
);
--TABLE 7: Donation_Request
CREATE TABLE Donation_Request (
    Request_ID    NUMBER(10)    PRIMARY KEY,
    Donation_ID   NUMBER(10)    NOT NULL,
    NGO_ID        NUMBER(8)     NOT NULL,
    Request_Date  TIMESTAMP     DEFAULT SYSTIMESTAMP,
    Status        VARCHAR2(20)  DEFAULT 'Pending'
                  CHECK (Status IN ('Pending','Approved','Rejected','Completed')),
    Admin_Remarks VARCHAR2(500),
    CONSTRAINT fk_req_donation FOREIGN KEY (Donation_ID) REFERENCES Food_Donation(Donation_ID),
    CONSTRAINT fk_req_ngo      FOREIGN KEY (NGO_ID)      REFERENCES NGO(NGO_ID)
);
--TABLE 8: Pickup
CREATE TABLE Pickup (
    Pickup_ID      NUMBER(10)   PRIMARY KEY,
    Request_ID     NUMBER(10)   NOT NULL,
    Volunteer_ID   NUMBER(8),
    Pickup_Date    DATE,
    Actual_Pickup  TIMESTAMP,
    Status         VARCHAR2(20) DEFAULT 'Scheduled'
                   CHECK (Status IN ('Scheduled','In_Transit','Completed','Failed')),
    Notes          VARCHAR2(500),
    CONSTRAINT fk_pickup_request   FOREIGN KEY (Request_ID)   REFERENCES Donation_Request(Request_ID),
    CONSTRAINT fk_pickup_volunteer FOREIGN KEY (Volunteer_ID) REFERENCES Volunteer(Volunteer_ID)
);
--TABLE 9: Notification
CREATE TABLE Notification (
    Notif_ID    NUMBER(10)      PRIMARY KEY,
    User_Type   VARCHAR2(20)    CHECK (User_Type IN ('Admin','Donor','NGO','Volunteer')),
    User_ID     NUMBER(10),
    Message     VARCHAR2(500)   NOT NULL,
    Is_Read     CHAR(1)         DEFAULT 'N' CHECK (Is_Read IN ('Y','N')),
    Created_At  TIMESTAMP       DEFAULT SYSTIMESTAMP
);
--TABLE 10: Audit_Log
CREATE TABLE Audit_Log (
    Log_ID      NUMBER(10)      PRIMARY KEY,
    Table_Name  VARCHAR2(50),
    Operation   VARCHAR2(10)    CHECK (Operation IN ('INSERT','UPDATE','DELETE')),
    Record_ID   NUMBER(10),
    Changed_By  VARCHAR2(100),
    Changed_At  TIMESTAMP       DEFAULT SYSTIMESTAMP,
    Old_Status  VARCHAR2(50),
    New_Status  VARCHAR2(50)
);
--Indexes for faster querying
CREATE INDEX idx_donation_status  ON Food_Donation(Status);
CREATE INDEX idx_donation_donor   ON Food_Donation(Donor_ID);
CREATE INDEX idx_request_ngo      ON Donation_Request(NGO_ID);
CREATE INDEX idx_pickup_volunteer ON Pickup(Volunteer_ID);
--Verify all tables
SELECT table_name FROM user_tables ORDER BY table_name;