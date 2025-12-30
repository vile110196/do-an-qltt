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
    public class ServicesDetailsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();

        [Authorize(Roles = "Admin")]
        public ActionResult Index(string meta)
        {
            ViewBag.title = (from t in db.Services where t.meta == meta select t.name_dt).FirstOrDefault().ToString();
            ViewBag.img = (from t in db.Services where t.meta == meta select t.slider_dt).FirstOrDefault().ToString() + ".png";
            var v = from t in db.Services where t.meta == meta && t.hide_dt == false select t;
            return View(v.FirstOrDefault());
        }

        [HttpPut]
        public ActionResult toggleServiceDetail(int id_sd, bool hide_sd)
        {
            var service = db.ServicesDetails.FirstOrDefault(s => s.id_sd == id_sd);
            if (service == null)
                return Json(new { code = 1, message = "Cập nhật không thành công" });

            service.hide_sd = hide_sd;
            db.Configuration.ValidateOnSaveEnabled = false;
            db.SaveChanges();

            return Json(new { code = 0, message = "Cập nhật thành công"});
        }
    }
}
