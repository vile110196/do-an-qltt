import io
import os
import sqlite3
import json
from datetime import datetime
from typing import Dict, Iterable, List, Optional

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
DB_PATH = os.path.join(BASE_DIR, "clinic.db")
DEFAULT_EXCEL_PATH = os.path.join(BASE_DIR, "DOCTORSKIN2 data.xlsx")

STATUS_LABELS = {
    "pending": "Chờ thanh toán",
    "paid": "Đã thanh toán",
    "cancelled": "Đã hủy",
    "Chờ thanh toán": "Chờ thanh toán",
    "Đã thanh toán": "Đã thanh toán",
    "Đã hủy": "Đã hủy",
}

SCHEMA_DEFINITIONS: Dict[str, Dict[str, str]] = {
    "users": {
        "iduser": "TEXT PRIMARY KEY",
        "name": "TEXT",
        "birth": "TEXT",
        "gender": "TEXT",
        "address": "TEXT",
        "phone": "TEXT",
        "email": "TEXT",
        "pass": "TEXT",
        "point": "INTEGER",
        "dateregist": "TEXT",
    },
    "user_roles": {
        "stt": "INTEGER PRIMARY KEY AUTOINCREMENT",
        "email": "TEXT",
        "idrole": "INTEGER",
        "rolename": "TEXT",
    },
    "user_roles_mappings": {
        "stt": "INTEGER PRIMARY KEY AUTOINCREMENT",
        "email": "TEXT",
        "idrole": "INTEGER",
    },
    "role_masters": {
        "id": "INTEGER PRIMARY KEY",
        "rollname": "TEXT",
    },
    "categories": {
        "typep": "INTEGER PRIMARY KEY",
        "namec": "TEXT",
        "meta": "TEXT",
        "hide": "INTEGER",
    },
    "brands": {
        "idbrand": "INTEGER PRIMARY KEY",
        "namebrand": "TEXT",
        "hide": "INTEGER",
    },
    "products": {
        "idp": "INTEGER PRIMARY KEY",
        "namep": "TEXT",
        "newprice": "TEXT",
        "oldprice": "TEXT",
        "descr": "TEXT",
        "typep": "INTEGER",
        "idbrand": "INTEGER",
        "img": "TEXT",
        "hide": "INTEGER",
    },
    "vouchers": {
        "stt": "INTEGER PRIMARY KEY",
        "idvoucher": "TEXT",
        "namevc": "TEXT",
        "valuevc": "INTEGER",
        "quantity": "INTEGER",
        "hide": "INTEGER",
    },
    "campaigns": {
        "id_campaign": "INTEGER PRIMARY KEY",
        "name": "TEXT",
        "description": "TEXT",
        "start_date": "TEXT",
        "end_date": "TEXT",
        "status": "TEXT",
    },
    "campaign_vouchers": {
        "id": "INTEGER PRIMARY KEY AUTOINCREMENT",
        "campaign_id": "INTEGER",
        "voucher_id": "TEXT",
    },
    "bills": {
        "sttbill": "INTEGER PRIMARY KEY",
        "iduser": "TEXT",
        "idp": "INTEGER",
        "totalmoney": "TEXT",
        "status": "TEXT",
        "datebuy": "TEXT",
        "idvoucher": "TEXT",
    },
    "bought": {
        "stt": "INTEGER PRIMARY KEY",
        "iduser": "TEXT",
        "idp": "INTEGER",
    },
    "carts": {
        "stt": "INTEGER PRIMARY KEY",
        "iduser": "TEXT",
        "idp": "INTEGER",
        "quanlity": "INTEGER",
    },
    "wishlists": {
        "stt": "INTEGER PRIMARY KEY",
        "iduser": "TEXT",
        "idp": "INTEGER",
    },
    "feedbacks": {
        "sttfb": "INTEGER PRIMARY KEY",
        "iduser": "TEXT",
        "idp": "INTEGER",
        "cmt": "TEXT",
        "star": "INTEGER",
        "img": "TEXT",
        "datefb": "TEXT",
    },
    "rep_feedbacks": {
        "stt": "INTEGER PRIMARY KEY",
        "sttfb": "INTEGER",
        "contentrep": "TEXT",
        "daterep": "TEXT",
    },
    "services": {
        "id_dt": "INTEGER PRIMARY KEY",
        "name_dt": "TEXT",
        "desc_dt": "TEXT",
        "img_dt": "TEXT",
    },
    "services_details": {
        "id_sd": "INTEGER PRIMARY KEY",
        "id_dt": "INTEGER",
        "name_sd": "TEXT",
        "price_sd": "TEXT",
    },
    "blog_types": {
        "idbt": "INTEGER PRIMARY KEY",
        "namebt": "TEXT",
    },
    "blog_details": {
        "idb": "INTEGER PRIMARY KEY",
        "idbt": "INTEGER",
        "title": "TEXT",
        "contentblog": "TEXT",
        "meta": "TEXT",
        "img": "TEXT",
        "hide": "INTEGER",
    },
    "banners": {
        "stt": "INTEGER PRIMARY KEY",
        "link": "TEXT",
        "homepage": "INTEGER",
        "servicepage": "INTEGER",
        "blogpage": "INTEGER",
        "productpage": "INTEGER",
    },
    "medias": {
        "stt": "INTEGER PRIMARY KEY",
        "link": "TEXT",
    },
    "bookings": {
        "stt": "INTEGER PRIMARY KEY",
        "name": "TEXT",
        "phone": "TEXT",
        "timebooking": "TEXT",
        "require": "TEXT",
    },
    "patients": {
        "stt": "INTEGER PRIMARY KEY",
        "name": "TEXT",
        "phone": "TEXT",
        "address": "TEXT",
        "diagnose": "TEXT",
        "prescription": "TEXT",
        "doctor": "TEXT",
        "date": "TEXT",
        "date_re": "TEXT",
    },
    "doctors": {
        "stt": "INTEGER PRIMARY KEY",
        "namedoc": "TEXT",
        "iddoc": "TEXT",
        "infordoc": "TEXT",
    },
    "medicines": {
        "id": "INTEGER PRIMARY KEY",
        "name": "TEXT",
        "price": "TEXT",
        "uses": "TEXT",
        "hide": "INTEGER",
    },
    "forgots": {
        "stt": "INTEGER PRIMARY KEY",
        "email": "TEXT",
        "token": "TEXT",
        "time": "TEXT",
    },
    "questions": {
        "stt": "INTEGER PRIMARY KEY",
        "iduser": "TEXT",
        "question": "TEXT",
        "repquestion": "TEXT",
    },
}

