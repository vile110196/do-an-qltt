using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoctorSkin.Controllers
{
    public class ErrorController : Controller
    {
        public ActionResult Index(int statuscode)
        {
            ViewBag.StatusCode = statuscode;
            return View("Error");
        }
    }
}