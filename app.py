import io
import os
import json
from datetime import datetime
from typing import Dict, Iterable, List, Optional

import pyodbc  # SQL SERVER CHANGE: dùng pyodbc thay cho sqlite3

from flask import (
    Flask,
    jsonify,
    redirect,
    render_template,
    request,
    send_file,
    session,
    url_for,
)

app = Flask(__name__, template_folder="template")
app.secret_key = "replace_with_a_random_secret_key"

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DEFAULT_EXCEL_PATH = os.path.join(BASE_DIR, "DOCTORSKIN2 data.xlsx")

# SQL SERVER CHANGE: cấu hình kết nối
SQL_SERVER = "admin"
SQL_DATABASE = "DOCTORSKIN2"
SQL_USERNAME = "admin"
SQL_PASSWORD = "admin"
SQL_DRIVER = "ODBC Driver 17 for SQL Server"

EXCEL_TABLE_CONFIG = {
    "Users": ["iduser", "name", "birth", "gender", "phone", "email", "password", "hide", "ava", "total", "point", "dateregist"],
    "UserRoles": ["stt", "email", "rolename"],
    "UserRolesMappings": ["stt", "email", "idrole"],
    "RoleMasters": ["ID", "RollName"],
    "Categories": ["typep", "namec", "hide", "meta", "date_up"],
    "Brands": ["idbrand", "namebrand", "hidebrand", "meta"],
    "Products": ["idp", "namep", "typep", "newprice", "oldprice", "descr", "hide", "statep", "img", "date_up", "idbrand", "metap", "avilability", "rated", "listimg"],
    "Vouchers": ["idvoucher", "namevc", "valuevc", "quantity", "dasudung", "datefrom", "dateto", "hidevc", "stt"],
    "Bills": ["sttbill", "idp", "quantity", "totalbill", "totalmoney", "idbill", "iduser", "note", "status", "yesfb", "datebuy", "idvoucher", "whycancel", "datesuccess", "exception", "address"],
    "Bought": ["iduser", "datebuy", "status", "datestatus", "sttbill", "sttbought", "yesfb"],
    "Carts": ["stt", "iduser", "idp", "quanlity"],
    "Wishlists": ["stt_wl", "iduser", "idp"],
    "Feedbacks": ["sttfb", "idbill", "cmt", "datefb", "hidefb", "iduser", "idp", "star", "imagefb"],
    "RepFeedbacks": ["sttrep", "sttfb", "iduser", "cmt_rep", "date_rep", "hide_rep", "from_rep"],
    "Services": ["name_dt", "desc_dt", "hide_dt", "img_dt", "id_dt", "meta", "slider_dt"],
    "ServicesDetails": ["id_sd", "name_sd", "img_sd", "hide_sd", "price_sd", "id_dt", "desc_de", "amount"],
    "BlogTypes": ["idbt", "namebt", "hide", "meta"],
    "BlogDetails": ["idbt", "title", "shortcontent", "cardimg", "hideblog", "idb", "date_up", "contentblog", "metablog"],
    "Banners": ["stt", "link", "homepage", "servicepage", "blogpage", "productpage"],
    "Medias": ["idmedia", "hrefmedia", "imgmedia", "hidemedia"],
    "Bookings": ["stt", "name", "phone", "email", "require", "timebooking", "completed"],
    "Patients": ["stt", "name", "gender", "age", "phone", "diagnose", "prescription", "pay", "date", "doctor", "date_re"],
    "Doctors": ["stt", "namedoc", "infordoc", "ava_doc", "hide_doc", "date_up_doc", "iddoc"],
    "Medicines": ["id", "name", "price", "uses", "hide"],
    "Forgots": ["stt", "email", "token", "createAt"],
    "Questions": ["stt", "iduser", "question", "rep", "datequestion", "repquestion", "daterep", "iduserrep"],
}


