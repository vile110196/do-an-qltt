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
    public class ServicesDetailsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();

        // GET: ServicesDetails
        public ActionResult Index(string meta = null)
        {
            ViewBag.title = (from t in db.Services where t.meta == meta select t.name_dt).FirstOrDefault().ToString();
            ViewBag.img = (from t in db.Services where t.meta == meta select t.slider_dt).FirstOrDefault().ToString()+".png";
            var v = from t in db.Services where t.meta == meta && t.hide_dt==false select t;
            return View(v.FirstOrDefault());
        }
    }
}
