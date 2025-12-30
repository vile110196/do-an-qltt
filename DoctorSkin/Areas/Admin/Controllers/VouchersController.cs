using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoctorSkin.Models;

namespace DoctorSkin.Areas.Admin.Controllers
{
    [Authorize]
    [Authorize(Roles = "Admin")]
    public class VouchersController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();

        // GET: Admin/Vouchers
        public ActionResult Index()
        {
            return View(db.Vouchers.ToList());
        }

        [HttpPost]
        public ActionResult Create(Vouchers vouchers)
        {
            if (ModelState.IsValid)
            {
                if (!db.Vouchers.Any(s => s.idvoucher == vouchers.idvoucher))
                {
                    db.Vouchers.Add(vouchers);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                else
                {
                    ModelState.AddModelError("idvoucher", "The idvoucher already exists.");
                }
            }
            else
            {
                var errorMessages = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage).ToList();
                ViewBag.ErrorMessages = errorMessages;
            }

            return RedirectToAction(("Index"));
        }



        [HttpPut]
        public ActionResult Edit(string idvoucher, string namevc, string valuevc, int quantity, string datefrom, string dateto, bool hidevc)
        {
            var item = db.Vouchers.FirstOrDefault(s => s.idvoucher == idvoucher);

            item.idvoucher = idvoucher;
            item.namevc = namevc;
            item.valuevc = valuevc;
            item.quantity = quantity;
            item.datefrom = datefrom;
            item.dateto = dateto;
            item.hidevc = hidevc;

            if (item != null)
            {
                db.Configuration.ValidateOnSaveEnabled = false;
                db.SaveChanges();
                return Json(new { code = 0, message = "Thành công" });
            }
            else
                return Json(new { code = 1, message = "Failed" });

        }

        [HttpDelete]
        public ActionResult Delete(string idvoucher)
        {
            var vc = db.Vouchers.FirstOrDefault(s => s.idvoucher == idvoucher);
            if (vc != null)
            {
                db.Vouchers.Remove(vc);
                db.SaveChanges();
                return Json(new { code = 0, message = "Thành công" });
            }
            else
                return Json(new { code = 1, message = "Failed" });
        }

        [HttpGet]
        public ActionResult getVoucherByID(string idvoucher)
        {
            var vc = db.Vouchers.FirstOrDefault(s => s.idvoucher == idvoucher);
            if (vc != null)
                return Json(new { code = 0, data = vc }, JsonRequestBehavior.AllowGet);
            else
                return Json(new { code = 1, message = "Failed" });
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
