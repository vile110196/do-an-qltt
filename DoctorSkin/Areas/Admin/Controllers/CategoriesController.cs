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

    [Authorize]
    [Authorize(Roles ="Admin")]
    public class CategoriesController : Controller
    {
        private DoctorSkinEntities db = new DoctorSkinEntities();
        SlugifyConfig slugify = new SlugifyConfig();
        DateTime currentDateTime = DateTime.Now;

        // GET: Admin/Categories
        public ActionResult Index()
        {
            return View(db.Categories.ToList());
        }

        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Categories categories = db.Categories.Find(id);
            if (categories == null)
            {
                return HttpNotFound();
            }
            return View(categories);
        }



        [HttpPost]
        public ActionResult Create(string namec)
        {
            if (ModelState.IsValid)
            {
                var newCat = new Categories();
                newCat.namec = namec;
                newCat.meta = slugify.slugify(namec);
                newCat.date_up = DateTime.Parse(currentDateTime.ToString("yyyy-MM-dd HH:mm:ss"));

                db.Categories.Add(newCat);
                db.SaveChanges();
                return Json(new { code = 0, data = db.Categories.FirstOrDefault(s=>s.namec==namec) });
            }

            return Json(new { code = 1, message = "Lỗi" });
        }

        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Categories categories = db.Categories.Find(id);
            if (categories == null)
            {
                return HttpNotFound();
            }
            return View(categories);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "typep,namec,hide,date_up,meta")] Categories categories)
        {
            if (ModelState.IsValid)
            {
                db.Entry(categories).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(categories);
        }

        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Categories categories = db.Categories.Find(id);
            if (categories == null)
            {
                return HttpNotFound();
            }
            return View(categories);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Categories categories = db.Categories.Find(id);
            db.Categories.Remove(categories);
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
