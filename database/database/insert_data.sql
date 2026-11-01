-- FILE 3: sample_data.sql
--Admin
INSERT INTO Admin (Admin_ID, Name, Email, Password)
VALUES (seq_admin.NEXTVAL, 'Super Admin', 'admin@foodwaste.org', 'hashed_pass_001');
--Food Categories
INSERT INTO Food_Category VALUES (seq_category.NEXTVAL, 'Cooked Food','Freshly cooked meals ready to eat');
INSERT INTO Food_Category VALUES (seq_category.NEXTVAL, 'Raw Vegetables','Uncooked vegetables and greens');
INSERT INTO Food_Category VALUES (seq_category.NEXTVAL, 'Packaged Food','Sealed packaged items with printed expiry');
INSERT INTO Food_Category VALUES (seq_category.NEXTVAL, 'Bakery Items','Bread, cakes, pastries');
INSERT INTO Food_Category VALUES (seq_category.NEXTVAL, 'Dairy Products', 'Milk, curd, paneer, cheese');
--Donors
INSERT INTO Donor (Donor_ID, Name, Contact, Email, Address, Type)
VALUES (seq_donor.NEXTVAL, 'Punjabi Dhaba Patiala','9876543210','dhaba@gmail.com','Rajpura Road, Patiala','Restaurant');

INSERT INTO Donor (Donor_ID, Name, Contact, Email, Address, Type)
VALUES (seq_donor.NEXTVAL, 'TIET Hostel Mess','9988776655','mess@thapar.edu','TIET Campus, Patiala','Hostel');

INSERT INTO Donor (Donor_ID, Name, Contact, Email, Address, Type)
VALUES (seq_donor.NEXTVAL, 'Sharma Family','9812345678','sharma@gmail.com','Model Town, Patiala','Household');

INSERT INTO Donor (Donor_ID, Name, Contact, Email, Address, Type)
VALUES (seq_donor.NEXTVAL, 'City Wedding Banquet','9765432109','banquet@events.com','Leela Bhawan, Patiala','Event');

INSERT INTO Donor (Donor_ID, Name, Contact, Email, Address, Type)
VALUES (seq_donor.NEXTVAL, 'FreshMart Superstore','9654321098','store@freshmart.com', 'Mall Road, Patiala','Other');

--NGOs
INSERT INTO NGO (NGO_ID, Name, Contact, Email, Location, License_No)
VALUES (seq_ngo.NEXTVAL, 'Roti Bank Patiala',     '9111222333', 'rotibank@ngo.org','Sadar Bazar, Patiala','NGO-PB-2021-001');

INSERT INTO NGO (NGO_ID, Name, Contact, Email, Location, License_No)
VALUES (seq_ngo.NEXTVAL, 'Hunger Free Punjab',    '9222333444', 'hfp@welfare.org','Civil Lines,Patiala','NGO-PB-2020-045');

INSERT INTO NGO (NGO_ID, Name, Contact, Email, Location, License_No)
VALUES (seq_ngo.NEXTVAL, 'Annapurna Seva Trust',  '9333444555', 'annapurna@seva.org','Tripuri, Patiala','NGO-PB-2019-112');

--Volunteers
INSERT INTO Volunteer (Volunteer_ID, Name, Contact, Email, Area_Covered)
VALUES (seq_volunteer.NEXTVAL, 'Arjun Singh','9444555666', 'arjun@vol.com','Rajpura Road, Patiala');

INSERT INTO Volunteer (Volunteer_ID, Name, Contact, Email, Area_Covered)
VALUES (seq_volunteer.NEXTVAL, 'Priya Sharma','9555666777', 'priya@vol.com','Model Town, Patiala');

INSERT INTO Volunteer (Volunteer_ID, Name, Contact, Email, Area_Covered)
VALUES (seq_volunteer.NEXTVAL, 'Rahul Verma','9666777888', 'rahul@vol.com','TIET Campus, Patiala');

INSERT INTO Volunteer (Volunteer_ID, Name, Contact, Email, Area_Covered)
VALUES (seq_volunteer.NEXTVAL, 'Simran Kaur','9777888999', 'simran@vol.com','Civil Lines, Patiala');

--Food Donations
-- Available donations (future expiry)
INSERT INTO Food_Donation (Donation_ID, Donor_ID, Category_ID, Food_Type, Quantity, Unit, Expiry_Time, Notes)
VALUES (seq_donation.NEXTVAL, 1001, 401, 'Dal Makhani + Rice',15, 'kg',SYSTIMESTAMP + INTERVAL '6' HOUR,'Fresh, hot food');