def get_conn() -> pyodbc.Connection:
    # SQL SERVER CHANGE: dùng kết nối SQL Server
    conn_str = (
        f"DRIVER={{{SQL_DRIVER}}};"
        f"SERVER={SQL_SERVER};"
        f"DATABASE={SQL_DATABASE};"
        f"UID={SQL_USERNAME};"
        f"PWD={SQL_PASSWORD};"
        "TrustServerCertificate=yes;"
    )
    return pyodbc.connect(conn_str)


def quote_ident(name: str) -> str:
    return f"[{name}]"


def rows_to_dicts(cursor, rows):
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in rows]


def import_excel_to_db(file_path: Optional[str] = None, file_storage=None) -> Dict[str, int]:
    try:
        import pandas as pd
    except ImportError as exc:
        raise RuntimeError(
            "Thiếu pandas/openpyxl. Cài bằng: pip install pandas openpyxl"
        ) from exc

    source = None
    if file_storage is not None:
        source = file_storage.stream
    elif file_path:
        source = file_path

    if source is None:
        raise ValueError("Chưa truyền file Excel")

    excel = pd.ExcelFile(source)
    conn = get_conn()
    results: Dict[str, int] = {}
    try:
        cursor = conn.cursor()
        cursor.fast_executemany = True
        for sheet, columns in EXCEL_TABLE_CONFIG.items():
            if sheet not in excel.sheet_names:
                continue
            df = excel.parse(sheet)
            df = df.where(pd.notnull(df), None)
            for col in columns:
                if col not in df.columns:
                    df[col] = None
            df = df[columns]

            table = quote_ident(sheet)
            cursor.execute(f"DELETE FROM {table}")

            col_list = ", ".join(quote_ident(c) for c in columns)
            placeholders = ", ".join(["?"] * len(columns))
            insert_sql = f"INSERT INTO {table} ({col_list}) VALUES ({placeholders})"
            cursor.executemany(insert_sql, df.values.tolist())
            results[sheet] = len(df)
        conn.commit()
    finally:
        conn.close()
    return results


def export_db_to_excel() -> io.BytesIO:
    try:
        import pandas as pd
    except ImportError as exc:
        raise RuntimeError(
            "Thiếu pandas/openpyxl. Cài bằng: pip install pandas openpyxl"
        ) from exc

    output = io.BytesIO()
    conn = get_conn()
    try:
        with pd.ExcelWriter(output, engine="openpyxl") as writer:
            for sheet, columns in EXCEL_TABLE_CONFIG.items():
                col_list = ", ".join(quote_ident(c) for c in columns)
                df = pd.read_sql_query(
                    f"SELECT {col_list} FROM {quote_ident(sheet)}", conn
                )
                df.to_excel(writer, sheet_name=sheet, index=False)
    finally:
        conn.close()
    output.seek(0)
    return output


def _parse_date(value: Optional[str]) -> Optional[datetime]:
    if value is None:
        return None
    if isinstance(value, datetime):
        return value
    for fmt in (
        "%Y-%m-%d %H:%M:%S",
        "%Y-%m-%d",
        "%d/%m/%Y",
        "%Y-%m-%d %H:%M:%S.%f",
    ):
        try:
            return datetime.strptime(str(value), fmt)
        except ValueError:
            continue
    return None


def _month_key(dt: datetime) -> str:
    return dt.strftime("%Y-%m")


def _last_month_labels(end_date: datetime, months: int = 6) -> List[str]:
    labels = []
    year = end_date.year
    month = end_date.month
    for _ in range(months):
        labels.append(f"{year:04d}-{month:02d}")
        month -= 1
        if month == 0:
            month = 12
            year -= 1
    labels.reverse()
    return labels


def _bucket_counts(date_values: Iterable[Optional[str]], labels: List[str]) -> List[int]:
    counts = {label: 0 for label in labels}
    for value in date_values:
        dt = _parse_date(value)
        if not dt:
            continue
        key = _month_key(dt)
        if key in counts:
            counts[key] += 1
    return [counts[label] for label in labels]


