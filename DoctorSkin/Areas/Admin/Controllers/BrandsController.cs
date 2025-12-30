using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoctorSkin.config;
using DoctorSkin.Models;

namespace DoctorSkin.Areas.Admin.Controllers
{
    public class BrandsController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();
        SlugifyConfig slugifyConfig = new SlugifyConfig();

        // GET: Admin/Brands
        public ActionResult Index()
        {
            return View(db.Brands.ToList());
        }
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Brands brands = db.Brands.Find(id);
            if (brands == null)
            {
                return HttpNotFound();
            }
            return View(brands);
        }

        public ActionResult Create()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Create(string namebrand)
        {
            if (ModelState.IsValid)
            {
                var newBrand = new Brands();
                newBrand.namebrand = namebrand;
                newBrand.hidebrand = false;
                newBrand.meta = slugifyConfig.slugify(namebrand);

                db.Brands.Add(newBrand);
                db.SaveChanges();
                return Json(new { code = 0, data = db.Brands.FirstOrDefault(s => s.namebrand == namebrand) });
            }

            return Json(new { code = 1, message = "Lỗi" });
        }

        // GET: Admin/Brands/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Brands brands = db.Brands.Find(id);
            if (brands == null)
            {
                return HttpNotFound();
            }
            return View(brands);
        }

        // POST: Admin/Brands/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Brands brands = db.Brands.Find(id);
            db.Brands.Remove(brands);
            db.SaveChanges();
            return RedirectToAction("Index");
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