EXCEL_TABLE_CONFIG: Dict[str, Dict[str, object]] = {
    "Users": {
        "table": "users",
        "columns": [
            "iduser",
            "name",
            "birth",
            "gender",
            "address",
            "phone",
            "email",
            "pass",
            "point",
            "dateregist",
        ],
    },
    "UserRoles": {
        "table": "user_roles",
        "columns": ["stt", "email", "idrole", "rolename"],
    },
    "UserRolesMappings": {
        "table": "user_roles_mappings",
        "columns": ["stt", "email", "idrole"],
    },
    "RoleMasters": {
        "table": "role_masters",
        "columns": ["id", "rollname"],
    },
    "Categories": {
        "table": "categories",
        "columns": ["typep", "namec", "meta", "hide"],
    },
    "Brands": {
        "table": "brands",
        "columns": ["idbrand", "namebrand", "hide"],
    },
    "Products": {
        "table": "products",
        "columns": [
            "idp",
            "namep",
            "newprice",
            "oldprice",
            "descr",
            "typep",
            "idbrand",
            "img",
            "hide",
        ],
    },
    "Vouchers": {
        "table": "vouchers",
        "columns": ["stt", "idvoucher", "namevc", "valuevc", "quantity", "hide"],
    },
    "Campaigns": {
        "table": "campaigns",
        "columns": ["id_campaign", "name", "description", "start_date", "end_date", "status"],
    },
    "CampaignVouchers": {
        "table": "campaign_vouchers",
        "columns": ["id", "campaign_id", "voucher_id"],
    },
    "Bills": {
        "table": "bills",
        "columns": ["sttbill", "iduser", "idp", "totalmoney", "status", "datebuy", "idvoucher"],
    },
    "Bought": {
        "table": "bought",
        "columns": ["stt", "iduser", "idp"],
    },
    "Carts": {
        "table": "carts",
        "columns": ["stt", "iduser", "idp", "quanlity"],
    },
    "Wishlists": {
        "table": "wishlists",
        "columns": ["stt", "iduser", "idp"],
    },
    "Feedbacks": {
        "table": "feedbacks",
        "columns": ["sttfb", "iduser", "idp", "cmt", "star", "img", "datefb"],
    },
    "RepFeedbacks": {
        "table": "rep_feedbacks",
        "columns": ["stt", "sttfb", "contentrep", "daterep"],
    },
    "Services": {
        "table": "services",
        "columns": ["id_dt", "name_dt", "desc_dt", "img_dt"],
    },
    "ServicesDetails": {
        "table": "services_details",
        "columns": ["id_sd", "id_dt", "name_sd", "price_sd"],
    },
    "BlogTypes": {
        "table": "blog_types",
        "columns": ["idbt", "namebt"],
    },
    "BlogDetails": {
        "table": "blog_details",
        "columns": ["idb", "idbt", "title", "contentblog", "meta", "img", "hide"],
    },
    "Banners": {
        "table": "banners",
        "columns": ["stt", "link", "homepage", "servicepage", "blogpage", "productpage"],
    },
    "Medias": {
        "table": "medias",
        "columns": ["stt", "link"],
    },
    "Bookings": {
        "table": "bookings",
        "columns": ["stt", "name", "phone", "timebooking", "require"],
    },
    "Patients": {
        "table": "patients",
        "columns": ["stt", "name", "phone", "address", "diagnose", "prescription", "doctor", "date", "date_re"],
    },
    "Doctors": {
        "table": "doctors",
        "columns": ["stt", "namedoc", "iddoc", "infordoc"],
    },
    "Medicines": {
        "table": "medicines",
        "columns": ["id", "name", "price", "uses", "hide"],
    },
    "Forgots": {
        "table": "forgots",
        "columns": ["stt", "email", "token", "time"],
    },
    "Questions": {
        "table": "questions",
        "columns": ["stt", "iduser", "question", "repquestion"],
    },
}


