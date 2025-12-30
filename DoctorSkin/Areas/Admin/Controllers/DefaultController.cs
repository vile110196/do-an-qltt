using DoctorSkin.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoctorSkin.Areas.Admin.Controllers
{
    public class DefaultController : Controller
    {
        // GET: Admin/Default

        DoctorSkinEntities db = new DoctorSkinEntities();

        public ActionResult getListDetailByService(int id_dt)
        {
            var v = from t in db.ServicesDetails
                    where t.id_dt == id_dt
                    select t;
            return PartialView(v.ToList());
        }

        public ActionResult getListServices()
        {
            ViewBag.meta = "dich-vu";
            var v = from t in db.Services
                    select t;
            return PartialView(v.ToList());
        }

    }
}