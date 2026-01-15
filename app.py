# app.py (SQL Server only - fixed for non-IDENTITY stt/sttbill)
import json
from datetime import datetime
from typing import Dict, Iterable, List, Optional, Sequence

from flask import Flask, redirect, render_template, request, session, url_for
import pyodbc

# =========================
# CONFIG
# =========================
USE_SQL_SERVER = True
SQL_SERVER = r"DESKTOP-V0J3SSS\SQLEXPRESS"
SQL_DATABASE = "DOCTORSKIN2"

# Nếu dùng SQL Login thì điền:
SQL_USERNAME = ""
SQL_PASSWORD = ""

app = Flask(__name__, template_folder="template")
app.secret_key = "replace_with_a_random_secret_key"

STATUS_LABELS = {
    "pending": "Chờ thanh toán",
    "paid": "Đã thanh toán",
    "cancelled": "Đã hủy",
    "Chờ thanh toán": "Chờ thanh toán",
    "Đã thanh toán": "Đã thanh toán",
    "Đã hủy": "Đã hủy",
}

# =========================
# TABLE MAPPING (SQL Server dbo + PascalCase)
# =========================
def T(name: str) -> str:
    mapping = {
        "users": "dbo.Users",
        "user_roles": "dbo.UserRoles",
        "user_roles_mappings": "dbo.UserRolesMappings",
        "role_masters": "dbo.RoleMasters",
        "categories": "dbo.Categories",
        "brands": "dbo.Brands",
        "products": "dbo.Products",
        "vouchers": "dbo.Vouchers",
        "campaigns": "dbo.Campaigns",
        "campaign_vouchers": "dbo.CampaignVouchers",
        "bills": "dbo.Bills",
        "bought": "dbo.Bought",
        "carts": "dbo.Carts",
        "wishlists": "dbo.Wishlists",
        "services": "dbo.Services",
        "services_details": "dbo.ServicesDetails",
        "blog_types": "dbo.BlogTypes",
        "blog_details": "dbo.BlogDetails",
        "banners": "dbo.Banners",
        "medias": "dbo.Medias",
        "bookings": "dbo.Bookings",
        "patients": "dbo.Patients",
        "doctors": "dbo.Doctors",
        "medicines": "dbo.Medicines",
        "forgots": "dbo.Forgots",
        "questions": "dbo.Questions",
    }
    return mapping.get(name, f"dbo.{name}")


def user_password_col() -> str:
    # SQL Server schema dùng cột [pass]
    return "pass"


# =========================
# DB WRAPPERS
# =========================
class CursorWrapper:
    def __init__(self, cursor):
        self._cursor = cursor

    def fetchall(self) -> List[Dict[str, object]]:
        rows = self._cursor.fetchall()
        if not rows:
            return []
        columns = [col[0] for col in self._cursor.description]
        return [dict(zip(columns, row)) for row in rows]

    def fetchone(self) -> Optional[Dict[str, object]]:
        row = self._cursor.fetchone()
        if row is None:
            return None
        columns = [col[0] for col in self._cursor.description]
        return dict(zip(columns, row))

    def __getattr__(self, name: str):
        return getattr(self._cursor, name)


class ConnectionWrapper:
    def __init__(self, conn):
        self._conn = conn

    def execute(self, sql: str, params: Sequence[object] = ()) -> CursorWrapper:
        cur = self._conn.cursor()
        cur.execute(sql, params)
        return CursorWrapper(cur)

    def commit(self) -> None:
        self._conn.commit()

    def close(self) -> None:
        self._conn.close()


def _sql_server_conn_string() -> str:
    if SQL_USERNAME and SQL_PASSWORD:
        return (
            "DRIVER={ODBC Driver 17 for SQL Server};"
            f"SERVER={SQL_SERVER};DATABASE={SQL_DATABASE};"
            f"UID={SQL_USERNAME};PWD={SQL_PASSWORD};"
            "TrustServerCertificate=yes;"
        )
    return (
        "DRIVER={ODBC Driver 17 for SQL Server};"
        f"SERVER={SQL_SERVER};DATABASE={SQL_DATABASE};"
        "Trusted_Connection=yes;"
        "TrustServerCertificate=yes;"
    )


