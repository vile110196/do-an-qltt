using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoctorSkin.Models;
using Microsoft.IdentityModel.Tokens;

namespace DoctorSkin.Controllers
{
    public class VouchersController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();

        //XỬ LÝ API
        [HttpGet]
        public JsonResult GetVoucherByID(string idvoucher)
        {
            var voucher = db.Vouchers.FirstOrDefault(s => s.idvoucher == idvoucher && s.hidevc == false);
            if (voucher == null)
                return Json(new { code = 1, message = "Mã Voucher không hợp lệ" }, JsonRequestBehavior.AllowGet);
            return Json(new { code = 0, voucher = voucher }, JsonRequestBehavior.AllowGet);
        }


        // GET: Vouchers
        public ActionResult Index()
        {
            string iduser = (string)Session["iduser"];
            var usedVouchers = db.Bills.Where(b => b.iduser == iduser).Select(b => b.idvoucher).ToList();
            var unusedVouchers = db.Vouchers.Where(v => !usedVouchers.Contains(v.idvoucher) && v.hidevc == false).ToList();
            return View(unusedVouchers);
        }

        // GET: Vouchers/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Vouchers vouchers = db.Vouchers.Find(id);
            if (vouchers == null)
            {
                return HttpNotFound();
            }
            return View(vouchers);
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