def get_conn() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    return conn


def get_table_columns(conn: sqlite3.Connection, table: str) -> List[str]:
    cur = conn.execute(f"PRAGMA table_info({table})")
    return [row["name"] for row in cur.fetchall()]


def ensure_table(conn: sqlite3.Connection, table: str, columns: Dict[str, str]) -> None:
    cur = conn.execute(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?", (table,)
    )
    exists = cur.fetchone()
    if not exists:
        cols_sql = ", ".join([f"{col} {ctype}" for col, ctype in columns.items()])
        conn.execute(f"CREATE TABLE IF NOT EXISTS {table} ({cols_sql})")
        return

    existing_cols = get_table_columns(conn, table)
    for col, ctype in columns.items():
        if col not in existing_cols:
            if "PRIMARY KEY" in ctype.upper():
                continue
            conn.execute(f"ALTER TABLE {table} ADD COLUMN {col} {ctype}")


def create_schema() -> None:
    conn = get_conn()
    try:
        for table, columns in SCHEMA_DEFINITIONS.items():
            ensure_table(conn, table, columns)
        seed_admin(conn)
        seed_campaigns(conn)
    finally:
        conn.commit()
        conn.close()


def seed_admin(conn: sqlite3.Connection) -> None:
    cur = conn.execute("SELECT 1 FROM users WHERE email='admin@clinic.com'")
    if not cur.fetchone():
        conn.execute(
            "INSERT INTO users (iduser, name, birth, gender, address, phone, email, pass, point, dateregist) "
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (
                "admin",
                "Admin",
                "1980-01-01",
                "Male",
                "HCMC",
                "0900000000",
                "admin@clinic.com",
                "admin",
                0,
                datetime.now().strftime("%Y-%m-%d"),
            ),
        )
    cur = conn.execute("SELECT 1 FROM user_roles WHERE email='admin@clinic.com'")
    if not cur.fetchone():
        conn.execute(
            "INSERT INTO user_roles (email, idrole, rolename) VALUES (?, ?, ?)",
            ("admin@clinic.com", 1, "admin"),
        )


def seed_campaigns(conn: sqlite3.Connection) -> None:
    cur = conn.execute("SELECT 1 FROM campaigns LIMIT 1")
    if cur.fetchone():
        return
    campaigns = [
        ("Khuyến mãi mùa hè", "Giảm giá dịch vụ chăm sóc da", "2026-01-01", "2026-03-31", "Đang chạy"),
        ("Tri ân khách hàng", "Tặng voucher cho khách thân thiết", "2026-04-01", "2026-06-30", "Tạm dừng"),
        ("Sự kiện cuối năm", "Ưu đãi combo điều trị", "2026-09-01", "2026-12-31", "Kết thúc"),
    ]
    for campaign in campaigns:
        conn.execute(
            """
            INSERT INTO campaigns (name, description, start_date, end_date, status)
            VALUES (?, ?, ?, ?, ?)
            """,
            campaign,
        )
    voucher_rows = conn.execute(
        "SELECT idvoucher FROM vouchers ORDER BY stt LIMIT 3"
    ).fetchall()
    if voucher_rows:
        campaign_ids = [row["id_campaign"] for row in conn.execute("SELECT id_campaign FROM campaigns").fetchall()]
        for idx, camp_id in enumerate(campaign_ids):
            for voucher in voucher_rows[: (idx % 3) + 1]:
                conn.execute(
                    "INSERT INTO campaign_vouchers (campaign_id, voucher_id) VALUES (?, ?)",
                    (camp_id, voucher["idvoucher"]),
                )