def get_conn() -> ConnectionWrapper:
    conn = pyodbc.connect(_sql_server_conn_string(), autocommit=False)
    return ConnectionWrapper(conn)


# =========================
# Helpers
# =========================
def status_label(value: Optional[str]) -> str:
    if not value:
        return "Chờ thanh toán"
    return STATUS_LABELS.get(value, value)


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


def next_id(conn: ConnectionWrapper, table_sql: str, col: str) -> int:
    """
    Sinh ID thủ công cho trường hợp DB không dùng IDENTITY.
    UPDLOCK + HOLDLOCK để giảm rủi ro trùng ID khi nhiều request.
    """
    row = conn.execute(
        f"SELECT ISNULL(MAX({col}),0) + 1 AS next_id FROM {table_sql} WITH (UPDLOCK, HOLDLOCK)"
    ).fetchone()
    if not row or row.get("next_id") is None:
        return 1
    return int(row["next_id"])


def parse_money(val) -> int:
    if val is None:
        return 0
    digits = "".join(ch for ch in str(val) if ch.isdigit())
    return int(digits) if digits else 0


def is_identity_column(conn: ConnectionWrapper, table_sql: str, column: str) -> bool:
    schema, table = table_sql.split(".", 1) if "." in table_sql else ("dbo", table_sql)
    row = conn.execute(
        """
        SELECT COLUMNPROPERTY(OBJECT_ID(QUOTENAME(?) + '.' + QUOTENAME(?)), ?, 'IsIdentity') AS is_identity
        """,
        (schema, table, column),
    ).fetchone()
    return bool(row and row.get("is_identity"))


def ensure_user_for_booking(conn: ConnectionWrapper, booking_id: Optional[str]) -> Optional[str]:
    if not booking_id:
        return None
    booking = conn.execute(
        f"SELECT stt, name, phone FROM {T('bookings')} WHERE stt=?",
        (booking_id,),
    ).fetchone()
    if not booking:
        return None
    phone = booking.get("phone")
    if phone:
        existing = conn.execute(
            f"SELECT iduser FROM {T('users')} WHERE phone=?",
            (phone,),
        ).fetchone()
        if existing:
            return existing.get("iduser")
    candidate = phone or f"bk_{booking['stt']}"
    if conn.execute(
        f"SELECT 1 FROM {T('users')} WHERE iduser=?",
        (candidate,),
    ).fetchone():
        candidate = f"bk_{booking['stt']}"
    conn.execute(
        f"""
        INSERT INTO {T('users')} (iduser, name, birth, gender, address, phone, email, [pass], point, dateregist)
        VALUES (?, ?, NULL, NULL, NULL, ?, NULL, NULL, 0, GETDATE())
        """,
        (candidate, booking.get("name"), phone),
    )
    return candidate


def table_has_column(conn: ConnectionWrapper, table_sql: str, column: str) -> bool:
    schema, table = table_sql.split(".", 1) if "." in table_sql else ("dbo", table_sql)
    row = conn.execute(
        """
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = ?
          AND TABLE_NAME = ?
          AND COLUMN_NAME = ?
        """,
        (schema, table, column),
    ).fetchone()
    return row is not None


def get_item_price(conn: ConnectionWrapper, item_id: int) -> int:
    if item_id < 0:
        row = conn.execute(
            f"SELECT price_sd FROM {T('services_details')} WHERE id_sd=?",
            (abs(item_id),),
        ).fetchone()
        return parse_money(row.get("price_sd")) if row else 0
    row = conn.execute(
        f"SELECT newprice FROM {T('products')} WHERE idp=?",
        (item_id,),
    ).fetchone()
    return parse_money(row.get("newprice")) if row else 0


def next_booking_id(conn) -> int:
    row = conn.execute(
        f"SELECT ISNULL(MAX(stt),0) + 1 AS next_id FROM {T('bookings')}"
    ).fetchone()
    return row["next_id"] if row else 1


