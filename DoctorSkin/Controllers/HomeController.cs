using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using DoctorSkin.Models;
using Microsoft.Ajax.Utilities;
using RouteAttribute = System.Web.Mvc.RouteAttribute;

namespace DoctorSkin.Controllers
{
    public class HomeController : Controller
    {
        DoctorSkinEntities db = new DoctorSkinEntities();
        // GET: Home
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult getCategories()
        {
            var v = from t in db.Categories where t.hide == false select t;
            return PartialView(v.ToList());
        }
        public ActionResult getProducts(long typep)
        {
            var v = from t in db.Products where t.typep == typep && t.hide == false select t;
            return PartialView(v.ToList());
        }

        public ActionResult getBlog()
        {
            var v = from t in db.BlogDetails orderby t.date_up descending select t;
            return PartialView(v.Take(3).ToList());
        }

        public ActionResult getDoctor()
        {
            var v = from t in db.Doctors where t.hide_doc==false select t;
            return PartialView(v.Take(3).ToList());
        }
        public ActionResult getMedia()
        {
            var v = from t in db.Medias where t.hidemedia == false select t;
            return PartialView(v.ToList());
        }

        public ActionResult getService()
        {
            var v = from t in db.Services where t.hide_dt == false select t;
            return PartialView(v.Take(4).ToList());
        }


        

    }
}
