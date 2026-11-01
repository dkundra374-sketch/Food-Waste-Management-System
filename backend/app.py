import os
import sqlite3
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
# Enable CORS so frontend/index.html can communicate with this API
CORS(app)

DB_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "foodwaste.db")

def get_db_connection():
    """Establishes connection to the local SQLite database."""
    conn = sqlite3.connect(DB_PATH)
    # Enable dict-like row access (access columns by name)
    conn.row_factory = sqlite3.Row
    return conn

# -------------------------------------------------------------
# 1. GET /api/dashboard
# Fetches metrics and active donations for the dashboard UI
# -------------------------------------------------------------
@app.route("/api/dashboard", methods=["GET"])
def get_dashboard_data():
    conn = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        # 1. Total available donations
        cur.execute("SELECT COUNT(*) FROM Food_Donation WHERE Status = 'Available'")
        available_donations = cur.fetchone()[0]

        # 2. Total active NGOs
        cur.execute("SELECT COUNT(*) FROM NGO WHERE Is_Active = 'Y'")
        active_ngos = cur.fetchone()[0]

        # 3. Available volunteers
        cur.execute("SELECT COUNT(*) FROM Volunteer WHERE Availability = 'Available'")
        available_volunteers = cur.fetchone()[0]

        # 4. Completed pickups
        cur.execute("SELECT COUNT(*) FROM Pickup WHERE Status = 'Completed'")
        completed_pickups = cur.fetchone()[0]

        # 5. Join Food_Donation and Donor to list recent donations
        cur.execute("""
            SELECT 
                F.Donation_ID AS donation_id,
                F.Food_Type AS food_type,
                D.Name AS donor_name,
                F.Quantity AS quantity,
                F.Unit AS unit,
                F.Status AS status
            FROM Food_Donation F
            LEFT JOIN Donor D ON F.Donor_ID = D.Donor_ID
            ORDER BY F.Donation_ID DESC
        """)
        
        donations = [dict(row) for row in cur.fetchall()]

        return jsonify({
            "stats": {
                "active_donations": available_donations,
                "ngos": active_ngos,
                "volunteers": available_volunteers,
                "completed_pickups": completed_pickups
            },
            "donations": donations
        }), 200

    except sqlite3.Error as e:
        return jsonify({"error": str(e)}), 500

    finally:
        if conn:
            conn.close()

# -------------------------------------------------------------
# 2. POST /api/donations
# Creates a new food donation record
# -------------------------------------------------------------
@app.route("/api/donations", methods=["POST"])
def add_donation():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Invalid JSON body"}), 400

    required_fields = ["donor_id", "food_type", "quantity"]
    for field in required_fields:
        if field not in data:
            return jsonify({"error": f"Missing required field: {field}"}), 400

    conn = None
    try:
        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("""
            INSERT INTO Food_Donation (Donor_ID, Food_Type, Quantity, Unit, Status)
            VALUES (?, ?, ?, ?, ?)
        """, (
            data.get("donor_id"),
            data.get("food_type"),
            data.get("quantity"),
            data.get("unit", "kg"),
            data.get("status", "Available")
        ))

        conn.commit()
        new_id = cur.lastrowid

        return jsonify({
            "message": "Donation created successfully",
            "donation_id": new_id
        }), 201

    except sqlite3.Error as e:
        if conn:
            conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)