# =========================
# AUTH
# =========================
@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]

        conn = get_conn()
        try:
            pwd_col = user_password_col()
            user = conn.execute(
                f"SELECT iduser, name, [{pwd_col}] AS pass, email FROM {T('users')} WHERE email=?",
                (email,),
            ).fetchone()

            if user and (user.get("pass") == password):
                role_row = conn.execute(
                    f"SELECT TOP 1 rolename FROM {T('user_roles')} WHERE email=? ORDER BY stt DESC",
                    (email,),
                ).fetchone()
                role = (role_row["rolename"] if role_row else "user") or "user"

                session["user"] = user.get("name")
                session["iduser"] = user.get("iduser")
                session["email"] = user.get("email")
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


# =========================
# PAGES
# =========================
@app.route("/dashboard")
def dashboard():
    if "user" not in session:
        return redirect(url_for("login"))

    conn = get_conn()
    try:
        bookings_dates = [r["timebooking"] for r in conn.execute(f"SELECT timebooking FROM {T('bookings')}").fetchall()]
        bills_dates = [r["datebuy"] for r in conn.execute(f"SELECT datebuy FROM {T('bills')}").fetchall()]
        users_dates = [r["dateregist"] for r in conn.execute(f"SELECT dateregist FROM {T('users')}").fetchall()]
        patients_dates = [r["date"] for r in conn.execute(f"SELECT date FROM {T('patients')}").fetchall()]

        top_customer_row = conn.execute(
            f"""
            SELECT TOP 1 u.name AS customer_name, SUM(TRY_CAST(b.totalmoney AS INT)) AS total_spent
            FROM {T('bills')} b
            JOIN {T('users')} u ON b.iduser = u.iduser
            WHERE b.datebuy >= DATEADD(month, -3, GETDATE())
            GROUP BY u.name
            ORDER BY total_spent DESC
            """
        ).fetchone()

        top_customer_name = top_customer_row["customer_name"] if top_customer_row else "N/A"
        top_customer_total = (
            top_customer_row["total_spent"]
            if top_customer_row and top_customer_row.get("total_spent") is not None
            else 0
        )

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
    try:
        rows = conn.execute(
            f"SELECT stt, name, phone, timebooking, require FROM {T('bookings')} ORDER BY timebooking"
        ).fetchall()
        return render_template("schedule.html", bookings=rows)
    finally:
        conn.close()


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

            if USE_SQL_SERVER:
                stt = next_booking_id(conn)
                conn.execute(
                    f"INSERT INTO {T('bookings')} (stt, name, phone, timebooking, require) VALUES (?, ?, ?, ?, ?)",
                    (stt, name, phone, date, req),
                )
            else:
                conn.execute(
                    f"INSERT INTO {T('bookings')} (name, phone, timebooking, require) VALUES (?, ?, ?, ?)",
                    (name, phone, date, req),
                )
            conn.commit()
            return redirect(url_for("booking"))

        rows = conn.execute(
            f"SELECT stt, name, phone, timebooking, require FROM {T('bookings')} ORDER BY timebooking"
        ).fetchall()
        return render_template("booking.html", bookings=rows)
    finally:
        conn.close()


@app.route("/products")
def products():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        rows = conn.execute(
            f"""
            SELECT p.idp, p.namep, c.namec, b.namebrand, p.newprice, p.oldprice, p.descr
            FROM {T('products')} p
            LEFT JOIN {T('categories')} c ON p.typep = c.typep
            LEFT JOIN {T('brands')} b ON p.idbrand = b.idbrand
            ORDER BY p.idp
            """
        ).fetchall()
        return render_template("products.html", products=rows)
    finally:
        conn.close()


@app.route("/services")
def services():
    if "user" not in session:
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        rows = conn.execute(
            f"""
            SELECT s.id_dt, s.name_dt, s.desc_dt, d.id_sd, d.name_sd, d.price_sd
            FROM {T('services')} s
            LEFT JOIN {T('services_details')} d ON s.id_dt = d.id_dt
            ORDER BY s.id_dt
            """
        ).fetchall()
        return render_template("services.html", services=rows)
    finally:
        conn.close()