def status_label(value: Optional[str]) -> str:
    if not value:
        return "Chờ thanh toán"
    return STATUS_LABELS.get(value, value)


def normalize_col(name: str) -> str:
    return "".join(ch for ch in name.lower() if ch.isalnum())


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
        for sheet, cfg in EXCEL_TABLE_CONFIG.items():
            if sheet not in excel.sheet_names:
                continue
            ensure_table(conn, cfg["table"], SCHEMA_DEFINITIONS[cfg["table"]])
            df = excel.parse(sheet)
            df_cols = {normalize_col(col): col for col in df.columns}
            mapped = {}
            for col in cfg["columns"]:
                norm = normalize_col(col)
                src = df_cols.get(norm)
                mapped[col] = df[src] if src else None
            data = pd.DataFrame(mapped)
            conn.execute(f"DELETE FROM {cfg['table']}")
            data.to_sql(cfg["table"], conn, if_exists="append", index=False)
            results[cfg["table"]] = len(data)
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
            for sheet, cfg in EXCEL_TABLE_CONFIG.items():
                cols = cfg["columns"]
                df = pd.read_sql_query(
                    f"SELECT {', '.join(cols)} FROM {cfg['table']}", conn
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


def _parse_money(value: Optional[str]) -> int:
    if value is None:
        return 0
    digits = "".join(ch for ch in str(value) if ch.isdigit())
    return int(digits) if digits else 0


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


create_schema()


@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        conn = get_conn()
        try:
            user = conn.execute(
                "SELECT iduser, name, pass, email FROM users WHERE email=?", (email,)
            ).fetchone()
            if user and user["pass"] == password:
                role_row = conn.execute(
                    "SELECT rolename FROM user_roles WHERE email=?", (email,)
                ).fetchone()
                role = role_row["rolename"] if role_row else "user"
                session["user"] = user["name"]
                session["iduser"] = user["iduser"]
                session["email"] = user["email"]
                session["role"] = role
                return redirect(url_for("dashboard"))
            return render_template("login.html", error="Tài khoản hoặc mật khẩu không đúng")
        finally:
            conn.close()
    return render_template("login.html")


@app.route("/logout")
def logout():
    session.pop("user", None)
    session.pop("iduser", None)
    session.pop("email", None)
    session.pop("role", None)
    return redirect(url_for("login"))


@app.route("/dashboard")
def dashboard():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        bookings_dates = [row[0] for row in conn.execute("SELECT timebooking FROM bookings").fetchall()]
        bills_dates = [row[0] for row in conn.execute("SELECT datebuy FROM bills").fetchall()]
        users_dates = [row[0] for row in conn.execute("SELECT dateregist FROM users").fetchall()]
        patients_dates = [row[0] for row in conn.execute("SELECT date FROM patients").fetchall()]

        top_customer_row = conn.execute(
            """
            SELECT u.name, SUM(CAST(b.totalmoney AS INT)) AS total_spent
            FROM bills b
            JOIN users u ON b.iduser = u.iduser
            WHERE date(b.datebuy) >= date('now','-3 months')
            GROUP BY u.name
            ORDER BY total_spent DESC
            LIMIT 1
            """
        ).fetchone()
        top_customer_name = top_customer_row[0] if top_customer_row else "N/A"
        top_customer_total = top_customer_row[1] if top_customer_row and top_customer_row[1] is not None else 0

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
        top_customer_name=top_customer_name,
        top_customer_total=top_customer_total,
    )


@app.route("/schedule")
def schedule():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    rows = conn.execute(
        "SELECT stt, name, phone, timebooking, require FROM bookings ORDER BY timebooking"
    ).fetchall()
    conn.close()
    return render_template("schedule.html", bookings=[dict(r) for r in rows])


@app.route("/booking", methods=["GET", "POST"])
def booking():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        if request.method == "POST":
            name = request.form["name"]
            phone = request.form["phone"]
            req = request.form["request"]
            date = request.form["date"]
            conn.execute(
                "INSERT INTO bookings (name, phone, timebooking, require) VALUES (?, ?, ?, ?)",
                (name, phone, date, req),
            )
            conn.commit()
            return redirect(url_for("booking"))
        rows = conn.execute(
            "SELECT stt, name, phone, timebooking, require FROM bookings ORDER BY timebooking"
        ).fetchall()
    finally:
        conn.close()
    return render_template("booking.html", bookings=[dict(r) for r in rows])


