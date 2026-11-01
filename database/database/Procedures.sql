-- FILE 5: procedures.sql
SET SERVEROUTPUT ON;
-- 1. Register Donor
CREATE OR REPLACE PROCEDURE Register_Donor (
    p_name      IN Donor.Name%TYPE,
    p_contact   IN Donor.Contact%TYPE,
    p_email     IN Donor.Email%TYPE,
    p_address   IN Donor.Address%TYPE,
    p_type      IN Donor.Type%TYPE,
    p_donor_id  OUT Donor.Donor_ID%TYPE
)
AS
BEGIN
    p_donor_id := seq_donor.NEXTVAL;

    INSERT INTO Donor
    (Donor_ID, Name, Contact, Email, Address, Type)
    VALUES
    (p_donor_id, p_name, p_contact, p_email, p_address, p_type);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Donor Registered. ID = ' || p_donor_id);

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Duplicate Email.');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-- 2. Register NGO
CREATE OR REPLACE PROCEDURE Register_NGO (
    p_name      IN NGO.Name%TYPE,
    p_contact   IN NGO.Contact%TYPE,
    p_email     IN NGO.Email%TYPE,
    p_location  IN NGO.Location%TYPE,
    p_license   IN NGO.License_No%TYPE,
    p_ngo_id    OUT NGO.NGO_ID%TYPE
)
AS
BEGIN
    p_ngo_id := seq_ngo.NEXTVAL;

    INSERT INTO NGO
    (NGO_ID, Name, Contact, Email, Location, License_No)
    VALUES
    (p_ngo_id, p_name, p_contact, p_email, p_location, p_license);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('NGO Registered. ID = ' || p_ngo_id);

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Duplicate Email / License.');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-- 3. Add Donation
CREATE OR REPLACE PROCEDURE Add_Donation (
    p_donor_id    IN Food_Donation.Donor_ID%TYPE,
    p_category_id IN Food_Donation.Category_ID%TYPE,
    p_food_type   IN Food_Donation.Food_Type%TYPE,
    p_quantity    IN Food_Donation.Quantity%TYPE,
    p_unit        IN Food_Donation.Unit%TYPE,
    p_expiry_hrs  IN NUMBER,
    p_notes       IN Food_Donation.Notes%TYPE,
    p_donation_id OUT Food_Donation.Donation_ID%TYPE
)
AS
BEGIN
    p_donation_id := seq_donation.NEXTVAL;

    INSERT INTO Food_Donation
    (Donation_ID, Donor_ID, Category_ID, Food_Type, Quantity, Unit, Expiry_Time, Notes)
    VALUES
    (
      p_donation_id,
      p_donor_id,
      p_category_id,
      p_food_type,
      p_quantity,
      p_unit,
      SYSTIMESTAMP + NUMTODSINTERVAL(p_expiry_hrs,'HOUR'),
      p_notes
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Donation Added. ID = ' || p_donation_id);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-- 4. Request Pickup
CREATE OR REPLACE PROCEDURE Request_Pickup (
    p_donation_id IN Donation_Request.Donation_ID%TYPE,
    p_ngo_id      IN Donation_Request.NGO_ID%TYPE,
    p_request_id  OUT Donation_Request.Request_ID%TYPE
)
AS
BEGIN
    p_request_id := seq_request.NEXTVAL;

    INSERT INTO Donation_Request
    (Request_ID, Donation_ID, NGO_ID)
    VALUES
    (p_request_id, p_donation_id, p_ngo_id);

    UPDATE Food_Donation
    SET Status = 'Requested'
    WHERE Donation_ID = p_donation_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pickup Requested. ID = ' || p_request_id);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-- 5. Assign Volunteer
CREATE OR REPLACE PROCEDURE Assign_Volunteer (
    p_request_id   IN Pickup.Request_ID%TYPE,
    p_volunteer_id IN Pickup.Volunteer_ID%TYPE,
    p_pickup_date  IN Pickup.Pickup_Date%TYPE,
    p_pickup_id    OUT Pickup.Pickup_ID%TYPE
)
AS
BEGIN
    p_pickup_id := seq_pickup.NEXTVAL;

    INSERT INTO Pickup
    (Pickup_ID, Request_ID, Volunteer_ID, Pickup_Date)
    VALUES
    (p_pickup_id, p_request_id, p_volunteer_id, p_pickup_date);

    UPDATE Volunteer
    SET Availability = 'Busy'
    WHERE Volunteer_ID = p_volunteer_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Volunteer Assigned. Pickup ID = ' || p_pickup_id);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-- 6. Complete Pickup
CREATE OR REPLACE PROCEDURE Complete_Pickup (
    p_pickup_id IN Pickup.Pickup_ID%TYPE
)
AS
BEGIN
    UPDATE Pickup
    SET Status = 'Completed',
        Actual_Pickup = SYSTIMESTAMP
    WHERE Pickup_ID = p_pickup_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pickup Completed.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
-- Verify Procedures
SELECT object_name, status
FROM user_objects
WHERE object_type = 'PROCEDURE'
ORDER BY object_name;