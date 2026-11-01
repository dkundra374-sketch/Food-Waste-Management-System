import sqlite3

conn = sqlite3.connect("foodwaste.db")
cur = conn.cursor()

# 1. Create Tables
cur.executescript("""
CREATE TABLE IF NOT EXISTS Donor (
    Donor_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Contact TEXT NOT NULL,
    Email TEXT UNIQUE,
    Address TEXT,
    Type TEXT
);

CREATE TABLE IF NOT EXISTS NGO (
    NGO_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Contact TEXT NOT NULL,
    Email TEXT UNIQUE,
    Location TEXT,
    License_No TEXT UNIQUE,
    Is_Active TEXT DEFAULT 'Y'
);

CREATE TABLE IF NOT EXISTS Volunteer (
    Volunteer_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL,
    Contact TEXT NOT NULL,
    Email TEXT UNIQUE,
    Area_Covered TEXT,
    Availability TEXT DEFAULT 'Available'
);

CREATE TABLE IF NOT EXISTS Food_Donation (
    Donation_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Donor_ID INTEGER,
    Food_Type TEXT NOT NULL,
    Quantity REAL NOT NULL,
    Unit TEXT DEFAULT 'kg',
    Status TEXT DEFAULT 'Available',
    FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID)
);

CREATE TABLE IF NOT EXISTS Pickup (
    Pickup_ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Volunteer_ID INTEGER,
    Status TEXT DEFAULT 'Scheduled',
    FOREIGN KEY (Volunteer_ID) REFERENCES Volunteer(Volunteer_ID)
);
""")

# 2. Insert Seed Data
cur.executescript("""
INSERT OR IGNORE INTO Donor (Donor_ID, Name, Contact, Email, Address, Type) VALUES
(1001, 'Punjabi Dhaba Patiala', '9876543210', 'dhaba@gmail.com', 'Rajpura Road, Patiala', 'Restaurant'),
(1002, 'TIET Hostel Mess', '9988776655', 'mess@thapar.edu', 'TIET Campus, Patiala', 'Hostel');

INSERT OR IGNORE INTO NGO (NGO_ID, Name, Contact, Email, Location, License_No) VALUES
(2001, 'Roti Bank Patiala', '9111222333', 'rotibank@ngo.org', 'Sadar Bazar, Patiala', 'NGO-PB-2021-001'),
(2002, 'Hunger Free Punjab', '9222333444', 'hfp@welfare.org', 'Civil Lines, Patiala', 'NGO-PB-2020-045');

INSERT OR IGNORE INTO Volunteer (Volunteer_ID, Name, Contact, Email, Area_Covered, Availability) VALUES
(3001, 'Arjun Singh', '9444555666', 'arjun@vol.com', 'Rajpura Road, Patiala', 'Busy'),
(3002, 'Priya Sharma', '9555666777', 'priya@vol.com', 'Model Town, Patiala', 'Available');

INSERT OR IGNORE INTO Food_Donation (Donation_ID, Donor_ID, Food_Type, Quantity, Unit, Status) VALUES
(5001, 1001, 'Dal Makhani + Rice', 15, 'kg', 'Available'),
(5002, 1002, 'Rajma Chawal', 30, 'kg', 'Available'),
(5003, 1001, 'Paneer Butter Masala', 20, 'kg', 'Available');
""")

conn.commit()
conn.close()
print("SQLite Database created successfully with seed data!")