# =========================
# ADMIN
# =========================
@app.route("/admin/users")
def admin_users():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        rows = conn.execute(
            f"SELECT iduser, name, birth, gender, address, phone, email, point, dateregist FROM {T('users')}"
        ).fetchall()
        return render_template("admin_users.html", users=rows)
    finally:
        conn.close()


@app.route("/admin/doctors")
def admin_doctors():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        rows = conn.execute(
            f"""
            SELECT u.iduser, u.name, u.gender, u.phone, u.email, d.infordoc
            FROM {T('users')} u
            JOIN {T('user_roles')} r ON r.email = u.email
            LEFT JOIN {T('doctors')} d ON d.iddoc = u.iduser
            WHERE LOWER(r.rolename) = 'doctor'
            """
        ).fetchall()
        return render_template("admin_doctors.html", doctors=rows)
    finally:
        conn.close()


@app.route("/admin/carts")
def admin_carts():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        rows = conn.execute(
            f"""
            SELECT c.stt, c.iduser, u.name AS user_name, c.idp,
                   COALESCE(p.namep, sd.name_sd) AS product_name,
                   c.quanlity, COALESCE(p.newprice, sd.price_sd) AS newprice
            FROM {T('carts')} c
            LEFT JOIN {T('users')} u ON c.iduser = u.iduser
            LEFT JOIN {T('products')} p ON c.idp = p.idp
            LEFT JOIN {T('services_details')} sd ON c.idp = -sd.id_sd
            ORDER BY c.stt
            """
        ).fetchall()
        users = conn.execute(f"SELECT iduser, name FROM {T('users')} ORDER BY name").fetchall()
        products = conn.execute(f"SELECT idp, namep FROM {T('products')} ORDER BY idp").fetchall()
        return render_template("admin_carts.html", carts=rows, users=users, products=products)
    finally:
        conn.close()