@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        conn = get_conn()
        try:
            cursor = conn.cursor()
            cursor.execute(
                "SELECT iduser, name, [password] FROM Users WHERE email = ?", (email,)
            )
            user = cursor.fetchone()
            if user and user[2] == password:
                cursor.execute(
                    "SELECT rolename FROM UserRoles WHERE email = ?", (email,)
                )
                role_row = cursor.fetchone()
                role = role_row[0] if role_row else "user"
                session["user"] = user[1]
                session["role"] = role
                return redirect(url_for("dashboard"))
            return render_template("login.html", error="Tài khoản hoặc mật khẩu không đúng")
        finally:
            conn.close()
    return render_template("login.html")


@app.route("/logout")
def logout():
    session.pop("user", None)
    session.pop("role", None)
    return redirect(url_for("login"))


@app.route("/dashboard")
def dashboard():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT timebooking FROM Bookings")
        bookings_dates = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT datebuy FROM Bills")
        bills_dates = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT dateregist FROM Users")
        users_dates = [row[0] for row in cursor.fetchall()]
        cursor.execute("SELECT date FROM Patients")
        patients_dates = [row[0] for row in cursor.fetchall()]

        parsed_dates = [
            dt
            for dt in (
                *[_parse_date(v) for v in bookings_dates],
                *[_parse_date(v) for v in bills_dates],
                *[_parse_date(v) for v in users_dates],
                *[_parse_date(v) for v in patients_dates],
            )
            if dt
        ]
        end_date = max(parsed_dates) if parsed_dates else datetime.now()
        labels = _last_month_labels(end_date, months=6)
        series = {
            "Bookings": _bucket_counts(bookings_dates, labels),
            "Bills": _bucket_counts(bills_dates, labels),
            "Users": _bucket_counts(users_dates, labels),
            "Patients": _bucket_counts(patients_dates, labels),
        }
    finally:
        conn.close()
    return render_template(
        "dashboard.html",
        chart_labels=json.dumps(labels),
        chart_series=json.dumps(series),
    )


@app.route("/schedule")
def schedule():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        cursor = conn.cursor()
        cursor.execute(
            "SELECT stt, name, phone, email, require, timebooking FROM Bookings ORDER BY timebooking"
        )
        rows = rows_to_dicts(cursor, cursor.fetchall())
    finally:
        conn.close()
    return render_template("schedule.html", bookings=rows)


@app.route("/booking", methods=["GET", "POST"])
def booking():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        cursor = conn.cursor()
        if request.method == "POST":
            name = request.form["name"]
            phone = request.form["phone"]
            email = request.form.get("email")
            req = request.form["request"]
            date = request.form["date"]
            cursor.execute(
                "INSERT INTO Bookings (name, phone, email, require, timebooking, completed) VALUES (?, ?, ?, ?, ?, 0)",
                (name, phone, email, req, date),
            )
            conn.commit()
            return redirect(url_for("booking"))
        cursor.execute(
            "SELECT stt, name, phone, email, require, timebooking FROM Bookings ORDER BY timebooking"
        )
        rows = rows_to_dicts(cursor, cursor.fetchall())
    finally:
        conn.close()
    return render_template("booking.html", bookings=rows)


@app.route("/products")
def products():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        cursor = conn.cursor()
        cursor.execute(
            """
            SELECT p.idp, p.namep, c.namec, b.namebrand, p.newprice, p.oldprice, p.descr
            FROM Products p
            LEFT JOIN Categories c ON p.typep = c.typep
            LEFT JOIN Brands b ON p.idbrand = b.idbrand
            ORDER BY p.idp
            """
        )
        rows = rows_to_dicts(cursor, cursor.fetchall())
    finally:
        conn.close()
    return render_template("products.html", products=rows)


