-- FILE 9: test_queries.sql
SET SERVEROUTPUT ON;
-- 1. Show All Tables
SELECT table_name
FROM user_tables
ORDER BY table_name;
-- 2. Show Donors
SELECT *
FROM Donor;
-- 3. Show Donations
SELECT Donation_ID, Food_Type, Quantity, Unit, Status
FROM Food_Donation
ORDER BY Donation_ID;
-- 4. Join Query (Donor + Donation)
SELECT D.Name AS Donor_Name,
       F.Food_Type,
       F.Quantity,
       F.Status
FROM Donor D
JOIN Food_Donation F
ON D.Donor_ID = F.Donor_ID;
-- 5. Count Donations By Status
SELECT Status, COUNT(*) AS Total
FROM Food_Donation
GROUP BY Status
ORDER BY Total DESC;
-- 6. Function Test
SELECT Available_Food_Count() AS Available_Donations
FROM dual;
-- 7. View Test
SELECT *
FROM Active_Donations_View;
-- 8. Procedure Test - Register Donor
DECLARE
   v_id NUMBER;
BEGIN
   Register_Donor(
      'Demo Donor',
      '9876500000',
      'demo@donor.com',
      'Patiala',
      'Restaurant',
      v_id
   );
END;
/
-- 9. Verify New Donor Added
SELECT *
FROM Donor
ORDER BY Donor_ID DESC
FETCH FIRST 1 ROW ONLY;
-- 10. Trigger Test (Invalid Quantity)
BEGIN
   INSERT INTO Food_Donation
   (Donation_ID, Donor_ID, Food_Type, Quantity, Unit, Expiry_Time)
   VALUES
   (seq_donation.NEXTVAL, 1001, 'Test Food', 0, 'kg',
    SYSTIMESTAMP + INTERVAL '5' HOUR);
EXCEPTION
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-- 11. Audit Log Check
SELECT *
FROM Audit_Log
ORDER BY Changed_At DESC;
-- 12. Notifications Check
SELECT *
FROM Notification
ORDER BY Created_At DESC;