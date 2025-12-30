using DoctorSkin.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoctorSkin.Controllers
{
    public class BlogByTypeController : Controller
    {
        DoctorSkinEntities db = new DoctorSkinEntities();
        // GET: BlogByType
        public ActionResult Index(String meta)
        {
            var v = from t in db.BlogType where t.meta == meta select t;
            return View(v.FirstOrDefault());
        }
    }
}