INSERT INTO Food_Donation (Donation_ID, Donor_ID, Category_ID, Food_Type, Quantity, Unit, Expiry_Time, Notes)
VALUES (seq_donation.NEXTVAL, 1002, 401, 'Rajma Chawal',30, 'kg',SYSTIMESTAMP + INTERVAL '4' HOUR,'Leftover from lunch');

INSERT INTO Food_Donation (Donation_ID, Donor_ID, Category_ID, Food_Type, Quantity, Unit, Expiry_Time, Notes)
VALUES (seq_donation.NEXTVAL, 1003, 402, 'Mixed Vegetables',10, 'kg',SYSTIMESTAMP + INTERVAL '24' HOUR, 'Tomatoes, onions, spinach');

INSERT INTO Food_Donation (Donation_ID, Donor_ID, Category_ID, Food_Type, Quantity, Unit, Expiry_Time, Notes)
VALUES (seq_donation.NEXTVAL, 1004, 401, 'Paneer Butter Masala', 20, 'kg',SYSTIMESTAMP + INTERVAL '3' HOUR,'Wedding function leftovers');

INSERT INTO Food_Donation (Donation_ID, Donor_ID, Category_ID, Food_Type, Quantity, Unit, Expiry_Time, Notes)
VALUES (seq_donation.NEXTVAL, 1005, 403, 'Biscuit Packets', 50, 'packets', SYSTIMESTAMP + INTERVAL '72' HOUR,'Near expiry, still good');

INSERT INTO Food_Donation (Donation_ID, Donor_ID, Category_ID, Food_Type, Quantity, Unit, Expiry_Time, Notes)
VALUES (seq_donation.NEXTVAL, 1001, 401, 'Chole Bhature',12, 'kg',SYSTIMESTAMP + INTERVAL '5' HOUR,  'Morning batch');

-- Donation that is already Requested (status will be updated below)
INSERT INTO Food_Donation (Donation_ID, Donor_ID, Category_ID, Food_Type, Quantity, Unit, Expiry_Time, Notes)
VALUES (seq_donation.NEXTVAL, 1002, 404, 'Bread Loaves',25, 'packets',SYSTIMESTAMP + INTERVAL '12' HOUR, 'Day-old bread');

-- Collected donation (completed)
INSERT INTO Food_Donation (Donation_ID, Donor_ID, Category_ID, Food_Type, Quantity, Unit, Expiry_Time, Status, Notes)
VALUES (seq_donation.NEXTVAL, 1003, 401, 'Khichdi',18, 'kg',SYSTIMESTAMP + INTERVAL '2' HOUR,  'Collected', 'Already collected');

--Donation Requests
-- Approved request for Bread Loaves
INSERT INTO Donation_Request (Request_ID, Donation_ID, NGO_ID, Status)
VALUES (seq_request.NEXTVAL, 5007, 2001, 'Approved');

UPDATE Food_Donation SET Status = 'Requested' WHERE Donation_ID = 5007;

-- Pending request
INSERT INTO Donation_Request (Request_ID, Donation_ID, NGO_ID, Status)
VALUES (seq_request.NEXTVAL, 5003, 2002, 'Pending');

-- Completed request(for Khichdi)
INSERT INTO Donation_Request (Request_ID, Donation_ID, NGO_ID, Status)
VALUES (seq_request.NEXTVAL, 5008, 2003, 'Completed');

--Pickup
-- Scheduled pickup for approved request
INSERT INTO Pickup (Pickup_ID, Request_ID, Volunteer_ID, Pickup_Date, Status)
VALUES (seq_pickup.NEXTVAL, 6001, 3001, SYSDATE + 1, 'Scheduled');

UPDATE Volunteer SET Availability = 'Busy' WHERE Volunteer_ID = 3001;
UPDATE Food_Donation SET Status = 'Assigned' WHERE Donation_ID = 5007;

-- Completed pickup for Khichdi
INSERT INTO Pickup (Pickup_ID, Request_ID, Volunteer_ID, Pickup_Date, Actual_Pickup, Status)
VALUES (seq_pickup.NEXTVAL, 6003, 3002, SYSDATE - 1, SYSTIMESTAMP - INTERVAL '20' HOUR, 'Completed');

COMMIT;

--To Verify data
SELECT 'Admin' AS TableName, COUNT(*) AS Total_Rows FROM Admin UNION ALL
SELECT 'Food_Category', COUNT(*) FROM Food_Category UNION ALL
SELECT 'Donor',  COUNT(*) FROM Donor UNION ALL
SELECT 'NGO',   COUNT(*) FROM NGO UNION ALL
SELECT 'Volunteer', COUNT(*) FROM Volunteer UNION ALL
SELECT 'Food_Donation', COUNT(*) FROM Food_Donation UNION ALL
SELECT 'Donation_Request', COUNT(*) FROM Donation_Request UNION ALL
SELECT 'Pickup', COUNT(*) FROM Pickup;