@app.route("/products")
def products():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    rows = conn.execute(
        """
        SELECT p.idp, p.namep, c.namec, b.namebrand, p.newprice, p.oldprice, p.descr
        FROM products p
        LEFT JOIN categories c ON p.typep = c.typep
        LEFT JOIN brands b ON p.idbrand = b.idbrand
        ORDER BY p.idp
        """
    ).fetchall()
    conn.close()
    return render_template("products.html", products=[dict(r) for r in rows])


@app.route("/services")
def services():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    rows = conn.execute(
        """
        SELECT s.id_dt, s.name_dt, s.desc_dt, d.name_sd, d.price_sd
        FROM services s
        LEFT JOIN services_details d ON s.id_dt = d.id_dt
        ORDER BY s.id_dt
        """
    ).fetchall()
    conn.close()
    return render_template("services.html", services=[dict(r) for r in rows])


@app.route("/admin/users")
def admin_users():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    rows = conn.execute(
        "SELECT iduser, name, birth, gender, address, phone, email, point, dateregist FROM users"
    ).fetchall()
    conn.close()
    return render_template("admin_users.html", users=[dict(r) for r in rows])


@app.route("/admin/doctors")
def admin_doctors():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    rows = conn.execute(
        """
        SELECT u.iduser, u.name, u.gender, u.phone, u.email, d.infordoc
        FROM users u
        JOIN user_roles r ON r.email = u.email
        LEFT JOIN doctors d ON d.iddoc = u.iduser
        WHERE LOWER(r.rolename) = 'doctor'
        """
    ).fetchall()
    conn.close()
    return render_template("admin_doctors.html", doctors=[dict(r) for r in rows])


@app.route("/admin/nurses")
def admin_nurses():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    rows = conn.execute(
        """
        SELECT u.iduser, u.name, u.gender, u.phone, u.email
        FROM users u
        JOIN user_roles r ON r.email = u.email
        WHERE LOWER(r.rolename) = 'nurse'
        """
    ).fetchall()
    conn.close()
    return render_template("admin_nurses.html", nurses=[dict(r) for r in rows])


@app.route("/admin/schedule")
def admin_schedule():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    rows = conn.execute(
        "SELECT stt, name, phone, timebooking, require FROM bookings ORDER BY timebooking"
    ).fetchall()
    conn.close()
    return render_template("admin_schedule.html", bookings=[dict(r) for r in rows])


@app.route("/admin/bills")
def admin_bills():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    rows = conn.execute(
        """
        SELECT b.sttbill, b.iduser, b.idp, u.name AS customer_name, u.email,
               p.namep AS product_name, b.totalmoney, b.status, b.datebuy,
               b.idvoucher, v.namevc AS voucher_name, v.valuevc AS voucher_value
        FROM bills b
        LEFT JOIN users u ON b.iduser = u.iduser
        LEFT JOIN products p ON b.idp = p.idp
        LEFT JOIN vouchers v ON b.idvoucher = v.idvoucher
        ORDER BY b.sttbill
        """
    ).fetchall()
    users = conn.execute("SELECT iduser, name FROM users ORDER BY name").fetchall()
    products = conn.execute("SELECT idp, namep, newprice FROM products ORDER BY idp").fetchall()
    vouchers = conn.execute("SELECT idvoucher, namevc FROM vouchers ORDER BY idvoucher").fetchall()
    conn.close()
    return render_template(
        "admin_bills.html",
        bills=[dict(r) for r in rows],
        users=[dict(r) for r in users],
        products=[dict(r) for r in products],
        vouchers=[dict(r) for r in vouchers],
        status_label=status_label,
    )


@app.route("/admin/bills/add", methods=["POST"])
def admin_bills_add():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    iduser = request.form.get("iduser")
    idp = request.form.get("idp")
    totalmoney = request.form.get("totalmoney") or "0"
    status = request.form.get("status") or "Chờ thanh toán"
    datebuy = request.form.get("datebuy") or datetime.now().strftime("%Y-%m-%d")
    idvoucher = request.form.get("idvoucher") or None
    conn = get_conn()
    try:
        conn.execute(
            """
            INSERT INTO bills (iduser, idp, totalmoney, status, datebuy, idvoucher)
            VALUES (?, ?, ?, ?, ?, ?)
            """,
            (iduser, idp, totalmoney, status, datebuy, idvoucher),
        )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_bills"))


