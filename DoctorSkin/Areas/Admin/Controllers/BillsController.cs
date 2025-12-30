using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoctorSkin.Models;
using PagedList;

namespace DoctorSkin.Areas.Admin.Controllers
{
    [Authorize]
    [Authorize(Roles = "Admin")]
    public class BillsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();
        DateTime currentDateTime = DateTime.Now;
        

        // GET: Admin/Bills
        public ActionResult Index()
        {
            return View(db.Bills.ToList());
        }

        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Bills bills = db.Bills.Find(id);
            if (bills == null)
            {
                return HttpNotFound();
            }
            return View(bills);
        }

        public ActionResult Edit(string idbill)
        {
            var bills = db.Bills.Where(s=>s.idbill == idbill).ToList();
            if (idbill == null || bills == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            return View();
        }

        [HttpPost]
        public ActionResult Edit([Bind(Include = "sttbill,idp,quantity,totalbill,totalmoney,idbill,iduser,note,status,yesfb,datebuy,idvoucher")] Bills bills)
        {
            if (ModelState.IsValid)
            {
                db.Entry(bills).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(bills);
        }

        [HttpDelete]
        public ActionResult Delete(int id)
        {
            Bills bills = db.Bills.Find(id);
            db.Bills.Remove(bills);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        public ActionResult Choxacnhan(int? page)
        {
            int pageSize = 10;
            int pageNumber = (page ?? 1);
            
            var bills = db.Bills.Where(s => s.status == "Chờ xác nhận")
                        .GroupBy(s => s.idbill)
                        .Select(g => g.FirstOrDefault())
                        .OrderByDescending(s => s.datebuy)
                        .ToList();
            return PartialView(bills.ToPagedList(pageNumber, pageSize));
        }

        public ActionResult Daxacnhan(int? page)
        {
            int pageSize = 10;
            int pageNumber = (page ?? 1);

            var bills = db.Bills.Where(s => s.status == "Vận chuyển")
                        .GroupBy(s => s.idbill)
                        .Select(g => g.FirstOrDefault())
                        .OrderByDescending(s => s.datebuy)
                        .ToList();
            return PartialView(bills.ToPagedList(pageNumber, pageSize));
        }

        public ActionResult Dahuy(int? page)
        {
            int pageSize = 10;
            int pageNumber = (page ?? 1);

            var bills = db.Bills.Where(s => s.status == "Đã hủy")
                        .GroupBy(s => s.idbill)
                        .Select(g => g.FirstOrDefault())
                        .OrderByDescending(s => s.datebuy)
                        .ToList();
            return PartialView(bills.ToPagedList(pageNumber, pageSize));
        }

        public ActionResult Dagiao(int? page)
        {
            int pageSize = 10;
            int pageNumber = (page ?? 1);

            var bills = db.Bills.Where(s => s.status == "Thành công")
                        .GroupBy(s => s.idbill)
                        .Select(g => g.FirstOrDefault())
                        .OrderByDescending(s => s.datebuy)
                        .ToList();
            return PartialView(bills.ToPagedList(pageNumber, pageSize));
        }

        public ActionResult getProductByBill(string status, string idbill)
        {
            var bills = db.Bills.Where(s=> s.status == status && s.idbill == idbill).ToList();
            return PartialView(bills);
        }

        [HttpPut]
        public ActionResult Cancel(string idbill)
        {
            var bills = db.Bills.Where(s => s.idbill == idbill).ToList();

            if(bills == null)
                return Json(new { code = 0, message = "Fail" });
            foreach (var i in bills)
            {
                i.status = "Đã hủy";
                i.whycancel = "Đã hủy bởi người bán";
            }
            db.Configuration.ValidateOnSaveEnabled = false;
            db.SaveChanges();
            return Json(new { code = 0, message = "Thành công" });
        }

        [HttpPut]
        public ActionResult Confirm(string idbill)
        {
            var bills = db.Bills.Where(s => s.idbill == idbill).ToList();

            if (bills == null)
                return Json(new { code = 0, message = "Fail" });
            foreach (var i in bills)
            {
                i.status = "Vận chuyển";
            }
            db.Configuration.ValidateOnSaveEnabled = false;
            db.SaveChanges();
            return Json(new { code = 0, message = "Thành công" });
        }

        [HttpPut]
        public ActionResult ThanhCong(string idbill)
        {
            var bills = db.Bills.Where(s => s.idbill == idbill).ToList();

            if (bills == null)
                return Json(new { code = 0, message = "Fail" });

            foreach (var i in bills)
            {
                i.status = "Thành công";
                i.datesuccess = DateTime.Parse(currentDateTime.ToString("yyyy-MM-dd HH:mm:ss"));

                //Cập nhật số tiền tích lũy
                //Lấy thông tin user
                var user = db.Users.FirstOrDefault(s => s.iduser == i.iduser);
                user.total = user.total + int.Parse(i.totalmoney);

                //100 ngàn tích được 10 điểm
                user.point = user.point + (int)Math.Round(decimal.Parse(i.totalmoney) / 100000) * 10;

            }
            db.Configuration.ValidateOnSaveEnabled = false;
            db.SaveChanges();
            return Json(new { code = 0, message = "Thành công" });
        }

        [HttpGet]
        public ActionResult getDataBill(string idbill)
        {
            string param = HttpUtility.UrlDecode(idbill);
            var bill = db.Bills.FirstOrDefault(s => s.idbill == param);
            if (bill == null)
                return Json(new { code = 1, bills = "Lỗi" });
            else
            {
                //lấy thông tin khách hàng
                var user = db.Users.FirstOrDefault(s => s.iduser == bill.iduser);
                var modifiedBills = new
                {
                    bill = bill,
                    name = user.name,
                    email = user.email,
                    phone = user.phone,
                };

                return Json(new { code = 0, bills = modifiedBills }, JsonRequestBehavior.AllowGet);
            }    

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
