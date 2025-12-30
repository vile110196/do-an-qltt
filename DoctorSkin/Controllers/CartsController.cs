using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoctorSkin.Models;

namespace DoctorSkin.Controllers
{
    public class CartsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();

        // GET: Carts
        public ActionResult Index(string filter)
        {
            if (Session["iduser"] == null)
            {
                Response.Redirect("/dang-nhap");
            }
            string iduser = (string)Session["iduser"];
            var v = (from a in db.Products
                     join b in db.Carts on a.idp equals b.idp
                     where b.iduser==iduser
                     select a).ToList();

            switch (filter)
            {
                case "hethang":
                    v = v.Where(c => c.hide == true).ToList();
                    break;
                default:
                    v = v.Where(c => c.hide == false).ToList();
                    break;
            }
            return View(v);
        }

        public ActionResult payMent()
        {
            if (Session["iduser"] == null)
            {
                Response.Redirect("/dang-nhap");
            }

            string iduser = (string)Session["iduser"];
            if (iduser == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Users users = db.Users.Find(iduser);
            if (users == null)
            {
                return HttpNotFound();
            }
            return View(users);
        }

       

        [HttpPost]
        public ActionResult addBill(List<Bills> Bills, string totalmoney, string idvoucher, string address)
        {
            DateTime currentDateTime = DateTime.Now;

            //tại mỗi Bills thêm field totalmoney
            foreach (var i in Bills)
            {
                i.datebuy = DateTime.Parse(currentDateTime.ToString("yyyy-MM-dd HH:mm:ss"));
                i.totalbill = totalmoney;
                i.address = address;
                db.Bills.Add(i);
            }
            db.Bills.AddRange(Bills);

            //xóa khỏi cart
            foreach(var i in Bills)
            {
                var item = db.Carts.Where(s => s.iduser == i.iduser && s.idp == i.idp).FirstOrDefault();
                db.Carts.Remove(item);
            }

            //xử lý voucher
            var voucher = db.Vouchers.FirstOrDefault(s => s.idvoucher == idvoucher);
            if(voucher != null)
                voucher.dasudung = voucher.dasudung + 1;

            db.SaveChanges();

            db.Configuration.ValidateOnSaveEnabled = false;

            return Json(new { code = 0, message = "Đặt hàng thành công" });
        }

        //GET: Carts/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Carts carts = db.Carts.Find(id);
            if (carts == null)
            {
                return HttpNotFound();
            }
            return View(carts);
        }

        // GET: Carts/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Carts/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "stt,iduser,idp,quanlity")] Carts carts)
        {
            if (ModelState.IsValid)
            {
                db.Carts.Add(carts);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(carts);
        }

        // GET: Carts/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Carts carts = db.Carts.Find(id);
            if (carts == null)
            {
                return HttpNotFound();
            }
            return View(carts);
        }

        // POST: Carts/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "stt,iduser,idp,quanlity")] Carts carts)
        {
            if (ModelState.IsValid)
            {
                db.Entry(carts).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(carts);
        }

        // GET: Carts/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Carts carts = db.Carts.Find(id);
            if (carts == null)
            {
                return HttpNotFound();
            }
            return View(carts);
        }

        // POST: Carts/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Carts carts = db.Carts.Find(id);
            db.Carts.Remove(carts);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
