from flask import Flask, render_template, jsonify, request
import mysql.connector
from mysql.connector import Error
from datetime import date, datetime

app = Flask(__name__)

# Keep the existing local MySQL application connection settings.
DB_CONFIG = {
    "host": "localhost",
    "user": "vertigrow_app",
    "password": "db123@SQL",
    "database": "VERTIGROW_DB"
}

# Only these predefined tables and columns can be accessed by the CRUD API.
TABLES = {
    "farms": {"table": "farm", "pk": "farm_id", "fields": ["farm_name", "location", "total_area"]},
    "sections": {"table": "section", "pk": "section_id", "fields": ["section_name", "floor_level", "farm_id"]},
    "crops": {"table": "crop", "pk": "crop_id", "fields": ["crop_name", "growth_cycle_days", "optimal_temp"]},
    "employees": {"table": "employee", "pk": "employee_id", "fields": ["name", "role", "contact"]},
    "equipment": {"table": "equipment", "pk": "equipment_id", "fields": ["equipment_name", "section_id", "status"]},
    "harvests": {"table": "harvest", "pk": "harvest_id", "fields": ["section_id", "crop_id", "harvest_date", "quantity_kg"]},
    "customers": {"table": "customer", "pk": "customer_id", "fields": ["customer_name", "contact", "email"]},
    "orders": {"table": "orders", "pk": "order_id", "fields": ["customer_id", "order_date", "total_amount"]}
}


def db_connection():
    return mysql.connector.connect(**DB_CONFIG)


def fetch_all(query, params=()):
    conn = db_connection()
    cur = conn.cursor(dictionary=True)
    try:
        cur.execute(query, params)
        rows = cur.fetchall()
        for row in rows:
            for key, value in row.items():
                if isinstance(value, (date, datetime)):
                    row[key] = value.isoformat()
        return rows
    finally:
        cur.close()
        conn.close()


def clean_payload(resource, data):
    fields = TABLES[resource]["fields"]
    values = {}
    for field in fields:
        value = data.get(field)
        if value is None or str(value).strip() == "":
            raise ValueError(f"{field.replace('_', ' ').capitalize()} is required.")
        if field in ("total_area", "optimal_temp", "quantity_kg", "total_amount"):
            value = float(value)
            if value <= 0 and field != "optimal_temp":
                raise ValueError(f"{field.replace('_', ' ').capitalize()} must be greater than zero.")
        elif field in ("growth_cycle_days", "floor_level", "farm_id", "section_id", "crop_id", "customer_id"):
            value = int(value)
            if value <= 0:
                raise ValueError(f"{field.replace('_', ' ').capitalize()} must be greater than zero.")
        else:
            value = str(value).strip()
        values[field] = value
    if resource == "equipment" and values["status"] not in ("Active", "Maintenance", "Inactive"):
        raise ValueError("Choose Active, Maintenance or Inactive for equipment status.")
    return values


@app.route("/")
def dashboard():
    return render_template("index.html")


@app.route("/api/stats")
def stats():
    conn = db_connection()
    cur = conn.cursor()
    try:
        result = {}
        for resource, config in TABLES.items():
            cur.execute(f"SELECT COUNT(*) FROM `{config['table']}`")
            result[config["table"]] = cur.fetchone()[0]
        return jsonify(result)
    finally:
        cur.close()
        conn.close()


# Read the harvest summary view for reports and dashboard previews.
@app.route("/api/harvest-summary")
def harvest_summary():
    try:
        return jsonify(fetch_all("SELECT * FROM harvest_summary ORDER BY harvest_date DESC, harvest_id DESC"))
    except Error as error:
        return jsonify({"error": str(error)}), 500


