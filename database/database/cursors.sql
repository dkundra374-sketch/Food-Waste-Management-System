-- FILE 7: cursors.sql
SET SERVEROUTPUT ON;
-- 1. Monthly Donation Report
CREATE OR REPLACE PROCEDURE Monthly_Donation_Report (
    p_month IN NUMBER,
    p_year  IN NUMBER
)
AS
    CURSOR c_donations IS
        SELECT D.Name Donor_Name,
               F.Food_Type,
               F.Quantity,
               F.Unit,
               F.Status
        FROM Food_Donation F
        JOIN Donor D ON F.Donor_ID = D.Donor_ID
        WHERE EXTRACT(MONTH FROM F.Listed_At) = p_month
        AND EXTRACT(YEAR FROM F.Listed_At) = p_year
        ORDER BY F.Listed_At;

    v_rec c_donations%ROWTYPE;
    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('MONTHLY DONATION REPORT');

    OPEN c_donations;
    LOOP
        FETCH c_donations INTO v_rec;
        EXIT WHEN c_donations%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_rec.Donor_Name || ' | ' ||
            v_rec.Food_Type || ' | ' ||
            v_rec.Quantity || ' ' || v_rec.Unit || ' | ' ||
            v_rec.Status
        );

        v_count := v_count + 1;
    END LOOP;
    CLOSE c_donations;

    DBMS_OUTPUT.PUT_LINE('Total Donations: ' || v_count);
END;
/
-- 2. NGO Request History
CREATE OR REPLACE PROCEDURE NGO_Request_History (
    p_ngo_id IN NUMBER
)
AS
    CURSOR c_history IS
        SELECT R.Request_ID,
               F.Food_Type,
               R.Status
        FROM Donation_Request R
        JOIN Food_Donation F ON R.Donation_ID = F.Donation_ID
        WHERE R.NGO_ID = p_ngo_id
        ORDER BY R.Request_Date DESC;

    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('NGO REQUEST HISTORY');

    FOR rec IN c_history LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.Request_ID || ' | ' ||
            rec.Food_Type || ' | ' ||
            rec.Status
        );
        v_count := v_count + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total Requests: ' || v_count);
END;
/
-- 3. Expiring Soon Report
CREATE OR REPLACE PROCEDURE Expiring_Soon_Report (
    p_hours IN NUMBER DEFAULT 6
)
AS
    CURSOR c_expiring IS
        SELECT D.Name Donor_Name,
               F.Food_Type,
               F.Quantity,
               F.Unit
        FROM Food_Donation F
        JOIN Donor D ON F.Donor_ID = D.Donor_ID
        WHERE F.Status = 'Available'
        AND F.Expiry_Time > SYSTIMESTAMP
        AND (F.Expiry_Time - SYSTIMESTAMP) * 24 <= p_hours;

    v_count NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('EXPIRING SOON REPORT');

    FOR rec IN c_expiring LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.Donor_Name || ' | ' ||
            rec.Food_Type || ' | ' ||
            rec.Quantity || ' ' || rec.Unit
        );
        v_count := v_count + 1;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Total Expiring: ' || v_count);
END;
/
-- 4. Volunteer Activity Report
CREATE OR REPLACE PROCEDURE Volunteer_Activity_Report
AS
    CURSOR c_volunteers IS
        SELECT V.Name,
               V.Availability,
               COUNT(P.Pickup_ID) Total_Pickups
        FROM Volunteer V
        LEFT JOIN Pickup P ON V.Volunteer_ID = P.Volunteer_ID
        GROUP BY V.Name, V.Availability
        ORDER BY Total_Pickups DESC;
BEGIN
    DBMS_OUTPUT.PUT_LINE('VOLUNTEER ACTIVITY REPORT');

    FOR rec IN c_volunteers LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.Name || ' | ' ||
            rec.Availability || ' | ' ||
            rec.Total_Pickups
        );
    END LOOP;
END;
/
-- Verify Procedures
SELECT object_name, status
FROM user_objects
WHERE object_type = 'PROCEDURE'
AND object_name IN (
'MONTHLY_DONATION_REPORT',
'NGO_REQUEST_HISTORY',
'EXPIRING_SOON_REPORT',
'VOLUNTEER_ACTIVITY_REPORT'
)
ORDER BY object_name;