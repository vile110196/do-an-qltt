using DoctorSkin.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoctorSkin.Areas.Admin.Controllers
{
    [Authorize]
    [Authorize(Roles = "Admin")]
    public class BannersController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();
        // GET: Admin/Banners
        public ActionResult Index()
        {
            var banners = db.Banners.ToList();
            return View(banners);
        }

        [HttpPut]
        public ActionResult hideBanner(int stt, bool hide, string page)
        {
            var banner = db.Banners.FirstOrDefault(s => s.stt == stt);
            if (banner != null)
            {
                if (page == "home")
                    banner.homepage = hide;
                if (page == "service")
                    banner.servicepage = hide;
                if (page == "blog")
                    banner.blogpage = hide;
                if (page == "product")
                    banner.productpage = hide;

                db.SaveChanges();
                return Json(new { code = 0, message = "Thành công" });
            }
            else
                return Json(new { code = 1, message = "Failed" });

        }

        [HttpPost]
        public ActionResult Upload(IEnumerable<HttpPostedFileBase> files)
        {
            var path = "";
            var filename = "";
            if (files != null)
            {
                foreach (var file in files)
                {
                    filename = DateTime.Now.ToString("dd-MM-yy-hh-mm-ss-") + file.FileName;
                    path = Path.Combine(Server.MapPath("~/Content/upload/img"), filename);
                    file.SaveAs(path);

                    Banners newBanner = new Banners();
                    newBanner.link = "/Content/upload/img/" + filename;
                    db.Banners.Add(newBanner);
                }

                db.SaveChanges();
            }

            return RedirectToAction("Index");
        }

        [HttpDelete]
        public ActionResult delete(int stt)
        {
            var banner = db.Banners.FirstOrDefault(s => s.stt == stt);
            if (banner != null)
            {
                db.Banners.Remove(banner);
                db.SaveChanges();
                return Json(new { code = 0, message = "Thành công" });
            }
            else
                return Json(new { code = 1, message = "Failed" });
        }
    }


    
}