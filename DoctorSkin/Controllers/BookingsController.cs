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
    public class BookingsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();

        [HttpPost]
        public ActionResult Booking(Booking booking)
        {
            try
            {
                db.Bookings.Add(booking);
                db.SaveChanges();
                db.Configuration.ValidateOnSaveEnabled = false;
                return Json(new { code = 0, message = "Đặt lịch hẹn thành công, Chúng tôi sẽ liên lạc lại cho bạn trong thời gian sớm nhất" });
            }
            catch (Exception e)
            {
                return Json(new { code = 1, message = "Đặt ký thất bại" });
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
