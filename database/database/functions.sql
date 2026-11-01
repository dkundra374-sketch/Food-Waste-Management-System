-- FILE 4: functions.sql
SET SERVEROUTPUT ON;
-- 1. Check Expiry Hours Left
CREATE OR REPLACE FUNCTION Check_Expiry (
    p_donation_id IN Food_Donation.Donation_ID%TYPE
) RETURN NUMBER
AS
    v_expiry Food_Donation.Expiry_Time%TYPE;
BEGIN
    SELECT Expiry_Time
    INTO v_expiry
    FROM Food_Donation
    WHERE Donation_ID = p_donation_id;

    RETURN ROUND((v_expiry - SYSTIMESTAMP) * 24, 2);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
    WHEN OTHERS THEN
        RETURN -99;
END;
/
-- 2. Total Donations By Donor
CREATE OR REPLACE FUNCTION Total_Donations_By_Donor (
    p_donor_id IN Donor.Donor_ID%TYPE
) RETURN NUMBER
AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM Food_Donation
    WHERE Donor_ID = p_donor_id;

    RETURN v_total;
END;
/
-- 3. Available Food Count
CREATE OR REPLACE FUNCTION Available_Food_Count
RETURN NUMBER
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Food_Donation
    WHERE Status = 'Available'
    AND Expiry_Time > SYSTIMESTAMP;

    RETURN v_count;
END;
/
-- 4. NGO Request Count
CREATE OR REPLACE FUNCTION Get_NGO_Request_Count (
    p_ngo_id IN NGO.NGO_ID%TYPE
) RETURN NUMBER
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Donation_Request
    WHERE NGO_ID = p_ngo_id;

    RETURN v_count;
END;
/
-- Verify Functions
SELECT object_name, status
FROM user_objects
WHERE object_type = 'FUNCTION'
ORDER BY object_name;