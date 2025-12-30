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
    public class BookingsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();

        // GET: Admin/Bookings
        public ActionResult Index()
        {
            return View(db.Bookings.ToList());
        }

        // GET: Admin/Bookings/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Booking booking = db.Bookings.Find(id);
            if (booking == null)
            {
                return HttpNotFound();
            }
            return View(booking);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "stt,name,phone,email,require")] Booking booking)
        {
            if (ModelState.IsValid)
            {
                db.Bookings.Add(booking);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(booking);
        }

        [HttpPut]
        public ActionResult Edit(int stt, string name, string email, string phone, string require, string timebooking)
        {
            var item = db.Bookings.FirstOrDefault(s => s.stt == stt);

            item.name = name;
            item.email = email;
            item.phone = phone;
            item.require = require;
            item.timebooking = DateTime.Parse(timebooking);

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
        public ActionResult DeleteConfirmed(int stt)
        {
            Booking booking = db.Bookings.FirstOrDefault(s => s.stt == stt);
            if (booking != null)
            {
                db.Bookings.Remove(booking);
                db.SaveChanges();
                return Json(new { code = 0, message = "Thành công" });
            }
            else
                return Json(new { code = 1, message = "Failed" });

        }

        [HttpPut]
        public ActionResult changeCompleted(int stt, bool completed)
        {
            Booking booking = db.Bookings.FirstOrDefault(s => s.stt == stt);
            if (booking != null)
            {
                booking.completed = completed;

                db.SaveChanges();
                return Json(new { code = 0, message = "Thành công" });
            }
            else
                return Json(new { code = 1, message = "Failed" });

        }

        [HttpGet]
        public ActionResult getInfo(int stt)
        {
            Booking booking = db.Bookings.FirstOrDefault(s => s.stt == stt);
            if (booking != null)
            {
                return Json(new { code = 0, data = booking }, JsonRequestBehavior.AllowGet);
            }
            else
                return Json(new { code = 1, message = "Failed" }, JsonRequestBehavior.AllowGet);

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
