-- FILE 8: views.sql
-- Drop views if exist
BEGIN EXECUTE IMMEDIATE 'DROP VIEW Active_Donations_View'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW NGO_Pickup_Summary'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW Donor_Contribution_View'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW Pending_Requests_View'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW Full_Pickup_Details_View'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
-- 1. Active Donations
CREATE OR REPLACE VIEW Active_Donations_View AS
SELECT
    F.Donation_ID,
    D.Name AS Donor_Name,
    F.Food_Type,
    F.Quantity,
    F.Unit,
    F.Expiry_Time,
    F.Status
FROM Food_Donation F
JOIN Donor D ON F.Donor_ID = D.Donor_ID
WHERE F.Status = 'Available'
AND F.Expiry_Time > SYSTIMESTAMP;
-- 2. NGO Pickup Summary
CREATE OR REPLACE VIEW NGO_Pickup_Summary AS
SELECT
    N.NGO_ID,
    N.Name AS NGO_Name,
    COUNT(R.Request_ID) AS Total_Requests
FROM NGO N
LEFT JOIN Donation_Request R
ON N.NGO_ID = R.NGO_ID
GROUP BY N.NGO_ID, N.Name;
-- 3. Donor Contribution
CREATE OR REPLACE VIEW Donor_Contribution_View AS
SELECT
    D.Donor_ID,
    D.Name,
    COUNT(F.Donation_ID) AS Total_Donations
FROM Donor D
LEFT JOIN Food_Donation F
ON D.Donor_ID = F.Donor_ID
GROUP BY D.Donor_ID, D.Name;
-- 4. Pending Requests
CREATE OR REPLACE VIEW Pending_Requests_View AS
SELECT
    R.Request_ID,
    N.Name AS NGO_Name,
    F.Food_Type,
    R.Status
FROM Donation_Request R
JOIN NGO N ON R.NGO_ID = N.NGO_ID
JOIN Food_Donation F ON R.Donation_ID = F.Donation_ID
WHERE R.Status = 'Pending';
-- 5. Full Pickup Details
CREATE OR REPLACE VIEW Full_Pickup_Details_View AS
SELECT
    P.Pickup_ID,
    D.Name AS Donor_Name,
    N.Name AS NGO_Name,
    V.Name AS Volunteer_Name,
    P.Status
FROM Pickup P
JOIN Donation_Request R ON P.Request_ID = R.Request_ID
JOIN Food_Donation F ON R.Donation_ID = F.Donation_ID
JOIN Donor D ON F.Donor_ID = D.Donor_ID
JOIN NGO N ON R.NGO_ID = N.NGO_ID
LEFT JOIN Volunteer V ON P.Volunteer_ID = V.Volunteer_ID;
-- Verify Views
SELECT view_name
FROM user_views
ORDER BY view_name;