@app.route("/admin/bills/update/<int:sttbill>", methods=["POST"])
def admin_bills_update(sttbill: int):
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    iduser = request.form.get("iduser")
    idp = request.form.get("idp")
    totalmoney = request.form.get("totalmoney") or "0"
    status = request.form.get("status") or "Chờ thanh toán"
    datebuy = request.form.get("datebuy") or datetime.now().strftime("%Y-%m-%d")
    idvoucher = request.form.get("idvoucher") or None
    conn = get_conn()
    try:
        conn.execute(
            """
            UPDATE bills
            SET iduser=?, idp=?, totalmoney=?, status=?, datebuy=?, idvoucher=?
            WHERE sttbill=?
            """,
            (iduser, idp, totalmoney, status, datebuy, idvoucher, sttbill),
        )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_bills"))


@app.route("/admin/bills/delete/<int:sttbill>", methods=["POST"])
def admin_bills_delete(sttbill: int):
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        conn.execute("DELETE FROM bills WHERE sttbill=?", (sttbill,))
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_bills"))


@app.route("/admin/bills/mark_paid/<int:sttbill>", methods=["POST"])
def admin_bills_mark_paid(sttbill: int):
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        conn.execute(
            "UPDATE bills SET status=? WHERE sttbill=?",
            ("Đã thanh toán", sttbill),
        )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_bills"))


@app.route("/admin/vouchers")
def admin_vouchers():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    rows = conn.execute(
        "SELECT stt, idvoucher, namevc, valuevc, quantity, hide FROM vouchers ORDER BY stt"
    ).fetchall()
    conn.close()
    return render_template("admin_vouchers.html", vouchers=[dict(r) for r in rows])


@app.route("/admin/vouchers/add", methods=["POST"])
def admin_vouchers_add():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    idvoucher = request.form.get("idvoucher")
    namevc = request.form.get("namevc")
    valuevc = request.form.get("valuevc") or 0
    quantity = request.form.get("quantity") or 0
    hide = request.form.get("hide") or 0
    conn = get_conn()
    try:
        conn.execute(
            """
            INSERT INTO vouchers (idvoucher, namevc, valuevc, quantity, hide)
            VALUES (?, ?, ?, ?, ?)
            """,
            (idvoucher, namevc, valuevc, quantity, hide),
        )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_vouchers"))


@app.route("/admin/vouchers/update/<int:stt>", methods=["POST"])
def admin_vouchers_update(stt: int):
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    idvoucher = request.form.get("idvoucher")
    namevc = request.form.get("namevc")
    valuevc = request.form.get("valuevc") or 0
    quantity = request.form.get("quantity") or 0
    hide = request.form.get("hide") or 0
    conn = get_conn()
    try:
        conn.execute(
            """
            UPDATE vouchers
            SET idvoucher=?, namevc=?, valuevc=?, quantity=?, hide=?
            WHERE stt=?
            """,
            (idvoucher, namevc, valuevc, quantity, hide, stt),
        )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_vouchers"))


@app.route("/admin/vouchers/delete/<int:stt>", methods=["POST"])
def admin_vouchers_delete(stt: int):
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        conn.execute("DELETE FROM vouchers WHERE stt=?", (stt,))
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_vouchers"))


@app.route("/admin/campaigns")
def admin_campaigns():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    campaigns = conn.execute(
        """
        SELECT c.id_campaign, c.name, c.description, c.start_date, c.end_date, c.status,
               GROUP_CONCAT(cv.voucher_id) AS voucher_ids
        FROM campaigns c
        LEFT JOIN campaign_vouchers cv ON cv.campaign_id = c.id_campaign
        GROUP BY c.id_campaign
        ORDER BY c.id_campaign
        """
    ).fetchall()
    vouchers = conn.execute(
        "SELECT idvoucher, namevc FROM vouchers ORDER BY idvoucher"
    ).fetchall()
    conn.close()
    return render_template(
        "admin_campaigns.html",
        campaigns=[dict(r) for r in campaigns],
        vouchers=[dict(r) for r in vouchers],
    )


@app.route("/admin/campaigns/add", methods=["POST"])
def admin_campaigns_add():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    name = request.form.get("name")
    description = request.form.get("description")
    start_date = request.form.get("start_date")
    end_date = request.form.get("end_date")
    status = request.form.get("status")
    voucher_ids = request.form.getlist("voucher_ids")
    conn = get_conn()
    try:
        cur = conn.execute(
            """
            INSERT INTO campaigns (name, description, start_date, end_date, status)
            VALUES (?, ?, ?, ?, ?)
            """,
            (name, description, start_date, end_date, status),
        )
        campaign_id = cur.lastrowid
        for vid in voucher_ids:
            conn.execute(
                "INSERT INTO campaign_vouchers (campaign_id, voucher_id) VALUES (?, ?)",
                (campaign_id, vid),
            )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_campaigns"))