@app.route("/admin/carts/add", methods=["POST"])
def admin_carts_add():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    iduser = request.form.get("iduser")
    idp = request.form.get("idp")
    qty = int(request.form.get("quanlity") or 1)

    conn = get_conn()
    try:
        existing = conn.execute(
            f"SELECT stt, quanlity FROM {T('carts')} WHERE iduser=? AND idp=?",
            (iduser, idp),
        ).fetchone()

        if existing:
            conn.execute(
                f"UPDATE {T('carts')} SET quanlity = ISNULL(quanlity,0) + ? WHERE stt=?",
                (qty, existing["stt"]),
            )
        else:
            if is_identity_column(conn, T("carts"), "stt"):
                conn.execute(
                    f"INSERT INTO {T('carts')} (iduser, idp, quanlity) VALUES (?, ?, ?)",
                    (iduser, idp, qty),
                )
            else:
                new_stt = next_id(conn, T("carts"), "stt")
                conn.execute(
                    f"INSERT INTO {T('carts')} (stt, iduser, idp, quanlity) VALUES (?, ?, ?, ?)",
                    (new_stt, iduser, idp, qty),
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
    qty = int(request.form.get("quanlity") or 1)

    conn = get_conn()
    try:
        conn.execute(
            f"UPDATE {T('carts')} SET iduser=?, idp=?, quanlity=? WHERE stt=?",
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
        conn.execute(f"DELETE FROM {T('carts')} WHERE stt=?", (stt,))
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_carts"))


@app.route("/admin/nurses")
def admin_nurses():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        rows = conn.execute(
            f"""
            SELECT u.iduser, u.name, u.gender, u.phone, u.email
            FROM {T('users')} u
            JOIN {T('user_roles')} r ON r.email = u.email
            WHERE LOWER(r.rolename) = 'nurse'
            """
        ).fetchall()
        return render_template("admin_nurses.html", nurses=rows)
    finally:
        conn.close()


@app.route("/admin/schedule")
def admin_schedule():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        rows = conn.execute(
            f"SELECT stt, name, phone, timebooking, require FROM {T('bookings')} ORDER BY timebooking"
        ).fetchall()
        return render_template("admin_schedule.html", bookings=rows)
    finally:
        conn.close()


@app.route("/admin/bills")
def admin_bills():
    if session.get("role") != "admin":
        return redirect(url_for("login"))
    conn = get_conn()
    try:
        has_quantity = table_has_column(conn, T("bills"), "quantity")
        select_quantity = ", b.quantity" if has_quantity else ""
        rows = conn.execute(
            f"""
            SELECT b.sttbill, b.iduser, b.idp, u.name AS customer_name, u.email,
                   COALESCE(p.namep, sd.name_sd) AS item_name,
                   b.totalmoney, b.status, b.datebuy,
                   b.idvoucher, v.namevc AS voucher_name, v.valuevc AS voucher_value{select_quantity}
            FROM {T('bills')} b
            LEFT JOIN {T('users')} u ON b.iduser = u.iduser
            LEFT JOIN {T('products')} p ON b.idp = p.idp
            LEFT JOIN {T('services_details')} sd ON b.idp = -sd.id_sd
            LEFT JOIN {T('vouchers')} v ON b.idvoucher = v.idvoucher
            ORDER BY b.sttbill
            """
        ).fetchall()

        bills = []
        for r in rows:
            bill = dict(r)
            datebuy = bill.get("datebuy")
            bill["datebuy_str"] = (
                datebuy.strftime("%Y-%m-%d") if hasattr(datebuy, "strftime") else (str(datebuy) if datebuy else "")
            )
            if bill.get("quantity") is None:
                bill["quantity"] = 1
            bills.append(bill)

        users = conn.execute(f"SELECT iduser, name FROM {T('users')} ORDER BY name").fetchall()
        products = conn.execute(f"SELECT idp, namep, newprice FROM {T('products')} ORDER BY idp").fetchall()
        services = conn.execute(f"SELECT id_sd, name_sd, price_sd FROM {T('services_details')} ORDER BY id_sd").fetchall()
        vouchers = conn.execute(f"SELECT idvoucher, namevc FROM {T('vouchers')} ORDER BY idvoucher").fetchall()
        bookings = conn.execute(f"SELECT stt, name, phone FROM {T('bookings')} ORDER BY stt DESC").fetchall()

        items = []
        for p in products:
            items.append({"idp": p["idp"], "name": p["namep"], "price": p["newprice"], "type": "product"})
        for s in services:
            items.append({"idp": -int(s["id_sd"]), "name": s["name_sd"], "price": s["price_sd"], "type": "service"})

        return render_template(
            "admin_bills.html",
            bills=bills,
            users=users,
            items=items,
            vouchers=vouchers,
            bookings=bookings,
            status_label=status_label,
        )
    finally:
        conn.close()


@app.route("/admin/bills/add", methods=["POST"])
def admin_bills_add():
    if session.get("role") != "admin":
        return redirect(url_for("login"))

    booking_id = request.form.get("booking_id")
    iduser = request.form.get("iduser")
    item_id = int(request.form.get("item_id") or 0)
    quantity = int(request.form.get("quantity") or 1)
    totalmoney = request.form.get("totalmoney") or ""
    status = request.form.get("status") or "Ch? thanh to?n"
    datebuy = request.form.get("datebuy") or datetime.now().strftime("%Y-%m-%d")
    idvoucher = request.form.get("idvoucher") or None

    conn = get_conn()
    try:
        if booking_id:
            iduser = ensure_user_for_booking(conn, booking_id) or iduser
        if not totalmoney:
            totalmoney = str(get_item_price(conn, item_id) * max(quantity, 1))
        new_bill_id = next_id(conn, T("bills"), "sttbill")
        conn.execute(
            f"""
            INSERT INTO {T('bills')} (sttbill, iduser, idp, totalmoney, status, datebuy, idvoucher)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """,
            (new_bill_id, iduser, item_id, totalmoney, status, datebuy, idvoucher),
        )
        if table_has_column(conn, T("bills"), "quantity"):
            conn.execute(
                f"UPDATE {T('bills')} SET quantity=? WHERE sttbill=?",
                (quantity, new_bill_id),
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
    item_id = int(request.form.get("item_id") or 0)
    quantity = int(request.form.get("quantity") or 1)
    totalmoney = request.form.get("totalmoney") or ""
    status = request.form.get("status") or "Ch? thanh to?n"
    datebuy = request.form.get("datebuy") or datetime.now().strftime("%Y-%m-%d")
    idvoucher = request.form.get("idvoucher") or None

    conn = get_conn()
    try:
        if not totalmoney:
            totalmoney = str(get_item_price(conn, item_id) * max(quantity, 1))
        conn.execute(
            f"""
            UPDATE {T('bills')}
            SET iduser=?, idp=?, totalmoney=?, status=?, datebuy=?, idvoucher=?
            WHERE sttbill=?
            """,
            (iduser, item_id, totalmoney, status, datebuy, idvoucher, sttbill),
        )
        if table_has_column(conn, T("bills"), "quantity"):
            conn.execute(
                f"UPDATE {T('bills')} SET quantity=? WHERE sttbill=?",
                (quantity, sttbill),
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
        conn.execute(f"DELETE FROM {T('bills')} WHERE sttbill=?", (sttbill,))
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
            f"UPDATE {T('bills')} SET status=? WHERE sttbill=?",
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
    try:
        rows = conn.execute(
            f"SELECT stt, idvoucher, namevc, valuevc, quantity, hide FROM {T('vouchers')} ORDER BY stt"
        ).fetchall()
        return render_template("admin_vouchers.html", vouchers=rows)
    finally:
        conn.close()


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
            f"""
            INSERT INTO {T('vouchers')} (idvoucher, namevc, valuevc, quantity, hide)
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
            f"""
            UPDATE {T('vouchers')}
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
        conn.execute(f"DELETE FROM {T('vouchers')} WHERE stt=?", (stt,))
        conn.commit()
    finally:
        conn.close()
    return redirect(url_for("admin_vouchers"))


@app.route("/admin/campaigns")
def admin_campaigns():
    if session.get("role") != "admin":
        return redirect(url_for("login"))

    conn = get_conn()
    try:
        campaigns = conn.execute(
            f"""
            SELECT c.id_campaign, c.name, c.description, c.start_date, c.end_date, c.status,
                   STRING_AGG(cv.voucher_id, ',') AS voucher_ids
            FROM {T('campaigns')} c
            LEFT JOIN {T('campaign_vouchers')} cv ON cv.campaign_id = c.id_campaign
            GROUP BY c.id_campaign, c.name, c.description, c.start_date, c.end_date, c.status
            ORDER BY c.id_campaign
            """
        ).fetchall()

        vouchers = conn.execute(
            f"SELECT idvoucher, namevc FROM {T('vouchers')} ORDER BY idvoucher"
        ).fetchall()

        return render_template("admin_campaigns.html", campaigns=campaigns, vouchers=vouchers)
    finally:
        conn.close()

@app.route("/admin/campaigns/add", methods=["POST"])
def admin_campaigns_add():
    if session.get("role") != "admin":
        return redirect(url_for("login"))

    name = request.form.get("name") or ""
    description = request.form.get("description") or ""
    start_date = request.form.get("start_date") or None
    end_date = request.form.get("end_date") or None
    status = request.form.get("status") or ""

    # vì <select multiple name="voucher_ids"> nên phải dùng getlist
    voucher_ids = request.form.getlist("voucher_ids")

    conn = get_conn()
    try:
        # tạo campaign
        conn.execute(
            f"""
            INSERT INTO {T('campaigns')} (name, description, start_date, end_date, status)
            VALUES (?, ?, ?, ?, ?)
            """,
            (name, description, start_date, end_date, status),
        )

        # lấy id_campaign vừa insert (SQL Server)
        new_id_row = conn.execute("SELECT CAST(SCOPE_IDENTITY() AS INT) AS new_id").fetchone()
        campaign_id = int(new_id_row["new_id"]) if new_id_row and new_id_row.get("new_id") is not None else None

        # add mapping vouchers
        if campaign_id and voucher_ids:
            for vid in voucher_ids:
                conn.execute(
                    f"INSERT INTO {T('campaign_vouchers')} (campaign_id, voucher_id) VALUES (?, ?)",
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

    name = request.form.get("name") or ""
    description = request.form.get("description") or ""
    start_date = request.form.get("start_date") or None
    end_date = request.form.get("end_date") or None
    status = request.form.get("status") or ""

    voucher_ids = request.form.getlist("voucher_ids")

    conn = get_conn()
    try:
        # update campaign
        conn.execute(
            f"""
            UPDATE {T('campaigns')}
            SET name=?, description=?, start_date=?, end_date=?, status=?
            WHERE id_campaign=?
            """,
            (name, description, start_date, end_date, status, campaign_id),
        )

        # reset mapping vouchers
        conn.execute(
            f"DELETE FROM {T('campaign_vouchers')} WHERE campaign_id=?",
            (campaign_id,),
        )
        if voucher_ids:
            for vid in voucher_ids:
                conn.execute(
                    f"INSERT INTO {T('campaign_vouchers')} (campaign_id, voucher_id) VALUES (?, ?)",
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
        # xóa mapping trước
        conn.execute(
            f"DELETE FROM {T('campaign_vouchers')} WHERE campaign_id=?",
            (campaign_id,),
        )
        # xóa campaign
        conn.execute(
            f"DELETE FROM {T('campaigns')} WHERE id_campaign=?",
            (campaign_id,),
        )
        conn.commit()
    finally:
        conn.close()

    return redirect(url_for("admin_campaigns"))

# =========================
# CART + ORDERS
# =========================
@app.route("/cart")
def cart():
    if "user" not in session:
        return redirect(url_for("login"))

    conn = get_conn()
    try:
        rows = conn.execute(
            f"""
            SELECT c.stt, c.iduser, u.name AS user_name, c.idp,
                   COALESCE(p.namep, sd.name_sd) AS item_name,
                   c.quanlity,
                   COALESCE(p.newprice, sd.price_sd) AS item_price
            FROM {T('carts')} c
            LEFT JOIN {T('users')} u ON c.iduser = u.iduser
            LEFT JOIN {T('products')} p ON c.idp = p.idp
            LEFT JOIN {T('services_details')} sd ON c.idp = -sd.id_sd
            WHERE c.iduser=?
            ORDER BY c.stt
            """,
            (session.get("iduser"),),
        ).fetchall()

        vouchers = conn.execute(
            f"SELECT idvoucher, namevc, valuevc FROM {T('vouchers')} WHERE hide=0 ORDER BY idvoucher"
        ).fetchall()

        return render_template("cart.html", carts=rows, vouchers=vouchers)
    finally:
        conn.close()


def cart_add(idp: int):
    if "user" not in session:
        return redirect(url_for("login"))

    iduser = session.get("iduser")
    conn = get_conn()
    try:
        existing = conn.execute(
            f"SELECT stt, quanlity FROM {T('carts')} WHERE iduser=? AND idp=?",
            (iduser, idp),
        ).fetchone()

        if existing:
            conn.execute(
                f"UPDATE {T('carts')} SET quanlity = ISNULL(quanlity,0) + 1 WHERE stt=?",
                (existing["stt"],),
            )
        else:
            new_stt = next_id(conn, T("carts"), "stt")
            conn.execute(
                f"INSERT INTO {T('carts')} (stt, iduser, idp, quanlity) VALUES (?, ?, ?, ?)",
                (new_stt, iduser, idp, 1),
            )

        conn.commit()
    finally:
        conn.close()

    return redirect(url_for("products"))


@app.route("/cart/add/<int:idp>", methods=["POST"])
def cart_add(idp: int):
    if "user" not in session:
        return redirect(url_for("login"))

    iduser = session.get("iduser")
    conn = get_conn()
    try:
        existing = conn.execute(
            f"SELECT stt, quanlity FROM {T('carts')} WHERE iduser=? AND idp=?",
            (iduser, idp),
        ).fetchone()
        if existing:
            conn.execute(
                f"UPDATE {T('carts')} SET quanlity = ISNULL(quanlity,0) + 1 WHERE stt=?",
                (existing["stt"],),
            )
        else:
            if is_identity_column(conn, T("carts"), "stt"):
                conn.execute(
                    f"INSERT INTO {T('carts')} (iduser, idp, quanlity) VALUES (?, ?, ?)",
                    (iduser, idp, 1),
                )
            else:
                new_stt = next_id(conn, T("carts"), "stt")
                conn.execute(
                    f"INSERT INTO {T('carts')} (stt, iduser, idp, quanlity) VALUES (?, ?, ?, ?)",
                    (new_stt, iduser, idp, 1),
                )
        conn.commit()
    finally:
        conn.close()

    return redirect(url_for("products"))


@app.route("/cart/add_service/<int:id_sd>", methods=["POST"])
def cart_add_service(id_sd: int):
    return cart_add(-id_sd)


@app.route("/order", methods=["POST"])
def order():
    if "user" not in session:
        return redirect(url_for("login"))

    iduser = session.get("iduser")
    voucher_id = request.form.get("idvoucher") or None

    conn = get_conn()
    try:
        cart_rows = conn.execute(
            f"""
            SELECT c.idp, c.quanlity,
                   COALESCE(p.newprice, sd.price_sd) AS item_price
            FROM {T('carts')} c
            LEFT JOIN {T('products')} p ON c.idp = p.idp
            LEFT JOIN {T('services_details')} sd ON c.idp = -sd.id_sd
            WHERE c.iduser=?
            """,
            (iduser,),
        ).fetchall()

        voucher = None
        if voucher_id:
            voucher = conn.execute(
                f"SELECT valuevc FROM {T('vouchers')} WHERE idvoucher=?",
                (voucher_id,),
            ).fetchone()

        discount_value = voucher["valuevc"] if voucher else 0

        for row in cart_rows:
            price = parse_money(row.get("item_price"))
            qty = row.get("quanlity") or 1
            total = price * qty
            if discount_value:
                if int(discount_value) <= 100:
                    total = int(total * (100 - int(discount_value)) / 100)
                else:
                    total = max(0, total - int(discount_value))

            new_bill_id = next_id(conn, T("bills"), "sttbill")
            conn.execute(
                f"""
                INSERT INTO {T('bills')} (sttbill, iduser, idp, totalmoney, status, datebuy, idvoucher)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """,
                (
                    new_bill_id,
                    iduser,
                    row.get("idp"),
                    str(total),
                    "Ch? thanh to?n",
                    datetime.now().strftime("%Y-%m-%d"),
                    voucher_id,
                ),
            )
            if table_has_column(conn, T("bills"), "quantity"):
                conn.execute(
                    f"UPDATE {T('bills')} SET quantity=? WHERE sttbill=?",
                    (qty, new_bill_id),
                )

        conn.execute(f"DELETE FROM {T('carts')} WHERE iduser=?", (iduser,))
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
            f"""
            SELECT b.sttbill, COALESCE(p.namep, sd.name_sd) AS item_name, b.totalmoney,
                   b.status, b.datebuy, b.idvoucher
            FROM {T('bills')} b
            LEFT JOIN {T('products')} p ON b.idp = p.idp
            LEFT JOIN {T('services_details')} sd ON b.idp = -sd.id_sd
            WHERE b.iduser=?
            ORDER BY b.datebuy DESC, b.sttbill DESC
            """,
            (session.get("iduser"),),
        ).fetchall()
        return render_template("orders.html", bills=rows, status_label=status_label)
    finally:
        conn.close()


if __name__ == "__main__":
    app.run(debug=True)