# Generic read endpoint for each whitelisted base table.
@app.route("/api/<resource>", methods=["GET", "POST"])
def collection_api(resource):
    if resource not in TABLES:
        return jsonify({"error": "Unknown resource."}), 404
    config = TABLES[resource]
    table, pk, fields = config["table"], config["pk"], config["fields"]
    if request.method == "GET":
        try:
            if resource == "sections":
                rows = fetch_all("SELECT s.section_id, s.section_name, s.floor_level, s.farm_id, f.farm_name FROM section s JOIN farm f ON f.farm_id=s.farm_id ORDER BY s.section_id")
            elif resource == "equipment":
                rows = fetch_all("SELECT e.equipment_id, e.equipment_name, e.section_id, s.section_name, e.status FROM equipment e JOIN section s ON s.section_id=e.section_id ORDER BY e.equipment_id")
            elif resource == "harvests":
                rows = fetch_all("SELECT h.harvest_id, h.section_id, h.crop_id, h.harvest_date, h.quantity_kg, s.section_name, c.crop_name FROM harvest h JOIN section s ON s.section_id=h.section_id JOIN crop c ON c.crop_id=h.crop_id ORDER BY h.harvest_date DESC, h.harvest_id DESC")
            elif resource == "orders":
                rows = fetch_all("SELECT o.order_id, o.customer_id, c.customer_name, o.order_date, o.total_amount FROM orders o JOIN customer c ON c.customer_id=o.customer_id ORDER BY o.order_id DESC")
            else:
                rows = fetch_all(f"SELECT * FROM `{table}` ORDER BY `{pk}` DESC")
            return jsonify(rows)
        except Error as error:
            return jsonify({"error": str(error)}), 500
    return create_record(resource, config)


def create_record(resource, config):
    try:
        values = clean_payload(resource, request.get_json(silent=True) or {})
        fields = config["fields"]
        columns = ", ".join(f"`{field}`" for field in fields)
        placeholders = ", ".join(["%s"] * len(fields))
        conn = db_connection(); cur = conn.cursor()
        try:
            cur.execute(f"INSERT INTO `{config['table']}` ({columns}) VALUES ({placeholders})", tuple(values[f] for f in fields))
            conn.commit()
            return jsonify({"message": f"{config['table'].capitalize()} record added successfully.", "id": cur.lastrowid}), 201
        except Exception:
            conn.rollback(); raise
        finally:
            cur.close(); conn.close()
    except ValueError as error:
        return jsonify({"error": str(error)}), 400
    except Error as error:
        return jsonify({"error": friendly_db_error(error)}), 409 if getattr(error, "errno", None) in (1062, 1452, 3819) else 500


@app.route("/api/<resource>/<int:record_id>", methods=["PUT", "DELETE"])
def record_api(resource, record_id):
    if resource not in TABLES:
        return jsonify({"error": "Unknown resource."}), 404
    config = TABLES[resource]
    conn = None; cur = None
    try:
        conn = db_connection(); cur = conn.cursor()
        if request.method == "DELETE":
            cur.execute(f"DELETE FROM `{config['table']}` WHERE `{config['pk']}`=%s", (record_id,))
            if cur.rowcount == 0:
                conn.rollback(); return jsonify({"error": "Record not found."}), 404
            conn.commit()
            return jsonify({"message": f"{config['table'].capitalize()} record deleted successfully."})
        values = clean_payload(resource, request.get_json(silent=True) or {})
        assignments = ", ".join(f"`{field}`=%s" for field in config["fields"])
        params = tuple(values[field] for field in config["fields"]) + (record_id,)
        cur.execute(f"UPDATE `{config['table']}` SET {assignments} WHERE `{config['pk']}`=%s", params)
        if cur.rowcount == 0:
            check = conn.cursor(); check.execute(f"SELECT 1 FROM `{config['table']}` WHERE `{config['pk']}`=%s", (record_id,)); exists = check.fetchone(); check.close()
            if not exists:
                conn.rollback(); return jsonify({"error": "Record not found."}), 404
        conn.commit()
        return jsonify({"message": f"{config['table'].capitalize()} record updated successfully."})
    except ValueError as error:
        if conn and conn.is_connected(): conn.rollback()
        return jsonify({"error": str(error)}), 400
    except Error as error:
        if conn and conn.is_connected(): conn.rollback()
        return jsonify({"error": friendly_db_error(error)}), 409 if getattr(error, "errno", None) in (1062, 1451, 1452, 3819) else 500
    finally:
        if cur: cur.close()
        if conn and conn.is_connected(): conn.close()


def friendly_db_error(error):
    code = getattr(error, "errno", None)
    if code == 1451:
        return "This record is referenced by another table. Reassign or remove the linked records first."
    if code == 1452:
        return "The selected related record does not exist. Refresh the page and choose a valid option."
    if code == 1062:
        return "A record with this unique value already exists. Check contact or email details."
    if code == 3819:
        return "The values do not satisfy a database constraint. Check the entered values."
    return str(error)


if __name__ == "__main__":
    app.run(debug=True)