@app.route("/admin/campaigns/update/<int:campaign_id>", methods=["POST"])
def admin_campaigns_update(campaign_id: int):
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    name = request.form.get("name")
    description = request.form.get("description")
    start_date = request.form.get("start_date")
    end_date = request.form.get("end_date")
    status = request.form.get("status")
    voucher_ids = request.form.getlist("voucher_ids")
    conn = get_conn()
    try:
        conn.execute(
            """
            UPDATE campaigns
            SET name=?, description=?, start_date=?, end_date=?, status=?
            WHERE id_campaign=?
            """,
            (name, description, start_date, end_date, status, campaign_id),
        )
        conn.execute("DELETE FROM campaign_vouchers WHERE campaign_id=?", (campaign_id,))
        for vid in voucher_ids:
            conn.execute(
                "INSERT INTO campaign_vouchers (campaign_id, voucher_id) VALUES (?, ?)",
                (campaign_id, vid),
            )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_campaigns"))


@app.route("/admin/campaigns/delete/<int:campaign_id>", methods=["POST"])
def admin_campaigns_delete(campaign_id: int):
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        conn.execute("DELETE FROM campaign_vouchers WHERE campaign_id=?", (campaign_id,))
        conn.execute("DELETE FROM campaigns WHERE id_campaign=?", (campaign_id,))
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_campaigns"))


@app.route("/admin/carts")
def admin_carts():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    rows = conn.execute(
        """
        SELECT c.stt, c.iduser, u.name AS user_name, c.idp, p.namep AS product_name,
               c.quanlity, p.newprice
        FROM carts c
        LEFT JOIN users u ON c.iduser = u.iduser
        LEFT JOIN products p ON c.idp = p.idp
        ORDER BY c.stt
        """
    ).fetchall()
    users = conn.execute("SELECT iduser, name FROM users ORDER BY name").fetchall()
    products = conn.execute("SELECT idp, namep FROM products ORDER BY idp").fetchall()
    conn.close()
    return render_template(
        "admin_carts.html",
        carts=[dict(r) for r in rows],
        users=[dict(r) for r in users],
        products=[dict(r) for r in products],
    )


@app.route("/admin/carts/add", methods=["POST"])
def admin_carts_add():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    iduser = request.form.get("iduser")
    idp = request.form.get("idp")
    qty = request.form.get("quanlity") or 1
    conn = get_conn()
    try:
        conn.execute(
            "INSERT INTO carts (iduser, idp, quanlity) VALUES (?, ?, ?)",
            (iduser, idp, qty),
        )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_carts"))


@app.route("/admin/carts/update/<int:stt>", methods=["POST"])
def admin_carts_update(stt: int):
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    iduser = request.form.get("iduser")
    idp = request.form.get("idp")
    qty = request.form.get("quanlity") or 1
    conn = get_conn()
    try:
        conn.execute(
            "UPDATE carts SET iduser=?, idp=?, quanlity=? WHERE stt=?",
            (iduser, idp, qty, stt),
        )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_carts"))


@app.route("/admin/carts/delete/<int:stt>", methods=["POST"])
def admin_carts_delete(stt: int):
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        conn.execute("DELETE FROM carts WHERE stt=?", (stt,))
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_carts"))


@app.route("/cart")
def cart():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        rows = conn.execute(
            """
            SELECT c.stt, c.iduser, u.name AS user_name, c.idp, p.namep AS product_name,
                   c.quanlity, p.newprice
            FROM carts c
            LEFT JOIN users u ON c.iduser = u.iduser
            LEFT JOIN products p ON c.idp = p.idp
            WHERE c.iduser=?
            ORDER BY c.stt
            """,
            (session.get("iduser"),),
        ).fetchall()
        vouchers = conn.execute(
            "SELECT idvoucher, namevc, valuevc FROM vouchers WHERE hide=0 ORDER BY idvoucher"
        ).fetchall()
    finally:
        conn.close()
    return render_template(
        "cart.html",
        carts=[dict(r) for r in rows],
        vouchers=[dict(r) for r in vouchers],
    )


@app.route("/cart/add/<int:idp>", methods=["POST"])
def cart_add(idp: int):
    if "user" not in session:
        return redirect(url_for("login"))
    iduser = session.get("iduser")
    conn = get_conn()
    try:
        existing = conn.execute(
            "SELECT stt, quanlity FROM carts WHERE iduser=? AND idp=?",
            (iduser, idp),
        ).fetchone()
        if existing:
            new_qty = (existing["quanlity"] or 0) + 1
            conn.execute(
                "UPDATE carts SET quanlity=? WHERE stt=?",
                (new_qty, existing["stt"]),
            )
        else:
            conn.execute(
                "INSERT INTO carts (iduser, idp, quanlity) VALUES (?, ?, ?)",
                (iduser, idp, 1),
            )
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("products"))