@app.route("/services")
def services():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        cursor = conn.cursor()
        cursor.execute(
            """
            SELECT s.id_dt, s.name_dt, s.desc_dt, d.name_sd, d.price_sd
            FROM Services s
            LEFT JOIN ServicesDetails d ON s.id_dt = d.id_dt
            ORDER BY s.id_dt
            """
        )
        rows = rows_to_dicts(cursor, cursor.fetchall())
    finally:
        conn.close()
    return render_template("services.html", services=rows)


@app.route("/admin/users")
def admin_users():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        cursor = conn.cursor()
        cursor.execute(
            "SELECT iduser, name, birth, gender, phone, email, total, point, dateregist FROM Users"
        )
        rows = rows_to_dicts(cursor, cursor.fetchall())
    finally:
        conn.close()
    return render_template("admin_users.html", users=rows)


@app.route("/admin/doctors")
def admin_doctors():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        cursor = conn.cursor()
        cursor.execute(
            """
            SELECT u.iduser, u.name, u.gender, u.phone, u.email, d.infordoc
            FROM Users u
            JOIN UserRoles r ON r.email = u.email
            LEFT JOIN Doctors d ON d.iddoc = u.iduser
            WHERE LOWER(r.rolename) = 'doctor'
            """
        )
        rows = rows_to_dicts(cursor, cursor.fetchall())
    finally:
        conn.close()
    return render_template("admin_doctors.html", doctors=rows)


@app.route("/admin/nurses")
def admin_nurses():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        cursor = conn.cursor()
        cursor.execute(
            """
            SELECT u.iduser, u.name, u.gender, u.phone, u.email
            FROM Users u
            JOIN UserRoles r ON r.email = u.email
            WHERE LOWER(r.rolename) = 'nurse'
            """
        )
        rows = rows_to_dicts(cursor, cursor.fetchall())
    finally:
        conn.close()
    return render_template("admin_nurses.html", nurses=rows)


@app.route("/admin/schedule")
def admin_schedule():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        cursor = conn.cursor()
        cursor.execute(
            "SELECT stt, name, phone, email, require, timebooking FROM Bookings ORDER BY timebooking"
        )
        rows = rows_to_dicts(cursor, cursor.fetchall())
    finally:
        conn.close()
    return render_template("admin_schedule.html", bookings=rows)


@app.route("/admin/bills")
def admin_bills():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        cursor = conn.cursor()
        cursor.execute(
            """
            SELECT b.sttbill, u.name AS customer_name, u.email, p.namep AS product_name,
                   b.totalmoney, b.status, b.datebuy, b.idvoucher, b.address, b.note
            FROM Bills b
            LEFT JOIN Users u ON b.iduser = u.iduser
            LEFT JOIN Products p ON b.idp = p.idp
            ORDER BY b.sttbill
            """
        )
        rows = rows_to_dicts(cursor, cursor.fetchall())
    finally:
        conn.close()
    return render_template("admin_bills.html", bills=rows)


@app.route("/admin/import_excel", methods=["POST"])
def admin_import_excel():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    file = request.files.get("file")
    file_path = request.form.get("path") or (
        DEFAULT_EXCEL_PATH if os.path.exists(DEFAULT_EXCEL_PATH) else None
    )
    try:
        results = import_excel_to_db(file_path=file_path, file_storage=file)
    except Exception as exc:
        return jsonify({"status": "error", "message": str(exc)}), 400
    return jsonify({"status": "ok", "imported": results})


@app.route("/admin/export_excel", methods=["GET"])
def admin_export_excel():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    try:
        output = export_db_to_excel()
    except Exception as exc:
        return jsonify({"status": "error", "message": str(exc)}), 400
    return send_file(
        output,
        as_attachment=True,
        download_name="clinic_export.xlsx",
        mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    )


if __name__ == "__main__":
    app.run(debug=True)