@app.route("/order", methods=["POST"])
def order():
    if "user" not in session:
        return redirect(url_for("login"))
    iduser = session.get("iduser")
    voucher_id = request.form.get("idvoucher") or None
    conn = get_conn()
    try:
        cart_rows = conn.execute(
            """
            SELECT c.idp, c.quanlity, p.newprice
            FROM carts c
            LEFT JOIN products p ON c.idp = p.idp
            WHERE c.iduser=?
            """,
            (iduser,),
        ).fetchall()
        voucher = None
        if voucher_id:
            voucher = conn.execute(
                "SELECT valuevc FROM vouchers WHERE idvoucher=?", (voucher_id,)
            ).fetchone()
        discount_value = voucher["valuevc"] if voucher else 0
        for row in cart_rows:
            price = _parse_money(row["newprice"])
            qty = row["quanlity"] or 1
            total = price * qty
            if discount_value:
                if int(discount_value) <= 100:
                    total = int(total * (100 - int(discount_value)) / 100)
                else:
                    total = max(0, total - int(discount_value))
            conn.execute(
                """
                INSERT INTO bills (iduser, idp, totalmoney, status, datebuy, idvoucher)
                VALUES (?, ?, ?, ?, ?, ?)
                """,
                (
                    iduser,
                    row["idp"],
                    str(total),
                    "Chờ thanh toán",
                    datetime.now().strftime("%Y-%m-%d"),
                    voucher_id,
                ),
            )
        conn.execute("DELETE FROM carts WHERE iduser=?", (iduser,))
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("orders"))


@app.route("/orders")
def orders():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        rows = conn.execute(
            """
            SELECT b.sttbill, p.namep AS product_name, b.totalmoney,
                   b.status, b.datebuy, b.idvoucher
            FROM bills b
            LEFT JOIN products p ON b.idp = p.idp
            WHERE b.iduser=?
            ORDER BY b.datebuy DESC, b.sttbill DESC
            """,
            (session.get("iduser"),),
        ).fetchall()
    finally:
        conn.close()
    return render_template("orders.html", bills=[dict(r) for r in rows], status_label=status_label)


@app.route("/admin/db-tools", methods=["GET", "POST"])
def admin_db_tools():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    message = None
    result_rows = []
    conn = get_conn()
    try:
        if request.method == "POST":
            action = request.form.get("action")
            if action == "sp_add_to_cart":
                iduser = request.form.get("iduser")
                idp = request.form.get("idp")
                qty = request.form.get("quanlity") or 1
                conn.execute(
                    "INSERT INTO carts (iduser, idp, quanlity) VALUES (?, ?, ?)",
                    (iduser, idp, qty),
                )
                conn.commit()
                message = "Đã thêm vào giỏ hàng (mô phỏng store procedure)."
            elif action == "fn_user_total_spent":
                iduser = request.form.get("iduser")
                row = conn.execute(
                    "SELECT SUM(CAST(totalmoney AS INT)) AS total FROM bills WHERE iduser=?",
                    (iduser,),
                ).fetchone()
                message = f"Tổng chi tiêu của {iduser}: {row['total'] or 0} VND"
            elif action == "trg_block_negative_voucher":
                valuevc = request.form.get("valuevc") or 0
                if int(valuevc) < 0:
                    message = "Giá trị voucher không hợp lệ (âm) - mô phỏng trigger."
                else:
                    message = "Giá trị voucher hợp lệ."
            elif action == "cur_top_customers":
                result_rows = conn.execute(
                    """
                    SELECT u.name, SUM(CAST(b.totalmoney AS INT)) AS total_spent
                    FROM bills b
                    JOIN users u ON b.iduser = u.iduser
                    GROUP BY u.name
                    ORDER BY total_spent DESC
                    LIMIT 5
                    """
                ).fetchall()
                message = "Top khách hàng chi tiêu (mô phỏng cursor)."
        users = conn.execute("SELECT iduser, name FROM users ORDER BY name").fetchall()
        products = conn.execute("SELECT idp, namep FROM products ORDER BY idp").fetchall()
    finally:
        conn.close()
    return render_template(
        "db_tools.html",
        message=message,
        result_rows=[dict(r) for r in result_rows],
        users=[dict(r) for r in users],
        products=[dict(r) for r in products],
    )


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
